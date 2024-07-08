// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../new utils/colors.dart';
import '../billing_payment_screens/empBillingScreen.dart';
import 'emp_description_screen.dart';

class EmpTimerPage extends StatefulWidget {
  var manpowerid;
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

  EmpTimerPage({
    this.manpowerid,
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
  State<EmpTimerPage> createState() => _EmpTimerPageState();
}

class _EmpTimerPageState extends State<EmpTimerPage>
    with TickerProviderStateMixin {
  int currentPageIndex = 0;
  DateTime? startTime;
  DateTime? endTime;
  Duration? timeRemaining;
  bool timerStarted = false;
  late AnimationController _animationController;
  void ontogglechange(int? index) {
    setState(() {
      currentPageIndex = index!;
    });
  }

  bool isLoading = true;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    startDelayedTimer();
    getdataofmanpower();
    _animationController = AnimationController(
      vsync: this,
      duration: timeRemaining ?? Duration.zero,
    );


    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      // Fetch data from the API
      naviagtionstatus();
    });
  }

  bool isApiCallActive = true;
  Future<void> naviagtionstatus() async {
    var id = widget.orderid; // Make sure to have access to the orderid
    while (isApiCallActive) {
      final response = await http.get(Uri.parse(
          'https://workwave-backend.vercel.app/api/v1/employer/getStartEmdTimeByOrderId/$id'));

      if (response.statusCode == 200) {
        print("i am rumming");
        // Parse the response body
        Map<String, dynamic> apiResponse = json.decode(response.body);
        // Extract the start time from the API response
        String? startTimeString = apiResponse['startTime'];
        String? orderStatus = apiResponse['orderStatus'];
        // Navigate to the timer page passing the start time
        if (orderStatus == 'Completed') {
          // Start time is not empty, navigate to the timer page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmpBillingPageIn(
                manpowerid: widget.manpowerid,
                newOrderId: widget.orderid,
                category: widget.ordercategory,
              ),
            ),
          );
          isApiCallActive = false;
        }
      } else {
        throw Exception('Failed to load data from API');
      }
      await Future.delayed(Duration(seconds: 2));
    }
  }

  var manPowerdata;
  void startDelayedTimer() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false; // Update state to stop showing the loading indicator
      });
      startTimer(); // Start your timer logic
    });
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

        _animationController.duration = timeRemaining ?? Duration.zero;
        _animationController.reset();
        _animationController.forward();
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
              navigateToNextPage();
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

  void navigateToNextPage() {
    // Add your navigation logic here
    // You can replace the line below with your actual navigation code.
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => EmpBillingPageIn(
                  manpowerid: widget.manpowerid,
                  newOrderId: widget.orderid,
                  category: widget.ordercategory,
                )));
  }

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

  var isExpand = false;

  String profileUrl =
      'https://i.kym-cdn.com/entries/icons/facebook/000/023/977/cover3.jpg';

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
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
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.black,
                            ),
                          ) // Show loading indicator
                        : Positioned(
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
                                // SizedBox(
                                //   height: mediaQuery.size.height * 0.02,
                                //   width: mediaQuery.size.width * 0.5,
                                //   child: AnimatedBuilder(
                                //     animation: _animationController,
                                //     builder: (context, child) {
                                //       return LinearProgressIndicator(
                                //         value: _animation.value,
                                //         color: Colors.black,
                                //         backgroundColor: Colors.red,
                                //       );
                                //     },
                                //   ),
                                // ),
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
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35))),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: Row(
                                  children: [
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
                                            ? Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: mediaQuery.size.width *
                                                    0.09,
                                                color: Colors.blueGrey,
                                              )
                                            : Icon(
                                                Icons.keyboard_arrow_up_rounded,
                                                size: mediaQuery.size.width *
                                                    0.09,
                                                color: Colors.blueGrey)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: mediaQuery.size.width * 0.05,
                              ),
                              Center(
                                child: CircleAvatar(
                                  radius: mediaQuery.size.width * 0.09,
                                  backgroundImage: NetworkImage(
                                      manPowerdata?['profileImage'] ??
                                          profileUrl),
                                ),
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Center(
                                child: Text(
                                  manPowerdata?['name'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: mediaQuery.size.width * 0.04,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Center(
                                child: Text(
                                  manPowerdata != null
                                      ? widget.ordercategory ?? ''
                                      : "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: mediaQuery.size.width * 0.04,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Center(
                                child: Text(
                                  'OTP :- ${widget.orderotp}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: mediaQuery.size.width * 0.04,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      minimumSize: const Size(100, 35),
                                    ),
                                    onPressed: () async {
                                      String contactNo =
                                          manPowerdata?['mobile'] ?? '';
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              isExpand
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: mediaQuery.size.width * 0.01,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: ToggleSwitch(
                                        minWidth: mediaQuery.size.width * 0.4,
                                        minHeight:
                                            mediaQuery.size.height * 0.03,
                                        cornerRadius: 5.0,
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
                                        ],
                                        radiusStyle: true,
                                        onToggle: ontogglechange,
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              isExpand
                                  ? EmpDiscriptionScreen(
                                      manpowername: manPowerdata?['name'] ?? '',
                                      orderid: widget.orderid,
                                      manpowerid: widget.manpowerid,
                                      orderlocation: widget.orderlocation,
                                      orderprice: widget.orderprice,
                                      orderworkdetail: widget.orderworkdetail,
                                      orderworkinghrs: widget.orderworkinghrs,
                                      manworkexp:
                                          manPowerdata?['experience'] ?? '',
                                      will: 5,
                                      rating:
                                          manPowerdata?['averageRating'] ?? '')
                                  : SizedBox(),
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
    ));
  }

  Future<void> getdataofmanpower() async {
    try {
      // String id = manPoerId;
      var id = widget.manpowerid;
      final apiUrl = 'https://workwave-backend.vercel.app/api/v1/manpower/$id';
      print(apiUrl);
      print('7');
      final response = await http.get(Uri.parse(apiUrl));

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('8');
        // Token sent to backend successfully
        if (json['data'] != null) {
          print('9');

          manPowerdata = json['data'];

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

  var orderData;
  Future<void> _getOrderDetails() async {
    try {
      var id = widget.orderid;
      var response = await http.get(Uri.parse(
          "https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$id"));
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
