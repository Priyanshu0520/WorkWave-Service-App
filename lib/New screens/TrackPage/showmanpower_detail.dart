// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';


class ManpowerDetail extends StatefulWidget {
  var manpowerid;
  var rating;
  
  ManpowerDetail({
    required this.manpowerid,
    this.rating,
    Key? key,
  });

  @override
  State<ManpowerDetail> createState() => _ManpowerDetailState();
}

class _ManpowerDetailState extends State<ManpowerDetail> {
  
  Map<String, dynamic>? manpowerUserData;

  @override
  void initState() {
    super.initState();
    fetchManpowerUserData();
  }

  Future<void> fetchManpowerUserData() async {
 
    try {
      final Map<String, dynamic>? data =
          await _fetchManpowerUserData();

      if (data != null) {
        setState(() {
          manpowerUserData = data;
        });
        
      } else {
        print('Received null data from the API');
        // Handle the case when data is null, if needed
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
  Future<Map<String, dynamic>?> _fetchManpowerUserData() async {
    try {
       var id = widget.manpowerid;
         String _apiEndpoint =( 'https://workwave-backend.vercel.app/api/v1/manpower/$id');

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

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          textAlign: TextAlign.start,
          style: SafeGoogleFont(
            'Inter',
            fontSize: mediaQuery.size.width * 0.05,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * 0.02,
                  ),
                  Text(
                    'Detail of\nmanpower',
                    textAlign: TextAlign.start,
                    style: SafeGoogleFont(
                      'Inter',
                      fontSize: mediaQuery.size.width * 0.07,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                    width: mediaQuery.size.width * 0.2,
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(  manpowerUserData?['profileImage'] ?? ''
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU'),
                  ),
                ],
              ),
              Text(
                'Name',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Text(
                manpowerUserData?['name'] ?? '',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
               SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Text(
                'Address',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Text(
                manpowerUserData?['serviceLocation']['address'] ?? '',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
              Text(
                'Total order done ',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Row(
                children: [
                  Text(
                     manpowerUserData?['totalOrdersAllDays'].toString()??"",
                    textAlign: TextAlign.start,
                    style: SafeGoogleFont(
                      'Inter',
                      fontSize: mediaQuery.size.width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Text(
                'Avg Rating',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Row(
                children: [
          Text(
  '${(widget.rating is int 
        ? (widget.rating as int).toString()
        : (widget.rating as double).toStringAsFixed(1))}',
  style: SafeGoogleFont(
    'Montserrat',
    fontSize: mediaQuery.size.width * 0.04,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  ),
),
                  SizedBox(
                    width: mediaQuery.size.width * 0.01,
                  ),
                  Icon(Icons.star)
                ],
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
              Text(
                'Experience',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.01,
              ),
              Text(
                manpowerUserData?['experience'].toString()??"",
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
              
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
            
              Divider(),
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
              Text(
                'Help',
                textAlign: TextAlign.start,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: mediaQuery.size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: Text(
                  'Get help',
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.035,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
