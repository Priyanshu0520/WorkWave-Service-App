import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wayforce/New%20screens/alerts/new_loader.dart';
import 'package:wayforce/New%20screens/bottomnav%20bars/manp_bottom_navbar_provider.dart';
import 'package:wayforce/new_services/global_constants.dart';
import 'package:wayforce/shared_pref_service.dart';

import '../New screens/bottomnav bars/emp_bottom_navbar_provider.dart';
import '../new utils/colors.dart';
// import 'package:wayforce/utils/APIConstants.dart';

class LoginAPIService {
  Future Login_Get_OTP(enteredphone, context) async {
    Loader().show(context);
    var map = {
      "mobile": enteredphone.toString(),
      "userType": GlobalConstant.userType.toString()
    };
    var requestUri = Uri.parse("https://workwave-backend.vercel.app/api/v1/user/getOtp");
    print("request url: " + requestUri.toString());
    var jsonBody = const JsonEncoder().convert(map);

    await http
        .put(requestUri, body: jsonBody, headers: {
          'Content-Type': 'application/json',
        })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          // LoaderWidget.hideLoader(context);
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print('jsonResponse ${jsonResponse}');
            GlobalConstant.loginOTP = jsonResponse['otp'];
            Loader().dismiss(context);
            // DebugUtils.printWrapped(" Response:${response.body}");
          } else if (response.statusCode == 400) {
              print('jsonResponse ${response}');
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.black,
              content: Text(
                "Number not register. Please Signup",
                style: TextStyle(color: Colors.white),
              )));
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print(response.body);
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "Something went Wrong..",
                style: TextStyle(color: Colors.white),
              )));
          } else if (response.statusCode == 500) {
              print('js ${response}');
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "Something went Wrong..",
                style: TextStyle(color: Colors.white),
              )));
          }
        })
        .catchError((error) {
          print(error);
          Loader().dismiss(context);
        });
  }

  Future loginRequest(enteredPhone, enteredOTP, context) async {
    Loader().show(context);
    var map = {
      "mobile": enteredPhone,
      "otp": enteredOTP,
      "userType": GlobalConstant.userType
    };
    var requestUri = Uri.parse("https://workwave-backend.vercel.app/api/v1/user/login");
    print("request url: " + requestUri.toString());
    var jsonBody = const JsonEncoder().convert(map);

    await http
        .post(requestUri, body: jsonBody, headers: {
          'Content-Type': 'application/json',
        })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          // LoaderWidget.hideLoader(context);
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
            GlobalConstant.authToken = jsonResponse['token'];
            GlobalConstant.userID = jsonResponse['_id'];
            GlobalConstant.userName = jsonResponse['name'];
            
            // store login data in shared preferences
            var allUserData = {
              "authToken": GlobalConstant.authToken,
              "userID": GlobalConstant.userID,
              "userType": GlobalConstant.userType,
              "userphone": GlobalConstant.userphone,
              "userName": GlobalConstant.userName,
            };
            SharedPreferencesHelper.setUserData(jsonEncode(allUserData));

            Loader().dismiss(context);
            if (GlobalConstant.userType == "Manpower") {
              print('manpower');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ManNavTab()));
            } else {
                  print('employer');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EmpNavTab()));
            }
          } else if (response.statusCode == 404) {
            Loader().dismiss(context);
          // var jsonResponse = jsonDecode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "OTP is incorrect",
                style: TextStyle(color: Colors.white),
              )));
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            Loader().dismiss(context);
            // ignore: unused_local_variable
            var jsonResponse = jsonDecode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "Something went Wrong..",
                style: TextStyle(color: Colors.white),
              )));
          } else if (response.statusCode == 500) {
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                "Something went Wrong..",
                style: TextStyle(color: Colors.white),
              )));
          //  var jsonResponse = jsonDecode(response.body);
          }
        })
        .catchError((error) {
          print(error);
          Loader().dismiss(context);
        });
  }
}
