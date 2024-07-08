import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String termurl = "https://workwave-backend.vercel.app/api/v1/page/slug/term-and-condition";
  static const String privacyurl = "https://workwave-backend.vercel.app/api/v1/page/slug/privacy-policy";
	
  Future<String> getTermsAndConditions() async {
    try {
      final response = await http.get(Uri.parse(termurl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
          final description = jsonResponse['data'][0]['description'];
          return description;
        } else {
          throw Exception('Invalid response format: Missing or empty "data" array');
        }
      } else {
        throw Exception('Failed to load terms and conditions. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
  
  Future<String> privacyandpolicy() async {
    try {
      final response = await http.get(Uri.parse(privacyurl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('data') && jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
          final description = jsonResponse['data'][0]['description'];
          return description;
        } else {
          throw Exception('Invalid response format: Missing or empty "data" array');
        }
      } else {
        throw Exception('Failed to load terms and conditions. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
