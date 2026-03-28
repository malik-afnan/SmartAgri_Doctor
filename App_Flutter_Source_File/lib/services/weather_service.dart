import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Replace this with your actual WeatherAPI key
  static const String _apiKey = '6912b4d0d83b458f878194356252810';

  // Fetches weather data and returns temp + description
  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.https(
      'api.weatherapi.com',
      '/v1/current.json',
      {
        'key': _apiKey,
        'q': city,
        'aqi': 'no',
      },
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final double temp = (data['current']['temp_c'] as num).toDouble();
      final String desc = data['current']['condition']['text'];
      return {'temp': temp, 'desc': desc};
    } else {
      throw Exception('Weather fetch failed: ${res.statusCode} - ${res.body}');
    }
  }
}
