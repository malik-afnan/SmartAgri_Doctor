import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MLService {
  late Interpreter _interpreter;
  late List<String> _labels;
  bool _isModelLoaded = false;

  /// Load the model and labels
  Future<void> loadModel() async {
    try {
      // Load the TFLite model (path must match pubspec.yaml assets entry)
      _interpreter =
          await Interpreter.fromAsset('assets/model/model_new.tflite');

      // Load labels (note: lables.txt spelling)
      final labelsData = await rootBundle.loadString('assets/model/lables.txt');
      _labels = labelsData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      _isModelLoaded = true;
      print('✅ Model loaded successfully with ${_labels.length} labels');
    } catch (e) {
      print('❌ Failed to load model: $e');
    }
  }

  /// Run prediction on an image file
  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (!_isModelLoaded) {
      throw Exception('Model not loaded. Call loadModel() first.');
    }

    // Decode image
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) throw Exception('Unable to decode image');

    // Get model input size from interpreter
    final inputShape = _interpreter.getInputTensor(0).shape;
    int height = inputShape[1];
    int width = inputShape[2];
    print('Model input size: $width x $height');

    // Resize the image
    final resized = img.copyResize(image, width: width, height: height);

    // Prepare input tensor: 1 x H x W x 3
    var input = List.generate(
      1,
      (_) => List.generate(
        height,
        (y) => List.generate(
          width,
          (x) {
            final pixel = resized.getPixel(x, y);
            final r = pixel.r / 255.0;
            final g = pixel.g / 255.0;
            final b = pixel.b / 255.0;
            return [r, g, b];
          },
        ),
      ),
    );

    // Prepare output buffer dynamically
    final outputTensor = _interpreter.getOutputTensor(0);
    var output = List.filled(outputTensor.shape.reduce((a, b) => a * b), 0.0)
        .reshape(outputTensor.shape);

    // Run inference
    _interpreter.run(input, output);

    // Handle output (assume [1, numLabels])
    final List<double> probabilities = List<double>.from(output[0]);
    final maxIndex = probabilities.indexWhere(
        (v) => v == probabilities.reduce((a, b) => a > b ? a : b));
    final confidence = probabilities[maxIndex];

    return {
      'label': _labels[maxIndex],
      'confidence': (confidence * 100).toStringAsFixed(2),
    };
  }

  void close() {
    _interpreter.close();
  }
}
