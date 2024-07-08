// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wayforce/new_services/global_constants.dart';
import '../../new utils/colors.dart';
import '../../new utils/utils.dart';
import 'package:http/http.dart' as http;

import '../bottomnav bars/emp_bottom_navbar_provider.dart';

class WaitingManpowerToAccept extends StatefulWidget {
  String ?sitelocation;
   WaitingManpowerToAccept({  this.sitelocation , super.key});

  @override
  State<WaitingManpowerToAccept> createState() => _WaitingManpowerToAcceptState();
}

class _WaitingManpowerToAcceptState extends State<WaitingManpowerToAccept> {
  @override
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer ?_timer;
  int _countdownSeconds = 60; 
  double _progress = 1.0;
  bool isCancelClicked = false;

  @override
  void initState() {
    super.initState();
     findManpower();
  }
void _showTimeoutDialog() {
  cancelOrderByEmployer();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Your Request Not Accepted',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Please try again.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
             // Navigator.of(context).pop(); // Go back to the previous screen
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

  void startCountdown() {
    if(!isCancelClicked){
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
          _progress = _countdownSeconds / 60;
        } else {
          _timer!.cancel();
          Navigator.of(context).pop(); 
           _showTimeoutDialog();
        }
      });
    });
    }
  }
   String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
    return '$minutesStr:$secondsStr';
  }
 

  Future findManpower() async{
    var map = {
        "employerId": GlobalConstant.userID,
        "orderId": GlobalConstant.instantHireOrderId,
        "radiusInKm": 30,
        "category": GlobalConstant.instantHireCategory,
        "body": 'Location : ${GlobalConstant.instantHirePlace}'
    };
 
    var requestUri = Uri.parse("https://workwave-backend.vercel.app/api/v1/employer/findManpower");
    print(map);
    print("request url: " + requestUri.toString());
    var jsonBody = const JsonEncoder().convert(map);

    await http
        .post(requestUri, body: jsonBody, headers: {
          'Content-Type': 'application/json',
        })
        .timeout(const Duration(seconds: 60))
        .then((http.Response response) async {
          print(jsonDecode(response.body));
          print(response.statusCode);
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
            if(jsonDecode(response.body)['manpower'].length != 0){
              startCountdown();
            }
            else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.black,
                content: Text(
                  "Manpower not found in this area",
                  style: TextStyle(color: Colors.white),
                )));
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            }
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            var jsonResponse = jsonDecode(response.body);
          } else if (response.statusCode == 500) {
            var jsonResponse = jsonDecode(response.body);
          }
        })
        .catchError((error) {
          print(error);
          // Loader().dismiss();
        });
  }

  Future cancelOrderByEmployer() async{
    var requestUri = Uri.parse("https://workwave-backend.vercel.app/api/v1/employer/upadtePost/ByStatusOfCompletion/" + GlobalConstant.instantHireOrderId.toString());

    await http
      .put(requestUri, 
      body: jsonEncode({
        "startTime": '', 
        "endTime": '', 
        "statusOfCompletion": "Cancel"  ,
        "userId" : "${GlobalConstant.userID}"
       
         
      }), 
      headers: {
        'Content-Type': 'application/json',
      })

      
      .timeout(Duration(seconds: 30))
      .then((http.Response response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var jsonResponse = jsonDecode(response.body);
          sendCancelNotificationByEmployerToAllManPower();
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

  sendCancelNotificationByEmployerToAllManPower() async{
    var map = {
      "employerId": GlobalConstant.userID,
      "orderId": GlobalConstant.instantHireOrderId,
      "radiusInKm": 30,
      "category": GlobalConstant.instantHireCategory,
      "body": "Session Expired"
    };
 
    var requestUri = Uri.parse("https://workwave-backend.vercel.app/api/v1/employer/findManpower");
    print("request url: " + requestUri.toString());
    var jsonBody = const JsonEncoder().convert(map);

    await http
        .post(requestUri, body: jsonBody, headers: {
          'Content-Type': 'application/json',
        })
        .timeout(Duration(seconds: 300))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            var jsonResponse = jsonDecode(response.body);
          } else if (response.statusCode == 500) {
            var jsonResponse = jsonDecode(response.body);
          }
        })
        .catchError((error) {
          print(error);
          // Loader().dismiss();
        });

  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(),
        body: Center(
          child: Column(
            
            children: [
               SizedBox(height: mediaQuery.size.height * 0.22),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.blackShadow,
                  borderRadius: BorderRadius.circular(25)
                ),
                height: mediaQuery.size.height * 0.35,
                       width: mediaQuery.size.width* 0.70,
                child: Column(
                  
                  children: [
                    SizedBox(height: mediaQuery.size.height * 0.06),
                      Text('Waiting Manpower \nto Accept',
                  style: SafeGoogleFont(
                        'Montserrat',
                        fontSize: mediaQuery.size.width * 0.06,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),),
                     
          SizedBox(height: mediaQuery.size.height * 0.04),
            LinearProgressIndicator(
              color: AppColors.black,
              value: _progress,
              minHeight: 5,
            ),
            SizedBox(height: mediaQuery.size.height * 0.01),
            Text(
              formatDuration(_countdownSeconds),
              style: const TextStyle(fontSize: 20),
            ),
          
                   SizedBox(height: mediaQuery.size.height * 0.04),
                            ElevatedButton(
                onPressed: () {
                  setState(() {
                    isCancelClicked = true;
                  });
                  cancelOrderByEmployer();
                  Navigator.of(context)
                      .popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmpNavTab()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: const Size(100, 35), // set the button size
                ),
                child: const Text(
                  'Cancel ',
                  style: TextStyle(color: AppColors.white),
                ),
                            ),
          
                  ],
                ),
              ),
            ],
          ),
        )
      );
  }
  
}