// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../shared_pref_service.dart';
import '../global_constants.dart';

class ManpowerUserService {
  

  Future<Map<String, dynamic>?> fetchManpowerUserData() async {
    try {
       String? userData = await SharedPreferencesHelper.getUserData();
         String _apiEndpoint =( 'https://workwave-backend.vercel.app/api/v1/manpower/'+ GlobalConstant.userID);

      final response = await http.get(Uri.parse(_apiEndpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if 'data' field exists and is not null
        if (responseData.containsKey('data') && responseData['data'] != null) {
          return responseData['data'];
        } else {
          print('Invalid response format. Missing or null "data" field.');
          return null;
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
