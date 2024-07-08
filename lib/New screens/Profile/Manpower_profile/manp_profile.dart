import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wayforce/New%20screens/Wallet/wallet_page.dart';

import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/UserInfo/man_info_services.dart';
import '../../../new_services/category_services.dart';
import '../../../new_services/global_constants.dart';
import '../../../new_services/update_manpower_category.dart';
import '../../My projects/Manpower My project/manp_activity_myproject.dart';
import '../../aboutus.dart';
import '../../alerts/new_loader.dart';
import '../../bottomnav bars/manp_bottom_navbar_provider.dart';
import '../../helpandsupport.dart';
import '../../onboardingScreen/onboardingscreen.dart';
import '../../ter_condition_policy_page.dart';
import 'man_profile_info.dart';
import 'package:http/http.dart' as http;

class ManProfile extends StatefulWidget {
  const ManProfile({super.key});

  @override
  State<ManProfile> createState() => _ManProfileState();
}

class _ManProfileState extends State<ManProfile> {
  
  ManpowerUserService _manpowerUserService = ManpowerUserService();
  Map<String, dynamic>? manpowerUserData;
  String? selectedCategory;
  List<String> categoryNames = [];
  List<String> categoryprice = [];
  @override
  void initState() {
    super.initState();
    
    fetchManpowerUserData();
    _loadCategories();
   
  }

  bool _isDropdownVisible = false;
  List<String> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();
  Future<void> _loadCategories() async {
    await CategoryService.fetchCategories();
    setState(() {
      categoryNames = CategoryService.getCategoryNames();
      categoryprice = CategoryService.getCategoryPrices().cast<String>();
    });
  }



  void sendTokenToBackend() async {
    print(GlobalConstant.firebaseToken);
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/update/EmployerToken/" +
            GlobalConstant.userID);

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

  Future<void> fetchManpowerUserData() async {
    
    try {
      final Map<String, dynamic>? data =
          await _manpowerUserService.fetchManpowerUserData();

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

  String aadharNumber = '';
  String otp = '';
  bool isAadharVerification = false;
  bool isOtpVerification = false;
  bool isKycVerified = false;
  String ?clientid;
  bool isAadharEntered = true;
Future<void> sendAadharNumberAndGetOTP(String aadharNumber) async {
    Loader().show(context);
  // Define the URL for sending Aadhar number
  String apiUrl = 'https://workwave-backend.vercel.app/api/v1/user/generate-otp'; // Replace with your actual API URL

  try {
       
    // Make the HTTP POST request to send Aadhar number
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {'id_number': aadharNumber},
    );

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the JSON response
      var responseData = json.decode(response.body);

      // Extract client ID from the response
      String clientId = responseData['data']['client_id'];

      // Check if OTP was sent successfully
      if (responseData['data']['otp_sent']) {
        // If OTP was sent successfully, continue with OTP submission
          clientid= clientId;
      setState(() {
        isOtpVerification = true;
         isAadharEntered = false;
      
      });
   
        showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          backgroundColor: AppColors.yellow,
          message: 'Otp sent on registered \nphone number  ',
        ),
      );
      Loader().dismiss(context);
      } else {
         showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: Colors.red,
          message: 'Something went wrong. Try again',
        ),
      );
        Loader().dismiss(context);
        // Handle case where OTP sending failed
        print('Failed to send OTP.');
      }
    } else {
       showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: Colors.red,
          message: 'Something went wrong. Try again',
        ),
      );
      Loader().dismiss(context);
      // Handle API call failure
      print('Failed to send Aadhar number. Status code: ${response.statusCode}');
    }
  } catch (error) {
    Loader().dismiss(context);
    // Handle any errors that occur during the API call
    print('Error occurred: $error');
  }
}

