import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayforce/new%20utils/const.dart';


import '../../new utils/colors.dart';
import '../../new_services/global_constants.dart';
import '../bottomnav bars/manp_bottom_navbar_provider.dart';

class ManBillingPage extends StatefulWidget {
  final String? endtime;
  String ?employerid;
  String ?orderid;

  ManBillingPage( { this.orderid, this.employerid,  this.endtime, Key? key}) ;

  @override
  State<ManBillingPage> createState() => _ManBillingPageState();
}

class _ManBillingPageState extends State<ManBillingPage> {
  var orderIdResp;

  String startTime = 'NA';
  String duration = 'NA';

  bool _dispose = false;
  bool isLoading = true;

  @override
  void initState() {
    getBillData();
    super.initState();
  }
   Future<void> completePayment() async {
    // setState(() {
    //   isLoading = true;
    // });
    var id = widget.orderid;
    try {
      final apiUrl =
          'https://workwave-backend.vercel.app/api/paymentt/put/updatePaymentStatus/$id';
      print('urllllll: ${apiUrl}');
      final response = await http.put(Uri.parse(apiUrl));
      print(response.statusCode);
      if (response.statusCode == 200) {
        _sendMsgToManpower();
        // Navigator.pushReplacement(
        //     ctx,
        //     MaterialPageRoute(
        //         builder: (context) =>  EmpPaymentSucce()));
        print('pay success');
      } else {
        // Handle the error
        print(
            'Failed pay . Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error paying send: $error');
    }
  }

  void _sendMsgToManpower() async {
    try {
     

      final data = jsonEncode({
        "body": "Payment done",
        "title": "Payment done",
        "senderId": GlobalConstant.userID,
        "receiverId": widget.employerid ,
        "category": "",
        "job_desc": "",
        "siteLocation": "",
        "explainYourWork": "",
        "date": "",
        "orderId": widget.orderid
      });

      var headers = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          "https://workwave-backend.vercel.app//api/v1/employer/findParticularManpowerOrEmployer");

      var response = await http.post(url, body: data, headers: headers);
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
       print('done dana done');

       // await clearAllFunction();
        // ismanMapPage = false;
        // ismanOtpPage = false;
        // isEmpDedectPage = false;
        // isEmpMapPage = false;
        // isEmpOtpPage = false;
        // Navigator.pushReplacement(
        //     ctx,
        //     MaterialPageRoute(
        //         builder: (context) =>  EmpPaymentSucce(manpowerid: widget.manpowerid,)));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getBillData() async {
    isEmpDedectPage = false;
    isEmpMapPage = false;
    isEmpOtpPage = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ordrsp = prefs.getString(SPkey.orderBillresponce) ?? '';

    startTime = prefs.getString(SPkey.orderStartDateTime) ?? 'NA';
    duration = prefs.getString(SPkey.orderWorkDuration) ?? '';

    if (ordrsp.isNotEmpty) {
      try {
        var resp = jsonDecode(ordrsp);
        orderIdResp = resp['updatedOrderData'];
        calculateTimeDefference(startTime, widget.endtime!);
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    }

    if (!_dispose) {
      setState(() {
        isLoading = false;
      });
    } else {
      return;
    }
  }

  calculateTimeDefference(String startTimeStr, String endTimeStr) {
    DateTime startTime = DateTime.parse(startTimeStr);
    DateTime endTime = DateTime.parse(endTimeStr);
    int timeDifferenceInSeconds = endTime.difference(startTime).inSeconds;

    final hours =
        (timeDifferenceInSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes =
        ((timeDifferenceInSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (timeDifferenceInSeconds % 60).toString().padLeft(2, '0');

    setState(() {
      duration = '$hours:$minutes:$secs';
    });
  }
bool paymentReceived = false;
  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  Widget buildInfoRow(String label, String value) {
   
    var mediaQuery = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:mediaQuery.size.width * 0.04,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize:  mediaQuery.size.width * 0.04,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
     print('empidddd::: ${widget.employerid}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Billing '),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   
                  buildInfoRow(
                    "Date :",
                    "${orderIdResp != null ? orderIdResp['date'] ?? 'NA' : 'NA'}",
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildInfoRow(
                        "Category :",
                        "${orderIdResp != null ? orderIdResp['category'] ?? 'NA' : 'NA'}",
                      ),
                      buildInfoRow(
                        "Order Id :",
                        "${orderIdResp != null ? orderIdResp['orderId'] ?? 'NA' : 'NA'}",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInfoRow("Start Time", startTime),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInfoRow("End Time", widget.endtime!),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.01,
                  ),
                 
                  buildInfoRow(
                    "Total Price :",
                    "${orderIdResp != null ? orderIdResp['totalPayment'] ?? 'NA' : 'NA'}",
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.15,
                  ),
                 Column(
       // mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SizedBox(height: 40),
          Image.network(
            paymentReceived
                ? 'https://www.shutterstock.com/image-vector/quick-easy-loan-fast-money-600nw-1857833833.jpg'
                : 'https://www.shutterstock.com/image-vector/quick-easy-loan-fast-money-600nw-1857833833.jpg',
            height: 100,
            width: 100,
          ),
          SizedBox(height: 30),
          paymentReceived
              ? Text("Payment Received", style: TextStyle(color: Colors.black))
              :

              // ElevatedButton(onPressed:(){
              //   completePayment();
              // }, child: Text('payment Received')),
              SwipeButton.expand(
                width: mediaQuery.size.width*0.90,
  thumb: Icon(
    Icons.double_arrow_rounded,
    color: Colors.white,
  ),
  child: Text(
    "Payment Received",
    style: TextStyle(
      color: Colors.black,
    ),
  ),
  activeThumbColor: Colors.black,
  activeTrackColor: Colors.grey.shade300,
  
 onSwipeEnd: () {
   completePayment();
   setState(() {
                      paymentReceived = true;
                      
                    });
 },
  // onSwipe: () {
    
  //   setState(() {
  //                     paymentReceived = true;
                      
  //                   });
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Received"),
  //       backgroundColor: Colors.white,
  //     ),
  //   );
  // },
)  ,

          SizedBox(height: 40),
          if (paymentReceived)          
            Center(
              child: ElevatedButton(

                
                onPressed: () async {
                  await clearAllFunction();
                  // redirect to mapPage
                  // Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => ManNavTab()));
                   showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      content: Container(
       // decoration: BoxDecoration(color: AppColors.white),
        height: MediaQuery.of(context).size.height * 0.5, 
        width: MediaQuery.of(context).size.height * 0.7,// Set the desired height
        child: SingleChildScrollView(
          child: RatingFeedbackPage(employerid : widget.employerid ),
        ),
      ),
    );
  },
);

                  
                },
                child: Text('Go To Home Page',style: TextStyle(color: AppColors.black),),
              ),
            ),
        ],
      ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

class RatingFeedbackPage extends StatefulWidget {

  @override
    final String? employerid;


  RatingFeedbackPage({required this.employerid, Key? key}) : super(key: key);

  _RatingFeedbackPageState createState() => _RatingFeedbackPageState();
}

class _RatingFeedbackPageState extends State<RatingFeedbackPage> {
  int selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  void sendFeedbackToBackend() async {
    print('iddd: ${widget.employerid}');
    final givenBy = GlobalConstant.userID;
    final givenTo = widget.employerid;
    final rating = selectedRating;
    final comments = _feedbackController.text;

    final url = Uri.parse('https://workwave-backend.vercel.app//api/v1/review/');
    final headers = <String, String>{'Content-Type': 'application/json'};
    final body = jsonEncode({
      'givenBy': givenBy,
      'givenTo': givenTo,
      'rating': rating.toString(),
      'comments': comments,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Feedback sent successfully!');
        // Handle navigation or any other action upon successful feedback submission
      } else {
        print('Failed to send feedback: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle error cases if needed
      }
    } catch (e) {
      print('Error sending feedback: $e');
      // Handle error cases if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Rate your experience',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRating = index + 1;
                  });
                },
                child: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  size: 33.0,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _feedbackController,
            decoration: InputDecoration(
              hintText: 'Enter your feedback...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Call the function to send feedback to the backend
              sendFeedbackToBackend();
              Navigator.pop(context); // Close the bottom sheet
              // Navigate to the home page or perform any other action upon feedback submission
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>ManNavTab()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Set the background color to black
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

    @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}