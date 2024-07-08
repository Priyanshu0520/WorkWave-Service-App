// ignore_for_file: unused_local_variable, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wayforce/new%20utils/colors.dart';
import 'package:wayforce/new_services/global_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayforce/new%20utils/const.dart';
import 'package:http/http.dart' as http;
import '../../new utils/utils.dart';
import '../bottomnav bars/manp_bottom_navbar_provider.dart';

class ManDiscriptionScreen extends StatefulWidget {
  var orderlocation;
  var orderprice;
  var orderworkinghrs;
  var sitelocation;
  var orderid;
  var orederemployerid;

  var orderworkdetail;
  ManDiscriptionScreen(
      {this.orderlocation,
      this.orderprice,
      required this.orderworkinghrs,
      this.orederemployerid,
      this.sitelocation,
      this.orderworkdetail,
      this.orderid,
      super.key});

  @override
  State<ManDiscriptionScreen> createState() => _ManDiscriptionScreenState();
}

class _ManDiscriptionScreenState extends State<ManDiscriptionScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _cancelOrder(String empId) async {
    try {
      var headers = {'Content-Type': 'application/json'};

      final data = jsonEncode(
          {"startTime": '', "endTime": '', "statusOfCompletion": "Cancel",
          "userId": '${GlobalConstant.userID}'
          });

      var orderId = widget.orderid;
      print('order id: ${widget.orderid}');

      var urll =
          "https://workwave-backend.vercel.app/api/v1/employer/upadtePost/ByStatusOfCompletion/$orderId";

      var url = Uri.parse(urll);
      print('uuuuril  ${url}');
      var response = await http.put(url, body: data, headers: headers);
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
         clearAllFunction();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove(SPkey.orderOnGoing);
        prefs.remove(SPkey.orderManId);
        prefs.remove(SPkey.orderId);
        prefs.remove(SPkey.orderOTP);
        prefs.remove(SPkey.orderWorkingTime);

        isEmpMapPage = false;
        isEmpOtpPage = false;
        manStartWork.value = false;
        manExtantTime.value = false;
        isEmpDetectPage = false;
      } else {
        print(response.body);
      }
    } catch (e) {
      print('ereba : ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "An error occurred: ${e.toString()}",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ));
    }
  }

  // void _sendMsgToManpower(String empId) async {
  //   try {
  

  //     final data = jsonEncode({
  //       "body": "Request Cancel By Manpower",
  //       "title": "Request Cancel By Manpower",
  //       "senderId": GlobalConstant.userID,
  //       "receiverId": empId,
  //       "category": "",
  //       "siteLocation": "",
  //       "explainYourWork": "",
  //       "date": "",
  //       "orderId": widget.orderid
  //     });

  //     var headers = {
  //       'Content-Type': 'application/json',
  //     };

  //     var url = Uri.parse(
  //         "http://3.110.135.177/api/api/v1/employer/findParticularManpowerOrEmployer");
  //     print("jhjhj${url}");
  //     var response = await http.post(url, body: data, headers: headers);
  //     var json = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       clearAllFunction();
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.remove(SPkey.orderOnGoing);
  //       prefs.remove(SPkey.orderManId);
  //       prefs.remove(SPkey.orderId);
  //       prefs.remove(SPkey.orderOTP);
  //       prefs.remove(SPkey.orderWorkingTime);

  //       isEmpMapPage = false;
  //       isEmpOtpPage = false;
  //       manStartWork.value = false;
  //       manExtantTime.value = false;
  //       isEmpDedectPage = false;
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var siteloc = widget.orderlocation;
    var mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: Colors.blueGrey,
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
          Row(
            children: [
              Text(
                "Price: ",
                style: SafeGoogleFont(
                  'Montserrat',
                 fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
              Text(widget.orderprice.toString() ),
            ],
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
          Row(
            children: [
              Text(
                "Site Location: ",
                style: SafeGoogleFont(
                  'Montserrat',
                 fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
              Flexible(
                child: Text(
                  siteloc ?? "",
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Working Hours: ",
                style: SafeGoogleFont(
                  'Montserrat',
                 fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w700,
                  height: 1.2175,
                  color: const Color(0xff222222),
                ),
              ),
              Text(widget.orderworkinghrs.toString()),
            ],
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
          Text(
            'Description :',
            style: SafeGoogleFont(
              'Montserrat',
              fontSize: mediaQuery.size.width * 0.04,
              fontWeight: FontWeight.w700,
              height: 1.2175,
              color: const Color(0xff222222),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 20),
            child: Text(widget.orderworkdetail ?? ""),
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
          if (!manStartWork.value)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(310, 45), // set the button size
                ),
                onPressed: () {
                  String empid = widget.orederemployerid;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Cancellation",
                            style: SafeGoogleFont(
                              'Montserrat',
                              fontSize: mediaQuery.size.width * 0.05,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff222222),
                            )),
                        content: Text(
                          "Are you sure you want to cancel?\nA charge of 25 rupees will be applied.",
                          style: SafeGoogleFont(
                            'Montserrat',
                            fontSize: mediaQuery.size.width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff222222),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("No",
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: mediaQuery.size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff222222),
                                )),
                          ),
                          TextButton(
                            onPressed: () {
                              _cancelOrder(empid);
                              Navigator.of(context).pop(); 
                               Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>ManNavTab()),
              );
                            },
                            child: Text("Yes",
                                style: SafeGoogleFont(
                                  'Montserrat',
                                  fontSize: mediaQuery.size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff222222),
                                )),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
        ],
      ),
    );
  }
}
