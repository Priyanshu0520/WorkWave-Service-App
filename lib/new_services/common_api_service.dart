import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommonAPIService {
  Future common_Get_OTP(phone) async {
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/sendotpEmployerLogin");
    print("request url: " + requestUri.toString());
    Map userPhone = {"phoneNumber": phone};
    var jsonBody = jsonEncode(userPhone);

    var response = await http.post(
      requestUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );
    var data = jsonDecode(response.body);
    print(data['otp'].toString());
  }
}
class UserProvider with ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  void setUserId(String newUserId) {
    _userId = newUserId;
    notifyListeners();
  }
}