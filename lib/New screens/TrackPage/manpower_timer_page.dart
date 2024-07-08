// ignore_for_file: must_be_immutable, unused_local_variable

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayforce/new%20utils/colors.dart';

import '../../new utils/const.dart';
import '../../new_services/global_constants.dart';
import '../billing_payment_screens/manPowerBillingScreen.dart';
import 'manpower_description_screen.dart';

class ManpowerTimerPage extends StatefulWidget {
  var employerid;
  var orderid;
  var orderlat;
  var orderlongi;
  var ordercategory;
  var orderotp;
  var orderlocation;
  var orderprice;
  var orderworkinghrs;
  var sitelocation;
  var orderworkdetail;

  ManpowerTimerPage({
    this.employerid,
    this.orderid,
    this.orderlat,
    this.orderlongi,
    this.ordercategory,
    this.orderotp,
    this.orderlocation,
    this.orderprice,
    this.orderworkinghrs,
    this.sitelocation,
    this.orderworkdetail,
    Key? key,
  }) : super(key: key);

  @override
  _ManpowerTimerPageState createState() => _ManpowerTimerPageState();
}

class _ManpowerTimerPageState extends State<ManpowerTimerPage> {
  int currentPageIndex = 0;
  DateTime? startTime;
  DateTime? endTime;
  Duration? timeRemaining;
  bool timerStarted = false;
  void ontogglechange(int? index) {
    setState(() {
      currentPageIndex = index!;
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    getdataofemployer();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);

    if (duration.isNegative) {
    return '00:00:00';
  }

    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  Future<void> startTimer() async {
    // Fetch data from your API
    await fetchDataFromAPI().then((apiResponse) {
      setState(() {
        // Set start time from API response
        String startTimeString = apiResponse['startTime'];
        DateTime currentDate = DateTime.now();
        startTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            int.parse(startTimeString.split(':')[0]),
            int.parse(startTimeString.split(':')[1]),
            int.parse(startTimeString.split(':')[2]));

        // Set end time from API response
        int endTimeInHours = int.parse(apiResponse['endTime']);
        endTime = startTime!.add(Duration(hours: endTimeInHours));

        // Calculate time remaining
        if (startTime != null && endTime != null) {
          timeRemaining = endTime!.difference(DateTime.now());

          // Update the timer every second
          Timer.periodic(Duration(seconds: 1), (timer) {
            setState(() {
              timeRemaining = endTime!.difference(DateTime.now());
            });

            // If the time has finished, navigate to the next page
            if (timeRemaining!.isNegative) {
              createBill(context);
              // navigateToNextPage();
              timer.cancel();
              // Add your navigation logic here
            }
          });
        } else {
          print('Invalid or null start/end time values in API response.');
        }
      });
    });
    _getOrderDetails();
  }
// void navigateToNextPage() {
//     // Add your navigation logic here
//     // You can replace the line below with your actual navigation code.
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManBillingPage()));
//   }
  Future<Map<String, dynamic>> fetchDataFromAPI() async {
    var id = widget.orderid;
    final response = await http.get(Uri.parse(
        'https://workwave-backend.vercel.app/api/v1/employer/getStartEmdTimeByOrderId/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }
  
var employerdata;
  Future<void> getdataofemployer() async {
    try {
      // String id = manPoerId;
      var id = widget.employerid;
      final apiUrl = 'https://workwave-backend.vercel.app/api/v1/employer/$id';
      print("api url ::: ${apiUrl}");
      print('7');
      final response = await http.get(Uri.parse(apiUrl));

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('8');
        // Token sent to backend successfully
        if (json['data'] != null) {
          print('9');
          // manLat = json['data']['serviceLocation']['lati'];
          // manLong = json['data']['serviceLocation']['longi'];
          employerdata = json['data'];
          // print(manLat);
          // print(manLong);
         
         // _calculateDistance();
        }
        print('manpower data get successfully');
      } else {
        // Handle the error

        print('manpower data not get Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error getting data: $error');
    }
  }

  var isExpand = false;

  String profileUrl =
      'https://i.kym-cdn.com/entries/icons/facebook/000/023/977/cover3.jpg';
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
     print(' idd aayi hhh${widget.orderid}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Booking'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                child: Stack(
                  children: [
                    Positioned(
                        left: mediaQuery.size.width * 0.35,
                            top: mediaQuery.size.height * 0.3,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Work Started",
                                  style: TextStyle(
                                      fontSize: mediaQuery.size.width * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: mediaQuery.size.height * 0.02,
                                ),
                                Text(
                                  '${formatDuration(Duration(seconds: timeRemaining?.inSeconds ?? 0))}',
                                  style: TextStyle(
                                      fontSize: mediaQuery.size.width * 0.07,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: isExpand
                            ? mediaQuery.size.height * 0.8
                          : mediaQuery.size.width * 0.7,
                        decoration: BoxDecoration(
                            color: AppColors.lightgrey,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: Row(
                                  
                                  children: [
                                //      SizedBox(
                                //         width: mediaQuery.size.width * 0.05),
                                //           Text(' Start Time \n ${orderData['startTime']}',style: TextStyle(
                                //       fontSize: mediaQuery.size.width * 0.04,
                                //       fontWeight: FontWeight.bold),
                                // ),

                                      SizedBox(
                                        width: mediaQuery.size.width * 0.43),
                                    IconButton(
                                        onPressed: () {
                                          if (isExpand == false) {
                                            setState(() {
                                              isExpand = true;
                                            });
                                          } else {
                                            setState(() {
                                              isExpand = false;
                                            });
                                          }
                                        },
                                        icon: isExpand
                                            ? const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 40,
                                                color: Colors.blueGrey,
                                              )
                                            : const Icon(
                                                Icons.keyboard_arrow_up_rounded,
                                                size: 40,
                                                color: Colors.blueGrey)),
                                    SizedBox(
                                        width: mediaQuery.size.width * 0.07),
                                  ],
                                ),
                              ),
                              SizedBox(width: mediaQuery.size.width * 0.5),
                              Center(
                                child: CircleAvatar(
                                  radius: mediaQuery.size.width * 0.08,
                                  backgroundImage:NetworkImage(employerdata?['profileImage'] ?? profileUrl)
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text( employerdata?['name'] ?? ''
                                 ,
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: mediaQuery.size.width * 0.031,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            mediaQuery.size.width * 0.03),
                                      ),
                                      minimumSize: const Size(100, 35),
                                    ),
                                    onPressed: () async {
                                      String contactNo =
                                          orderData['mobile'] ?? '0';
                                      String url = "tel:$contactNo";
                                      bool launch = await launchUrl(
                                        Uri.parse(url),
                                        mode: LaunchMode.externalApplication,
                                      );
                                      if (!launch) {}
                                    },
                                    icon: const Icon(Icons.call,
                                        color: Colors.white), // add icon here
                                    label: const Text(
                                      'Call',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            mediaQuery.size.width * 0.03),
                                      ),
                                      minimumSize: const Size(
                                          110, 35), // set the button size
                                    ),
                                    onPressed: () {
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const EmployeChat()));
                                    },
                                    icon: const Icon(Icons.chat,
                                        color: Colors.white), // add icon here
                                    label: const Text(
                                      'Chat',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // ismanOtpPage
                                  // ?
                                  createBill(context);
                                  // bottomSheets(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  minimumSize: const Size(
                                      100, 35), // set the button size
                                ),
                                child: Text(
                                  // ismanOtpPage
                                  //     ? 'Finish your work'
                                  'Finish your work',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              isExpand
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: mediaQuery.size.width * 0.01,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            mediaQuery.size.width * 0.03),
                                      ),
                                      child: ToggleSwitch(
                                        minWidth: mediaQuery.size.width * 0.450,
                                        minHeight:
                                            mediaQuery.size.height * 0.03,
                                        cornerRadius:
                                            mediaQuery.size.width * 0.01,
                                        activeBgColors: currentPageIndex == 0
                                            ? [
                                                [AppColors.black],
                                                [AppColors.black],
                                              ]
                                            : [
                                                [AppColors.black],
                                                [AppColors.black]
                                              ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.black,
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex: currentPageIndex,
                                        totalSwitches: 1,
                                        labels: const [
                                          'Description',
                                          // 'Work Infor!'
                                        ],
                                        radiusStyle: true,
                                        onToggle: ontogglechange,
                                      ),
                                    )
                                  : SizedBox(
                                      height: mediaQuery.size.width * 0.00,
                                    ),
                              isExpand
                                  ? Column(
                                      children: [
                                        if (currentPageIndex == 0)
                                          ManDiscriptionScreen(
                                             orederemployerid: widget.employerid,
                                              orderid: widget.orderid,
                                              orderlocation: orderData['siteLocation'],
                                               orderprice: orderData['bookedPayment'],
                                              orderworkdetail:
                                                 orderData['explainYourWork'],
                                              orderworkinghrs:
                                                 orderData['workingHours'],
                                          )
                                      ],
                                    )
                                  : SizedBox(
                                      width: mediaQuery.size.width * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    );
  }

  late String endtime;

  String ?entimee;
  void createBill(BuildContext ctx) async {
    var id = widget.orderid;
    print('tata1${id}');
      
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String startTime = prefs.getString(SPkey.orderStartDateTime) ?? '';
print('tata2${startTime}');
    //String totalDuration = formatTime(_seconds);
    // prefs.setString(SPkey.orderWorkDuration, totalDuration);
    DateTime now = DateTime.now();
     var workend = DateFormat('HH:mm:ss').format(now);
    String endTime = workend;
    String orderId = id;
    setState(() {
      entimee=endTime;
    });
    try {
      final data = jsonEncode({
        "orderId": id,
        "startTime": startTime,
        "endTime": workend
      });
      print('data: ${data}');
      var headers = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          "https://workwave-backend.vercel.app/api/paymentt/create/PaymentforInstant");

      var response = await http.post(url, body: data, headers: headers);

      if (response.statusCode == 200) {
        String res = response.body;
        prefs.setString(SPkey.orderBillresponce, res);
 Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>  ManBillingPage(
              employerid: widget.employerid,
              orderid: id,
              endtime: entimee,)));
        sendMsgToEmpForComplted(ctx);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "An error occurred to start workm",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ));
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "An error occurred: ${e.toString()}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ));
    }
  }

  bool isLoading = true;
  Future sendMsgToEmpForComplted(BuildContext ctx) async {
    try {
      var empid = widget.employerid;
      print('empppiiid  ${empid}');
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String accessToken = prefs.getString("manpoweraccesstoken") ?? "";

      final data = jsonEncode({
        "body": "Work completed",
        "title": "Work Completed",
        "senderId": GlobalConstant.userID,
        "receiverId": widget.employerid,
        "category": '',
        "siteLocation": "",
        "explainYourWork": "",
        "date": ""
      });

      var headers = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          "https://workwave-backend.vercel.app/api/v1/employer/findParticularManpowerOrEmployer");

      var response = await http.post(url, body: data, headers: headers);
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("nitification send work done");

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>  ManBillingPage(
              orderid: widget.orderid,
              employerid: widget.employerid,
              endtime: entimee,)));
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "An error occurred ",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "An error occurrede: ${e.toString()}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ));
    }
  }

  var orderData;
  Future<void> _getOrderDetails() async {
    try {
   
      var response = await http.get(Uri.parse(
          "https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=${widget.orderid}"));
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var data = json['data'];
        if (data != null && data is Map<String, dynamic>) {
          String orderSts = data['orderStatus'] ?? '';

          setState(() {
            orderData = data;
            //print('orderData:::${widget.orderid}?? $orderId');
          });

          if (orderSts.toLowerCase().contains('cancel')) {
          } else {}
        }
      }
    } catch (e) {}
  }
}
