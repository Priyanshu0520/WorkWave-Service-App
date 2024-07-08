
// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayforce/new_services/global_constants.dart';

import '../../new utils/colors.dart';
import '../../new utils/const.dart';
import '../../new utils/utils.dart';
import 'showmanpower_detail.dart';

class EmpDiscriptionScreen extends StatefulWidget {
  var rating;
 var manpowerid;
   var manpowername;
  var orderlocation;
  var orderprice;
  var orderworkinghrs;
  var manworkexp;
  var orderid;
  var manpowerpic;
  var orderworkdetail;
 int will;
EmpDiscriptionScreen({
  this.rating,
  this.manpowerpic,
  this.manpowername,
  this.orderid,
  this.manpowerid,
  this.orderlocation,
  this.orderprice,
  this.orderworkinghrs,
  this.manworkexp,
  this.orderworkdetail,
  required this.will,
  Key? key,
}) : super(key: key);


  @override
  State<EmpDiscriptionScreen> createState() => _EmpDiscriptionScreenState();
}

class _EmpDiscriptionScreenState extends State<EmpDiscriptionScreen> {
 

  Future<void> _cancelOrder() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var data = jsonEncode({
        "startTime": '',
        "endTime": '',
        "statusOfCompletion": "Cancel",
        "userId":GlobalConstant.userID
      });

      var response = await http.put(
        Uri.parse(
            "https://workwave-backend.vercel.app/api/v1/employer/upadtePost/ByStatusOfCompletion/${widget.orderid}"),
        body: data,
        headers: headers,
      );

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
        print('Failed to cancel order: ${response.body}');
        // Handle error gracefully
      }
    } catch (e) {
      print('Error cancelling order: $e');
      // Handle error gracefully
    }
  }

  Future<void> _sendMsgToManpower() async {
    try {
      var data = jsonEncode({
        "body": "Request Cancel By Employer",
        "title": "Request Cancel By Employer",
        "senderId": GlobalConstant.userID,
        "receiverId": widget.manpowerid??"",
        "category": "",
        "siteLocation": "",
        "explainYourWork": "",
        "date": "",
        "orderId": widget.orderid
      });

      var headers = {'Content-Type': 'application/json'};
      var response = await http.post(
        Uri.parse("https://workwave-backend.vercel.app/api/v1/employer/findParticularManpowerOrEmployer"),
        body: data,
        headers: headers,
      );

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
        print('Failed to send message to manpower: ${response.body}');
        // Handle error gracefully
      }
    } catch (e) {
      print('Error sending message to manpower: $e');
      // Handle error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.size.width * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: Colors.blueGrey,
          ),
              Row(
            children: [
              Text(
                "Experience : ",
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
                SizedBox(
                width: mediaQuery.size.width * 0.146,
              ),
              Text('${widget.manworkexp}'??" "),
            ],
          ),
          
       
          SizedBox(
            height: mediaQuery.size.height * 0.01,
          ),
          Row(
            children: [
              Text(
                "Price : ",
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.22,
              ),
              Text('${widget.orderprice}'?? " "),
            ],
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.01,
          ),
          Row(
            children: [
              Text(
                "Site Location : ",
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.072,
              ),
              Flexible(
  child: Text(
    '${widget.orderlocation}' ?? " ",
    overflow: TextOverflow.clip,
  ),
),
            ],
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Working Hours : ",
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: mediaQuery.size.width * 0.04,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.035,
              ),
              Text('${widget.orderworkinghrs} hrs'??  " "),
            ],
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.01,
          ),
          Text(
            'Description : ',
            style: SafeGoogleFont(
              'Montserrat',
              fontSize: mediaQuery.size.width * 0.04,
              fontWeight: FontWeight.w700,
              color: const Color(0xff222222),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: mediaQuery.size.height * 0.01,
                bottom: mediaQuery.size.height * 0.02),
            child: Text('${widget.orderworkdetail}'??" "),
          ),
          Container(
            height: mediaQuery.size.height * 0.19,
            padding: EdgeInsets.only(
              top: mediaQuery.size.height * 0.01,
              left: mediaQuery.size.width * 0.04,
              right: mediaQuery.size.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) {
                                if (index < (widget.rating ).floor()) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: mediaQuery.size.width * 0.06,
                                  );
                                } else {
                                  return Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                    size: mediaQuery.size.width * 0.06,
                                  );
                                }
                              },
                            ),
                          ),
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
                        ],
                      ),
                Row(
                  children: [
                    Text(
                     widget.manpowername ,
                      style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: mediaQuery.size.width * 0.15,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ManpowerDetail(
                                    rating : widget.rating??"",
                                    manpowerid: widget.manpowerid ??" ",
                               
                                      )));
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_4,
                              size: mediaQuery.size.width * 0.10,
                              color: AppColors.black,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Learn more about\n your Manpower',
                                  style: TextStyle(color: AppColors.black),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    color: AppColors.black,
                                    size: mediaQuery.size.width * 0.08)
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.03 ,),
      
             if (widget.will==0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: Size(
                    mediaQuery.size.width * 0.3,
                    mediaQuery.size.height * 0.06,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Confirm Cancellation",
                          style: TextStyle(
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff222222),
                          ),
                        ),
                        content: Text(
                          "Are you sure you want to cancel?\nA charge of 25 rupees will be applied.",
                          style: TextStyle(
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
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.03,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff222222),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _cancelOrder();
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.of(context).pop(); // Pop the page
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontSize: mediaQuery.size.width * 0.03,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff222222),
                              ),
                            ),
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
            ],
          ),
          SizedBox(height: mediaQuery.size.height * 0.03 ,),
        ],
      ),
    );
  }
}

