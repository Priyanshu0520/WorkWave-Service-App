import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:wayforce/New%20screens/alerts/new_loader.dart';
import 'package:wayforce/New%20screens/login_screen.dart';
import 'package:wayforce/new_services/global_constants.dart';
import '../New screens/new_signup/register_form.dart';
import '../new utils/colors.dart';



class SignupAPIService {
  Future signup_get_OTP_ID(phoneNumber, context) async {
    Loader().show(context);
    var map = {
      "mobile": phoneNumber.toString(),
      "userType": GlobalConstant.userType.toString()
    };
    var requestUri =
        Uri.parse("https://workwave-backend.vercel.app/api/v1/user/signupUser");
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
            GlobalConstant.userID = jsonResponse['data']['_id'];
            GlobalConstant.signupOTP = jsonResponse['otp'];
            Loader().dismiss(context);
            debugPrint(
                GlobalConstant.signupOTP + " - " + GlobalConstant.userID);
            // DebugUtils.printWrapped(" Response:${response.body}");
          } else if (response.statusCode == 401 || response.statusCode == 422 || response.statusCode == 500) {
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.black,
              content: Text(
                "Something went Wrong..",
                style: TextStyle(color: Colors.white),
              )));
          } else if (response.statusCode == 409) {
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.black,
              content: Text(
                "Number exist. Please login",
                style: TextStyle(color: Colors.white),
              )));
          }
        })
        .catchError((error) {
          print(error);
          Loader().dismiss(context);
        });
  }

  // signup verify otp
  Future signup_verify_OTP(enteredOTP, context) async {
    Loader().show(context);
    var map = {"otp": enteredOTP.toString()};
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/user/signupUserVerifyOtp/" +
            GlobalConstant.userID);
    print("request url: " + requestUri.toString());
    var jsonBody = const JsonEncoder().convert(map);

    await http
        .post(requestUri, body: jsonBody, headers: {
          'Content-Type': 'application/json',
        })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          // LoaderWidget.hideLoader(context);
          print(response.statusCode);
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
            Loader().dismiss(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterFormScreen()));
          } else if (response.statusCode == 401 || response.statusCode == 404) {
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.black,
              content: Text(
                "OTP is incorrect",
                style: TextStyle(color: Colors.white),
              )));
          } else if (response.statusCode == 500) {
            Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.black,
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



Future<void> registerUser(
    String name,
    String phone,
    String ?selectedCategory,
    String gender,
     dob,
    int age,
    String email,
    String address1,
    String address2,
    String block,
    String pincode,
    String city,
    String state,
    String bio,
    String aadhar,
    //String pan,
    String minsalary,
    //String maxsalry,
    int exper,
    File? profilepic,
    File? aadharimage,
    // File? panimage,
    context
    ) async {
       Loader().show(context);
  final Uri uri = Uri.parse('https://workwave-backend.vercel.app/api/v1/user/register');
  print('api calling....');
  try {
    final request = http.MultipartRequest('POST', uri)
      ..headers['Content-Type'] = 'multipart/form-data';

    final Map<String, String> formData = {
      'name': name,
      'age': age.toString(),
      'gender': gender,
      'dob': dob.toString(),
      //'category': selectedCategory ??"",
      'experience': exper.toString(),
      'minSalary': minsalary,
     // 'maxSalary': maxsalry,
      'userType': GlobalConstant.userType.toString(),
      'bio': bio,
    //  'panCardNumber': pan,
      'aadharNumber': aadhar,
      'mobile': phone,
      'email': email,
      'address[addressLine1]': address1,
      'address[addressLine2]': address2,
      'address[block]': block,
      'address[pinCode]': pincode,
      'address[state]': state,
      'address[city]': city,
      'address[country]': 'India',
      'speakingLanguage[]': 'Hindi, English',
    };


  if (selectedCategory != null) {
      formData['category'] = selectedCategory;
    }
    // Add form fields
    formData.forEach((key, value) {
      request.fields[key] = value;
    });

    //Add image files
    request.files.add(await http.MultipartFile.fromPath(
      'profileImage',
      profilepic!.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    request.files.add(await http.MultipartFile.fromPath(
      'aadharImage',
      aadharimage!.path,
      contentType: MediaType('image', 'jpeg'),
    ));
    // request.files.add(await http.MultipartFile.fromPath(
    //   'panImage',
    //   panimage!.path,
    //   contentType: MediaType('image', 'jpeg'),
    // ));

    final response = await http.Response.fromStream(await request.send());

    print('api call completed');

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
   var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
            GlobalConstant.authToken = jsonResponse['token'];
             print('authToken: ${jsonResponse['token']}');
            GlobalConstant.userID = jsonResponse['id'];
             print('userID: ${jsonResponse['id']}');
            GlobalConstant.userphone = jsonResponse['mobile'];
             print('userphone: ${jsonResponse['mobile']}');
            print(jsonResponse);
            Loader().dismiss(context);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
    } else if (response.statusCode == 400) {
      Loader().dismiss(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppColors.black,
              content: Text(
                "Something went Wrong..",
                style: TextStyle(color: Colors.white),
              )));
    } else {
      
    }
  } catch (e) {
   
    print('Error registering user: $e');
  }
    }


}

  // Future signup_Register_form(
  //     name, phone, selectedCategory, gender, dob, age, email, address1, address2 , block, pincode, city,state, bio, aadhar, pan , minsalary, maxsalry,exper,
  // context) async {
  //   Loader().show(context);
  //   var map = new Map<String, dynamic>();
  //   map['name'] = name;
  //   map['age'] = age;
  //   map['category'] = selectedCategory;
  //   map['gender'] = gender;
  //   map['dob'] = dob;
  //   map['mobile'] = phone;
  //   map['email'] = email;
  //   map['experience'] = exper;
  //   map['minSalary'] = minsalary;
  //   map['maxSalary'] = maxsalry;
  //   map['speakingLanguage'] = ' Hindi , English ';
  //   map['addressLine1'] = address1;
  //   map['addressLine2'] = address2;
  //   map['block'] = block;
  //   map['pinCode'] = pincode;
  //   map['state'] = state;
  //   map['city'] = city;
  //   map['country'] = 'India';
  //   map['bio'] = bio;
  //   map['panCardNumber'] = pan;
  //   map['aadharNumber'] = aadhar;
   
  //   map['userType'] = GlobalConstant.userType.toString();
   
  //   var requestUri = Uri.parse("http://3.110.135.177/api//api/v1/user/register");
  //   print("request url: " + requestUri.toString());
  //   var jsonBody = const JsonEncoder().convert(map);
  //  print(jsonBody);
  
  //   await http
  //       .post(requestUri, body: jsonBody, headers: {
  //         'Content-Type': 'application/json',
  //       })
  //       .timeout(Duration(seconds: 30))
  //       .then((http.Response response) async {
  //         if (response.statusCode == 200 || response.statusCode == 201) {

            // var jsonResponse = jsonDecode(response.body);
            // print(jsonResponse);
            // GlobalConstant.authToken = jsonResponse['token'];
            // GlobalConstant.userID = jsonResponse['id'];
            // GlobalConstant.userphone = jsonResponse['mobile'];
            // print(jsonResponse);
            // Loader().dismiss(context);
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => LoginScreen()));
        //   } else if (response.statusCode == 401 || response.statusCode == 422 || response.statusCode == 500) {
            // Loader().dismiss(context);
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   backgroundColor: AppColors.black,
            //   content: Text(
            //     "Something went Wrong..",
            //     style: TextStyle(color: Colors.white),
            //   )));
        //   }
        // })
        // .catchError((error) {
        //   print(error);
        //   Loader().dismiss(context);
        // });
  // }
