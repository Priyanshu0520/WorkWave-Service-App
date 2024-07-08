import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wayforce/New%20screens/alerts/new_loader.dart';
import 'package:wayforce/new_services/global_constants.dart';
import '../new utils/colors.dart';

class UpdateCategory {
  
  //put api for category update of manpower.........



Future<void> update(String userId,

  String name,
    String phone,
    String ?selectedCategory,
    String gender,
     dob,
     int age,
      String address1,
    String address2,
    String block,
    String pincode,
    String city,
    String state,
        String bio,
    String aadhar,
    String pan,
     String minsalary,
      int exper,


      BuildContext context) async {
   Loader().show(context);

  final Uri uri = Uri.parse('https://workwave-backend.vercel.app//api/v1/user/$userId');
  print('API calling....');
  try {
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Content-Type'] = 'multipart/form-data';

    final Map<String, dynamic> formData = {
       'name': name,
      'age': age.toString(),
      'gender': gender,
      'dob': dob.toString(),
      'mobile': phone,
      'category': selectedCategory,
       'address[addressLine1]': address1,
      'address[addressLine2]': address2,
      'address[block]': block,
      'address[pinCode]': pincode,
      'address[state]': state,
      'address[city]': city,
      'address[country]': 'India',
  'speakingLanguage': "Hindi",
  'userType': GlobalConstant.userType.toString(), 
  'panCardNumber': pan,
      'aadharNumber': aadhar,
       'bio': bio,
       'minSalary': minsalary,
         'experience': exper.toString(), // Adjust this line to send a list of languages
  // Add other form fields as needed
};

    // Add form fields
    formData.forEach((key, value) {
      request.fields[key] = value;
    });

    final response = await http.Response.fromStream(await request.send());

    print('API call completed');

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      Loader().dismiss(context);
      // Handle success, if needed
    } else if (response.statusCode == 400) {
      Loader().dismiss(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: AppColors.black,
        content: Text(
          "Something went wrong..",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      // Handle other status codes, if needed
    }
  } catch (e) {
    print('Error updating category: $e');
    Loader().dismiss(context);
    // Handle error, if needed
  }
}
}