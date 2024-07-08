import 'dart:convert';

import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayforce/New%20screens/Wallet/wallet_page.dart';

import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/UserInfo/emp_info_services.dart';
import '../../../new_services/global_constants.dart';
import '../../My projects/Employer my project/emp_activity_myproject.dart';
import '../../aboutus.dart';
import '../../helpandsupport.dart';
import '../../onboardingScreen/onboardingscreen.dart';
import '../../ter_condition_policy_page.dart';
import 'emp_Profile_info.dart';
import 'package:http/http.dart' as http;


class EmpProfile extends StatefulWidget {
  const EmpProfile({super.key});

  @override
  State<EmpProfile> createState() => _EmpProfileState();
}

class _EmpProfileState extends State<EmpProfile> {
  EmployerUserService _employerUserService = EmployerUserService();
  Map<String, dynamic>? employerUserData;
  @override
  void initState() {
    super.initState();
    fetchEmployerUserData();
    
  }

  void sendTokenToBackend() async {
    print(GlobalConstant.firebaseToken); 
    var requestUri = Uri.parse("http://3.110.135.177/api/api/v1/employer/update/EmployerToken/" + GlobalConstant.userID);

    await http
      .put(requestUri, 
      body: jsonEncode({"newToken": 'logged out'}), 
      headers: {
        'Content-Type': 'application/json',
      })
      .timeout(Duration(seconds: 30))
      .then((http.Response response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var jsonResponse = jsonDecode(response.body);
          print('321111${jsonResponse}');
        } else if (response.statusCode == 400) {
          print('tyt1: ${response}');
        } else if (response.statusCode == 401 || response.statusCode == 422) {
          print('tyt2: ${response}');
        } else if (response.statusCode == 500) {
          print('tyt: ${response}');
        }
      })
      .catchError((error) {
        print(error);
      });
  }

  Future<void> fetchEmployerUserData() async {
    try {
      final Map<String, dynamic>? data =
          await _employerUserService.fetchEmployerUserData();

      if (data != null) {
        setState(() {
          employerUserData = data;
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
var profilepic= 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU';
  @override
  Widget build(BuildContext context) {
    
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                        'Work',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: mediaQuery.size.width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Wave',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: mediaQuery.size.width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                ],
              ),),
        body: Column(
          
          children: [
            Divider(),
            Row(
              children: [
                SizedBox(
                  width: mediaQuery.size.width * 0.05,
                ),
                Container(
                  width: mediaQuery.size.width * 0.60,
                
                  child: Column(
                    children: [
                      Text(
                        employerUserData?['name'] ?? '  ',
                        style: SafeGoogleFont(
                          'Montserrat',
                          fontSize: mediaQuery.size.width * 0.07,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.005),
                      Text(
                        'Employer',
                        style: SafeGoogleFont(
                          'Montserrat',
                          fontSize: mediaQuery.size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: mediaQuery.size.width * 0.10,
                ),
                 CircleAvatar(
                  radius: mediaQuery.size.width * 0.11,
                       backgroundColor: Colors.grey[300],
                   child: CircleAvatar(
                    radius: mediaQuery.size.width * 0.10,
                    backgroundImage: NetworkImage(
                        employerUserData?['profileImage'] ?? profilepic ),
                                   ),
                 )
              ],
            ),
             SizedBox(
              height: mediaQuery.size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: mediaQuery.size.height * 0.12,
                  width: mediaQuery.size.width * 0.27,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(BorderSide(
                        width: mediaQuery.size.width * 0.001,
                        color: Colors.black)),
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HelpAndSupportPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.help_center_rounded, size: 30),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Text(
                              "Help",
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: mediaQuery.size.width * 0.037,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaQuery.size.width * 0.05,
                ),
                Container(
                  height: mediaQuery.size.height * 0.12,
                  width: mediaQuery.size.width * 0.27,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(BorderSide(
                        width: mediaQuery.size.width * 0.001,
                        color: Colors.black)),
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalletPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.payment_rounded, size: 30),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Text(
                              "Payment",
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: mediaQuery.size.width * 0.037,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaQuery.size.width * 0.05,
                ),
                Container(
                  height: mediaQuery.size.height * 0.12,
                  width: mediaQuery.size.width * 0.27,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(BorderSide(
                        width: mediaQuery.size.width * 0.001,
                        color: Colors.black)),
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmployerMyProject()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.local_activity_sharp, size: 30),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Text(
                              "Activity",
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: mediaQuery.size.width * 0.037,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: mediaQuery.size.height * 0.01),
            const Divider(
              color: AppColors.blackShadow,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.account_box_rounded),
              title: Text(
                'Profile Info',
                style: SafeGoogleFont(
                  'Roboto',
                  fontSize: mediaQuery.size.width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileInfo()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy),
              title: Text(
                'Terms and Policy',
                style: SafeGoogleFont(
                  'Roboto',
                  fontSize: mediaQuery.size.width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndPrivacyPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: Text(
                'About Us',
                style: SafeGoogleFont(
                  'Roboto',
                  fontSize: mediaQuery.size.width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutUs()));
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.share),
            //   title: Text(
            //     'Share',
            //     style: SafeGoogleFont(
            //       'Roboto',
            //       fontSize: mediaQuery.size.width * 0.035,
            //       fontWeight: FontWeight.w500,
            //       color: AppColors.black,
            //     ),
            //   ),
            //   onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const AboutUs()));
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                'Logout',
                style: SafeGoogleFont(
                  'Roboto',
                  fontSize: mediaQuery.size.width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      surfaceTintColor: AppColors.blackShadow,
                      title: Text(
                        "Log Out",
                        style: SafeGoogleFont(
                          'Roboto',
                          fontSize: mediaQuery.size.width * 0.035,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      content: Text(
                        "Are you sure?",
                        style: SafeGoogleFont(
                          'Roboto',
                          fontSize: mediaQuery.size.width * 0.035,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            "No",
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: mediaQuery.size.width * 0.035,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // dismiss the dialog
                          },
                        ),
                        TextButton(
                          child: Text(
                            "Yes",
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: mediaQuery.size.width * 0.035,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          onPressed: () async {
                            sendTokenToBackend();
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            GlobalConstant().clear();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OnBoardingScreen()));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // Delete Employer
            // ListTile(
            //   leading: const Icon(Icons.share),
            //   title: Text(
            //     'Delete Employer',
            //     style: SafeGoogleFont(
            //       'Roboto',
            //       fontSize: mediaQuery.size.width * 0.035,
            //       fontWeight: FontWeight.w500,
            //       color: AppColors.black,
            //     ),
            //   ),
            //   onTap: () async{
            //     var requestUri = Uri.parse("http://3.110.135.177/api/api/v1/user/" + GlobalConstant.userID);

            //     await http
            //       .delete(requestUri, 
            //       headers: {
            //         'Content-Type': 'application/json',
            //       })
            //       .timeout(Duration(seconds: 30))
            //       .then((http.Response response) async {
            //         if (response.statusCode == 200 || response.statusCode == 201) {
            //           var jsonResponse = jsonDecode(response.body);
            //           print(jsonResponse);
            //           final SharedPreferences prefs =
            //               await SharedPreferences.getInstance();
            //           prefs.clear();
            //           GlobalConstant().clear();
            //           Navigator.of(context)
            //               .popUntil((route) => route.isFirst);
            //           Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => OnBoardingScreen()));
            //         } else if (response.statusCode == 400) {
            //           print(response);
            //         } else if (response.statusCode == 401 || response.statusCode == 422) {
            //           print(response);
            //         } else if (response.statusCode == 500) {
            //           print(response);
            //         }
            //       })
            //       .catchError((error) {
            //         print(error);
            //       });
            //   },
            // ),


          ],
        ),
      ),
    );
  }
}
