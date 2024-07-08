// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayforce/New%20screens/TrackPage/employer_track_page.dart';
import 'package:wayforce/New%20screens/TrackPage/manpower_track_page.dart';
import 'package:wayforce/new%20utils/utils.dart';
import 'package:wayforce/new_services/global_constants.dart';
import '../../new utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:math' as Math;

class NewPushNotification {
  bool isDisplayed = false;
  String orderId = '';
  String empId = '';
  String category = '';

  getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat;
    var dLon;
    if (lat2 > lat1 && lon2 > lon1) {
      dLat = deg2rad(lat2 - lat1); // deg2rad below
      dLon = deg2rad(lon2 - lon1);
    } else if (lat2 < lat1 && lon2 < lon1) {
      dLat = deg2rad(lat1 - lat2); // deg2rad below
      dLon = deg2rad(lon1 - lon2);
    } else {
      return 0;
    }
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  deg2rad(deg) {
    return deg * (Math.pi / 180);
  }

   void showNewNotification(_context, notificationTitle, notificationBody, data) async {
    print(data);

    Future<void> clearPrefBackgroundData() async {
      SharedPreferences prefrences = await SharedPreferences.getInstance();
      await prefrences.remove("firebaseBackgroundNotificationData");
    }
    await clearPrefBackgroundData();

    // *********************  Show Notifications to Manpower ************************

    // 1 - Manpower
    // Show notification to Manpower
    // show dialog to Manpowers if : request cancel by employer
      if(notificationBody == "Session Expired" ){
      if(GlobalConstant.notificationPopupDisplayed == true){
        GlobalConstant.notificationPopupDisplayed = false;
        Navigator.of(_context).pop(); // dismiss firstly opened accept reject dialog
      }
      // show dialog to Manpowers if : request cancel by employer
      Future<void> stopAudio() async {
        IsolateNameServer.lookupPortByName('way')?.send("stop");
        await FlutterRingtonePlayer.stop();
      }
      await stopAudio();

      showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (BuildContext context) {
          GlobalConstant.notificationPopupDisplayed = true;
          FlutterRingtonePlayer.playNotification(volume: 0.2);
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              "Session Expired",
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),              
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async{
                  GlobalConstant.notificationPopupDisplayed = false;
                  Navigator.of(context).pop(); // dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }

if(notificationBody == "Cancle By Employer" ){
      if(GlobalConstant.notificationPopupDisplayed == true){
        GlobalConstant.notificationPopupDisplayed = false;
        Navigator.of(_context).pop(); // dismiss firstly opened accept reject dialog
      }
      // show dialog to Manpowers if : request cancel by employer
      Future<void> stopAudio() async {
        IsolateNameServer.lookupPortByName('way')?.send("stop");
        await FlutterRingtonePlayer.stop();
      }
      await stopAudio();

      showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (BuildContext context) {
          GlobalConstant.notificationPopupDisplayed = true;
          FlutterRingtonePlayer.playNotification(volume: 0.2);
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              "Cancle By Employer",
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),              
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async{
                  GlobalConstant.notificationPopupDisplayed = false;
                  Navigator.of(context).pop();
                  // dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
    // 2 - Manpower
    // Show notification to Manpower
    // show dialog to Manpowers if : New Work Request
  Timer? _ringingTimer;
void startTimer() {
    _ringingTimer = Timer(Duration(minutes: 1), () {
     
      FlutterRingtonePlayer.stop();
      GlobalConstant.notificationPopupDisplayed = false;
       Navigator.of(_context).pop(); // dismiss the dialog
    });
  }
void cancelTimer() {
  _ringingTimer?.cancel();
}

    if (notificationTitle.contains('Lead for') &&
        notificationBody != "Session Expired") {
      if (GlobalConstant.notificationPopupDisplayed == true) {
        GlobalConstant.notificationPopupDisplayed = false;
        Navigator.of(_context)
            .pop(); // dismiss firstly opened accept reject dialog
      }
      var orderID = data.split('~#')[3].split(':')[1];
      bool orderStatus = await checkOrderStatus(_context, orderID);
      print(orderStatus);
      if (orderStatus) {
        Future<void> stopAudio() async {
          IsolateNameServer.lookupPortByName('way')?.send("stop");
          await FlutterRingtonePlayer.stop();
        }

        calculateDistance() async {
          var distance = Geolocator.distanceBetween(
            double.parse(data.split('~#')[11].split(":")[1]),
            double.parse(data.split('~#')[12].split(":")[1]),
            double.parse(data.split('~#')[5].split(":")[1]),
            double.parse(data.split('~#')[6].split(":")[1]),
          );
          double distanceInKm = distance / 1000;
          print('DISTANCE: $distanceInKm kilometers');
          return distanceInKm.toStringAsFixed(2);
        }

        await stopAudio();
        var distance = await calculateDistance();
        GlobalConstant.distanceBetweenOrderAndManpower = distance;
        showDialog(
            barrierDismissible: false,
            context: _context,
            builder: (BuildContext context) {
              GlobalConstant.notificationPopupDisplayed = true;
              stopPlay() async {
                await FlutterRingtonePlayer.stop();
                await FlutterRingtonePlayer.play(
                  android: AndroidSounds.notification,
                  ios: IosSounds.glass,
                  looping: true, // Android only - API >= 28
                  volume: 0.2, // Android only - API >= 28
                  asAlarm: false, // Android only - all APIs
                );
              }

              stopPlay();
              var mediaQuery = MediaQuery.of(context);
              return AlertDialog(
                surfaceTintColor: AppColors.blackShadow,
                title: Text(
                  "New work request",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Container(
                    width: mediaQuery.size.width * 0.95,
                    height: mediaQuery.size.height * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                           "At : " + data.split('~#')[4].split(":")[1],
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.009,
                        ),
                        Text(
                          'From : ' + data.split('~#')[1].split(":")[1],
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.009,
                        ),
                        Text(
                          "Duration : " +
                              data.split('~#')[13].split(":")[1] +
                              "hrs",
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.009,
                        ),
                        Text(
                          "Payment : " +
                              data.split('~#')[14].split(":")[1],
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.008,
                        ),
                        Text(
                          "Distance : $distance Km",
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * 0.009,
                        ),
                        Text(
                          data.split('~#')[8].split(":")[1],
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    )),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: TextButton(
                        child: Text(
                          "Accept",
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: AppColors.green,
                          ),
                        ),
                        onPressed: () async {
                          await FlutterRingtonePlayer.stop();
                          GlobalConstant.notificationPopupDisplayed = false;
                          Navigator.of(context).pop(); // dismiss the dialog
                          orderId =
                              data.split('~#')[3].split(':')[1].toString();
                          empId = data.split('~#')[0].split(':')[1].toString();
                          category = data
                              .split('~#')[2]
                              .split(',')[1]
                              .split(':')[1]
                              .toString();

                          sendConformationToEmplyee(
                              _context, orderId, empId, category);
                              cancelTimer();
                        },
                      )),
                      SizedBox(
                        width: mediaQuery.size.width * 0.05,
                      ),
                      Center(
                          child: TextButton(
                        child: Text(
                          "Reject",
                          style: SafeGoogleFont(
                            'Roboto',
                            fontSize: mediaQuery.size.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        onPressed: () async {
                          await FlutterRingtonePlayer.stop();
                          GlobalConstant.notificationPopupDisplayed = false;
                          Navigator.of(context).pop(); // dismiss the dialog
                        },
                      )),
                    ],
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.005,
                  ),
                ],
              );
            }
            
            );
              startTimer();
      }
    }

    // *********************  Show Notifications to Employer ************************

    // 1 - Employer
    // Employer -> Show notification to Employer
    // show dialog to Employer if : request accepted by manpower
    if (notificationTitle == "Request Accept") {
      // if (GlobalConstant.notificationPopupDisplayed == true) {
      //   GlobalConstant.notificationPopupDisplayed = false;
      //   Navigator.of(_context)
      //       .pop(); // dismiss firstly opened accept reject dialog
      // }.....
      Future<void> stopAudio() async {
        IsolateNameServer.lookupPortByName('way')?.send("stop");
        await FlutterRingtonePlayer.stop();
      }

      await stopAudio();

      showDialog(
        barrierDismissible: false,
        context: _context,
        builder: (BuildContext context) {
          // GlobalConstant.notificationPopupDisplayed = true;
          FlutterRingtonePlayer.playNotification(volume: 0.4);
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              notificationBody.toString(),
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            actions: [
              TextButton(
                  child: Text(
                    "Ok",
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: mediaQuery.size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  onPressed: () async {
                    Future<String> getOtpSendToManpower(String orderId) async {
                      final apiUrl =
                          'https://workwave-backend.vercel.app//api/v1/employer/get/getStatusOfOrderId?orderId=$orderId';

                      try {
                        print('url${apiUrl}');
                        final response = await http.get(Uri.parse(apiUrl));

                        if (response.statusCode == 200) {
                          final Map<String, dynamic> jsonResponse =
                              json.decode(response.body);
                          final String otp =
                              jsonResponse['data']['otpSendToEmployer'];
                          return otp;
                        } else {
                          // Handle the error, you might want to throw an exception or return an error message
                          throw Exception(
                              'Failed to load data, status code: ${response.statusCode}');
                        }
                      } catch (error) {
                        // Handle the error, you might want to throw an exception or return an error message
                        throw Exception('Failed to load data: $error');
                      }
                    }

                    String otp = await getOtpSendToManpower(
                        GlobalConstant.instantHireOrderId);
                    Future<String> getManpowerId(String orderId) async {
                      final apiUrl =
                          'https://workwave-backend.vercel.app//api/v1/employer/getStartEmdTimeByOrderId/$orderId'; //

                      try {
                        print('urrlllrr${apiUrl}');
                        final response = await http.get(Uri.parse(apiUrl));

                        if (response.statusCode == 200) {
                          final Map<String, dynamic> jsonResponse =
                              json.decode(response.body);
                          final String manpowerId =
                              jsonResponse['manpowerId']['_id'];
                          return manpowerId;
                        } else {
                          // Handle the error, you might want to throw an exception or return an error message
                          throw Exception(
                              'Failed to load data, status code: ${response.statusCode}');
                        }
                      } catch (error) {
                        // Handle the error, you might want to throw an exception or return an error message
                        throw Exception('Failed to load data: $error');
                      }
                    }

                    GlobalConstant.notificationPopupDisplayed = false;
                  //  Navigator.of(context).popUntil((route) => route.settings.name == '/emphomepage'); // pop until the first route
                    print('iiiiiiiiiiiii${GlobalConstant.instantHireOrderId}');
                    //  if (data.split('~#')[3].split(':')[1].toString() == null)
                    // Fetch manpowerId
                    String manpowerId =
                        await getManpowerId(GlobalConstant.instantHireOrderId);
                    //String otp = await getManpowerId(GlobalConstant);
                    print('manpower idd${manpowerId}');
                    // Navigate to EmployeTrack with the fetched manpowerId
                    GlobalConstant.notificationPopupDisplayed = false;
                  Navigator.of(context).pop(); // dismiss the dialog
                  Navigator.of(context).pop(); // dismiss the dialog
                  Navigator.of(context).pop(); // dismiss the dialog
                
                     Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeTrack(
                          manpowerid: manpowerId,
                          orderprice: GlobalConstant.instantprice,
                          ordercategory: GlobalConstant.instantHireCategory,
                          orderotp: otp,
                          orderid: GlobalConstant.instantHireOrderId,
                          orderlat: GlobalConstant.instantHireLat,
                          orderlongi: GlobalConstant.instantHireLong,
                          orderworkinghrs: GlobalConstant.instantHireWorkingHrs,
                          orderlocation: GlobalConstant.instantHirePlace,
                          orderworkdetail: GlobalConstant.instantHireWork,
                        ),
                      ),
                    );
                 
                  }),
            ],
          );
        },
      );
    }