// Function to submit OTP
Future<void> submitOTP(String clientId, String otp, String userId) async {
    Loader().show(context);
  // Define the URL for submitting OTP
  String apiUrl = 'https://workwave-backend.vercel.app/api/v1/user/submit-otp'; // Replace with your actual API URL

  try {
    
    // Make the HTTP POST request to submit OTP
    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'client_id': clientId,
        'otp': otp,
        'userId': GlobalConstant.userID
      },
    );

    // Check if the response status code is 200 (OK)
    if (response.statusCode == 200) {
      setState(() {
        isKycVerified= true;
      });

        showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          backgroundColor: AppColors.green,
          message: 'KYC Verified ',
        ),
      );
      Loader().dismiss(context);
    Navigator.of(context).pop();
      // Parse the JSON response
      var responseData = json.decode(response.body);

      // Check if OTP submission was successful
      if (responseData['success']) {
        // Handle successful OTP submission
        print('OTP submitted successfully.');
      } else {
        showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          backgroundColor: Colors.red,
          message: 'Something went wrong. Try again',
        ),
      );
        Loader().dismiss(context);
        
        // Handle case where OTP submission failed
        print('Failed to submit OTP.');
      }
    } else {
      
      Loader().dismiss(context);
      // Handle API call failure
      print('Failed to submit OTP. Status code: ${response.statusCode}');
    }
  } catch (error) {
    Loader().dismiss(context);
    // Handle any errors that occur during the API call
    print('Error occurred: $error');
  }
}

  @override
  Widget build(BuildContext context) {
if (manpowerUserData?['isKyc'] == 'Yes') {
  isKycVerified = true;
  }

    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
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
          ),
        ),
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
                      Row(
                        children: [
                          Text(
                            manpowerUserData?['name'] ?? '   ',
                            style: SafeGoogleFont(
                              'Montserrat',
                              fontSize: mediaQuery.size.width * 0.07,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(
                            width: mediaQuery.size.width * 0.05,
                          ),
                        
                        ],
                      ),
                     Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) {
                                if (index < (manpowerUserData?['averageRating'] ).floor()) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: mediaQuery.size.width * 0.04,
                                  );
                                } else {
                                  return Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                    size: mediaQuery.size.width * 0.04,
                                  );
                                }
                              },
                            ),
                          ),
                         Text(
  '${(manpowerUserData?['averageRating'] is int 
        ? (manpowerUserData?['averageRating'] as int).toString()
        : (manpowerUserData?['averageRating'] as double).toStringAsFixed(1))}',
  style: SafeGoogleFont(
    'Montserrat',
    fontSize: mediaQuery.size.width * 0.04,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  ),
),

                        
                        ],
                      ),

                      SizedBox(height: mediaQuery.size.height * 0.005),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: mediaQuery.size.width * 0.05),
                          Builder(builder: (context) {
                            return Flexible(
                                child: Text(
                              manpowerUserData?['category']['name'] ?? '',
                              style: SafeGoogleFont(
                                'Montserrat',
                                fontSize: mediaQuery.size.width * 0.032,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                              overflow: TextOverflow.clip,
                            ));
                          }),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: mediaQuery.size.width * 0.042,
                            ), // Edit pencil icon
                            onPressed: () {
                              // Open a popup or dialog with category dropdown
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Category'),
                                    content: DropdownButtonFormField<Category>(
                                      items: CategoryService.categories
                                          .map((Category category) {
                                        return DropdownMenuItem<Category>(
                                          value: category,
                                          child: Text(category.name),
                                        );
                                      }).toList(),

                                      onChanged: (Category? value) {
                                        setState(() {
                                          selectedCategory = value
                                              ?.id; // Set selectedCategory to category id
                                        });
                                      },
                                      value: selectedCategory != null
                                          ? CategoryService.categories
                                              .firstWhere(
                                                  (category) =>
                                                      category.id ==
                                                      selectedCategory,
                                                  orElse: () => null!)
                                          : null, // Set the initial selected value
                                      decoration: InputDecoration(
                                        labelStyle:
                                            TextStyle(color: AppColors.black),
                                        labelText: 'Category',
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.id.isEmpty) {
                                          return 'Please select a category';
                                        }
                                        return null;
                                      },
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text(
                                          'Save',
                                          style: SafeGoogleFont(
                                            'Montserrat',
                                            fontSize:
                                                mediaQuery.size.width * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        onPressed: () {
//Loader().show(context);
                                          UpdateCategory().update(
                                              GlobalConstant.userID,
                                              manpowerUserData?['name'] ??
                                                  '   ',
                                              manpowerUserData?['mobile'] ?? '',
                                              selectedCategory!,
                                              manpowerUserData?['gender'] ?? '',
                                              manpowerUserData?['dob'] ?? '',
                                              manpowerUserData?['age'] ?? '   ',
                                              manpowerUserData?['address']
                                                      ['addressLine1'] ??
                                                  '   ',
                                              manpowerUserData?['address']
                                                      ['addressLine2'] ??
                                                  '   ',
                                              manpowerUserData?['address']
                                                      ['block'] ??
                                                  '   ',
                                              manpowerUserData?['address']
                                                      ['pinCode'] ??
                                                  '   ',
                                              manpowerUserData?['address']
                                                      ['city'] ??
                                                  '   ',
                                              manpowerUserData?['address']
                                                      ['state'] ??
                                                  '   ',
                                              manpowerUserData?['bio'] ?? '',
                                              manpowerUserData?[
                                                      'aadharNumber'] ??
                                                  '',
                                              manpowerUserData?[
                                                      'panCardNumber'] ??
                                                  '',
                                              manpowerUserData?['minSalary'] ??
                                                  '',
                                              manpowerUserData?['experience'] ??
                                                  '',
                                              context);
                                          Navigator.of(context).pop();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ManNavTab()));

                                          // Close the dialog
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text(
                                          'Cancel',
                                          style: SafeGoogleFont(
                                            'Montserrat',
                                            fontSize:
                                                mediaQuery.size.width * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: mediaQuery.size.width * 0.08,
                ),
                Column(
                  children: [
                    Stack(children: [
                      CircleAvatar(
                        radius: mediaQuery.size.width * 0.11,
                        backgroundColor: Colors
                            .grey[300], // Adjust the background color as needed
                        child: CircleAvatar(
                          radius: mediaQuery.size.width *
                              0.10, // Adjust the inner circle size as needed
                          backgroundImage: NetworkImage(
                            manpowerUserData?['profileImage'] ?? '',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: isKycVerified
                            ? Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: mediaQuery.size.width * 0.06,
                              ) // Golden color
                            : Icon(Icons.verified_user_outlined,
                                size: mediaQuery.size.width * 0.06,
                                color: isKycVerified
                                    ? Colors.green
                                    : Colors.grey),
                      )
                    ]),
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (!isKycVerified) {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                        left: mediaQuery.size.width * 0.035,
                                        right: mediaQuery.size.width * 0.035,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          //if(isAadharEntered = true)
                                         TextField(
  keyboardType: TextInputType.number,
  maxLength: 12,
  decoration: InputDecoration(
    labelText: 'Enter Aadhar Number',
    labelStyle: TextStyle(
      color: Colors.red, // Change the label color here
      fontSize: mediaQuery.size.width * 0.04, // Change the label font size here
    ),
  ),
  onChanged: (value) {
    setState(() {
      aadharNumber = value;
    });
    // Check if the length of input is 12 digits
    if (value.length == 12) {
      sendAadharNumberAndGetOTP( aadharNumber);

    }
  },
),

                                         // if (isOtpVerification && !isAadharEntered)
                                            Column(
                                              children: [
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: 'Enter OTP'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      otp = value;
                                                    });
                                                    if (value.length == 6) {
                             submitOTP(clientid!, otp, GlobalConstant.userID);

    }
    // Navigator.of(context).pop();
                                                  },
                                                      
                                                ),
                                            
        //                                         ElevatedButton(
        //                                           onPressed: () {
        //                                             print(otp);
        //  submitOTP(clientid!, otp, GlobalConstant.userID);
        //                                           },
        //                                           child: Text('Verify OTP'),
        //                                         ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            isKycVerified ? 'Verified' : 'Verify KYC',
                            style: SafeGoogleFont(
                              'Roboto',
                              fontSize: mediaQuery.size.width * 0.038,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            //  Padding(
            //    padding:  EdgeInsets.only(left: mediaQuery.size.width*0.67),
            //    child:
            //  ),
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
                              builder: (context) => WalletPage(
                                    last30dayorder: manpowerUserData?[
                                            'totalOrdersLast30Days'] ??
                                        '   ',
                                    last7daypay: manpowerUserData?[
                                            'totalPaymentLast7Days'] ??
                                        '   ',
                                    last30daypay: manpowerUserData?[
                                            'totalPaymentLast30Days'] ??
                                        '   ',
                                    last7dayorder: manpowerUserData?[
                                            'totalOrdersLast7Days'] ??
                                        '   ',
                                  )));
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
                              builder: (context) => const ManMyProjects()));
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
                        builder: (context) => const ManProfileInfo()));
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

       
          ],
        ),
      ),
    );
  }
}