    // 2 - Employer
    // Employer -> Show notification to Employer
    // show dialog to Employer if : manpower starting your work
    if (notificationTitle == "Order Cancellation Notification") {
      // if (GlobalConstant.notificationPopupDisplayed == true) {
      //   GlobalConstant.notificationPopupDisplayed = false;
      //   Navigator.of(_context)
      //       .pop(); // dismiss firstly opened accept reject dialog
      // }
      showDialog(
        context: _context,
        builder: (BuildContext context) {
         // GlobalConstant.notificationPopupDisplayed = true;
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              notificationBody.toString(),
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async {
                   Navigator.of(context).pop(); 
                   Navigator.of(context).pop(); 
                   
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EmployeMyProject()));

                  /// dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }

    //notifify for  cancllation charge

     if (notificationTitle == "You have been informed of a cancellation fee of Rs. 25.") {
      // if (GlobalConstant.notificationPopupDisplayed == true) {
      //   GlobalConstant.notificationPopupDisplayed = false;
      //   Navigator.of(_context)
      //       .pop(); // dismiss firstly opened accept reject dialog
      // }
      showDialog(
        context: _context,
        builder: (BuildContext context) {
         // GlobalConstant.notificationPopupDisplayed = true;
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              notificationBody.toString(),
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async {
                   Navigator.of(context).pop(); 
                   Navigator.of(context).pop(); 
                   
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EmployeMyProject()));

                  /// dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
    ///low wallet balnace alert for manpower
    ///
    ///
     if (notificationTitle == "Low Wallet Balance Alert") {
      // if (GlobalConstant.notificationPopupDisplayed == true) {
      //   GlobalConstant.notificationPopupDisplayed = false;
      //   Navigator.of(_context)
      //       .pop(); // dismiss firstly opened accept reject dialog
      // }
      showDialog(
        context: _context,
        builder: (BuildContext context) {
         // GlobalConstant.notificationPopupDisplayed = true;
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              notificationBody.toString(),
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async {
                   Navigator.of(context).pop(); 
                   Navigator.of(context).pop(); 
                   
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EmployeMyProject()));

                  /// dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }

    // 3 - Employer
    // Employer -> Show notification to Employer
    // show dialog to Employer if : after accepting, request Cancel by manpower
    // if (notificationTitle =="Request Cancel By Employer") {
    //   // if (GlobalConstant.notificationPopupDisplayed == true) {
    //   //   GlobalConstant.notificationPopupDisplayed = false;
    //   //   Navigator.of(_context)
    //   //       .pop(); // dismiss firstly opened accept reject dialog
    //   // }
    //   showDialog(
    //     context: _context,
    //     builder: (BuildContext context) {
    //      // GlobalConstant.notificationPopupDisplayed = true;
    //       var mediaQuery = MediaQuery.of(context);
    //       return AlertDialog(
    //         surfaceTintColor: AppColors.blackshadow,
    //         title: Text(
    //           "Request Cancel By Employer",
    //           style: SafeGoogleFont(
    //             'Roboto',
    //             fontSize: mediaQuery.size.width * 0.05,
    //             fontWeight: FontWeight.bold,
    //             color: AppColors.black,
    //           ),
    //         ),
    //         actions: [
    //           TextButton(
    //             child: Text(
    //               "Ok",
    //               style: SafeGoogleFont(
    //                 'Roboto',
    //                 fontSize: mediaQuery.size.width * 0.05,
    //                 fontWeight: FontWeight.bold,
    //                 color: AppColors.black,
    //               ),
    //             ),
    //             onPressed: () async {
    //               Navigator.of(context).pop(); 
    //              // dismiss the dialog
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    if (notificationTitle =="Payment done") {
      // if (GlobalConstant.notificationPopupDisplayed == true) {
      //   GlobalConstant.notificationPopupDisplayed = false;
      //   Navigator.of(_context)
      //       .pop(); // dismiss firstly opened accept reject dialog
      // }
      showDialog(
        context: _context,
        builder: (BuildContext context) {
         // GlobalConstant.notificationPopupDisplayed = true;
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              "Payment done",
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(); 
                 // dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }

    // 4 - Employer
    // Employer -> Show notification to Employer
    // show dialog to Employer if : manpower Completed your work
   
    if (notificationTitle == "Work Start") {
      // if (GlobalConstant.notificationPopupDisplayed == true) {
      //   GlobalConstant.notificationPopupDisplayed = false;
      //   Navigator.of(_context)
      //       .pop(); // dismiss firstly opened accept reject dialog
      // }
      showDialog(
        context: _context,
        builder: (BuildContext context) {
         // GlobalConstant.notificationPopupDisplayed = true;
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              "Manpower Starting your work",
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(); // dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
     if (notificationTitle == "Work Completed") {
      // if (GlobalConstant.notificationPopupDisplayed == true) {
      //   GlobalConstant.notificationPopupDisplayed = false;
      //   Navigator.of(_context)
      //       .pop(); // dismiss firstly opened accept reject dialog
      // }
      showDialog(
        context: _context,
        builder: (BuildContext context) {
         // GlobalConstant.notificationPopupDisplayed = true;
          var mediaQuery = MediaQuery.of(context);
          return AlertDialog(
            surfaceTintColor: AppColors.blackShadow,
            title: Text(
              "Work Completed",
              style: SafeGoogleFont(
                'Roboto',
                fontSize: mediaQuery.size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: mediaQuery.size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop(); // dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }
  }
  

  checkOrderStatus(context, orderID) async {
    bool status = false;
    final response = await http.get(Uri.parse(
        'https://workwave-backend.vercel.app//api/v1/employer/get/getStatusOfOrderId?orderId=' +
            orderID.toString()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      var orderStatus = jsonResponse['data']['orderStatus'];
      print(orderStatus);
      if (orderStatus == 'Pending') {
        status = true;
      }
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.black,
          content: Text(
            "Something went Wrong..",
            style: TextStyle(color: Colors.black),
          )));
    } else if (response.statusCode == 401 || response.statusCode == 422) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.black,
          content: Text(
            "Something went Wrong..",
            style: TextStyle(color: Colors.black),
          )));
    } else if (response.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Something went Wrong..",
            style: TextStyle(color: Colors.black),
          )));
    }
    return status;
  }

  sendConformationToEmplyee(context, orderId, empId, category) async {
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/put/generateAndSaveOTP");

    await http
        .put(requestUri,
            body: jsonEncode({
              "orderId": orderId,
              "statusOfApply": "true",
              "manpowerId": GlobalConstant.userID
            }),
            headers: {
              'Content-Type': 'application/json',
            })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            var otpSendToEmployer =
                jsonResponse['man']['updatedPost']['otpSendToEmployer'];
            print(otpSendToEmployer);

            // send Message to employee with OTP
            // otp, manPowerId,
            sendMsgToEmp(context, otpSendToEmployer, empId, orderId);

            // confirm order api
            confirmOrder(context, empId, orderId, category);
          } else if (response.statusCode == 400) {
            print(response);
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print(response);
          } else if (response.statusCode == 500) {
            print(response);
          }
        })
        .catchError((error) {
          print(error);
        });
  }

  sendMsgToEmp(context, otpSendToEmployer, empId, orderId) async {
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/findParticularManpowerOrEmployer");

    await http
        .post(requestUri,
            body: jsonEncode({
              "title": "Request Accept",
              "body": "Your Request Accepted.",
              "senderId": GlobalConstant.userID,
              "receiverId": empId,
              "category": otpSendToEmployer,
              "job_desc": "",
              "siteLocation": "",
              "explainYourWork": "",
              "date": ""
            }),
            headers: {
              'Content-Type': 'application/json',
            })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            // var otpSendToEmployer = jsonResponse['man']['updatedPost']['otpSendToEmployer'];
            print(otpSendToEmployer);
          } else if (response.statusCode == 400) {
            print(response);
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print(response);
          } else if (response.statusCode == 500) {
            print(response);
          }
        })
        .catchError((error) {
          print(error);
        });
  }

  confirmOrder(context, empId, orderId, category) async {
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/upadtePost/ByStatusOfCompletion/" + orderId);

    await http
        .put(requestUri,
            body: jsonEncode(
                {"startTime": '', "endTime": '', "statusOfApply": "Confirm"}),
            headers: {
              'Content-Type': 'application/json',
            })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            cancelNotificationToAllManPower(context, empId, orderId, category);
          } else if (response.statusCode == 400) {
            print(response);
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print(response);
          } else if (response.statusCode == 500) {
            print(response);
          }
        })
        .catchError((error) {
          print(error);
        });
  }

  cancelNotificationToAllManPower(context, empId, orderId, category) async {
    var requestUri =
        Uri.parse("https://workwave-backend.vercel.app//api/v1/employer/findManpower");

    await http
        .post(requestUri,
            body: jsonEncode({
              "employerId": empId,
              "orderId": orderId,
              "radiusInKm": 30,
              "category": category,
              "body": "Session Expired"
            }),
            headers: {
              'Content-Type': 'application/json',
            })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            Future<String> otp(String orderId) async {
              final apiUrl =
                  'https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$orderId';

              try {
                print('url${apiUrl}');
                final response = await http.get(Uri.parse(apiUrl));

                if (response.statusCode == 200) {
                  final Map<String, dynamic> jsonResponse =
                      json.decode(response.body);
                  final String otp = jsonResponse['data']['otpSendToEmployer'];
                  return otp;
                } else {
                  // Handle the error, you might want to throw an exception or return an error message
                  throw Exception(
                      'Failed to load data, status code: ${response.statusCode}');
                }
              } catch (error) {
                // Handle the error, you might want to throw an exception or return an error message
                throw Exception('Failed to load data: $error');
              }
            }
            

             Future<String> getOtpSendToManpower(String orderId) async {
                      final apiUrl =
                          'https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$orderId';

                      try {
                        print('url${apiUrl}');
                        final response = await http.get(Uri.parse(apiUrl));

                        if (response.statusCode == 200) {
                          final Map<String, dynamic> jsonResponse =
                              json.decode(response.body);
                          final String otp =
                              jsonResponse['data']['otpSendToEmployer'];
                              
                          return otp;
                        } else {
                          // Handle the error, you might want to throw an exception or return an error message
                          throw Exception(
                              'Failed to load data, status code: ${response.statusCode}');
                        }
                      } catch (error) {
                        // Handle the error, you might want to throw an exception or return an error message
                        throw Exception('Failed to load data: $error');
                      }
                    }

                    String otpformanpower = await getOtpSendToManpower(
                       orderId );
                        Future<String> employeridget(String orderId) async {
                      final apiUrl =
                          'https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$orderId';

                      try {
                        print('url${apiUrl}');
                        final response = await http.get(Uri.parse(apiUrl));

                        if (response.statusCode == 200) {
                          final Map<String, dynamic> jsonResponse =
                              json.decode(response.body);
                          final String otp =
                              jsonResponse['data']['employerId'];
                              
                          return otp;
                        } else {
                          // Handle the error, you might want to throw an exception or return an error message
                          throw Exception(
                              'Failed to load data, status code: ${response.statusCode}');
                        }
                      } catch (error) {
                        // Handle the error, you might want to throw an exception or return an error message
                        throw Exception('Failed to load data: $error');
                      }
                    }

                    String employerid = await employeridget(
                       orderId );
  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManpowerTrack(
                            orderid: orderId,
                            orderotp: otpformanpower,
                            employerid:employerid ,
                          )));
          } else if (response.statusCode == 400) {
            print(response);
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print(response);
          } else if (response.statusCode == 500) {
            print(response);
          }
        })
        .catchError((error) {
          print(error);
        });
  }
