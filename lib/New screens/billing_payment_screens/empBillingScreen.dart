// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wayforce/new%20utils/const.dart';
import 'package:wayforce/New%20screens/billing_payment_screens/empSuccessPayment.dart';

class EmpBillingPage extends StatefulWidget {
  EmpBillingPage({ this.manpowerId, this.newOrderId, this.category});
 
  final String ?newOrderId;
  String ?category;

  String? manpowerId;

  @override
  State<EmpBillingPage> createState() => _EmpBillingPageState();
}

class _EmpBillingPageState extends State<EmpBillingPage> {
  var orderData;
 
  String orderId = '';
  String duration = 'NA';
  String selectedPaymentMethod = '';
  bool _dispose = false;
  bool isLoading = true;

  @override
  void initState() {
    isEmpMapPage = false;
    isEmpOtpPage = false;
    _getOrderDetails();
    super.initState();
  }

  Future<void> _getOrderDetails() async {
    String? orderId = widget.newOrderId;
    print(orderId);

    try {
      var response = await http.get(Uri.parse(
          "https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$orderId"));
      var json = jsonDecode(response.body);
      print("bil page res : ${json}");

      if (response.statusCode == 200) {
        var data = json['data']; // Access the 'data' field directly

        if (data != null) {
          if (_dispose) {
            return;
          } else {
            orderData = data;
            String startTime = orderData['startTime'].toString();
            String endTime = orderData['endTime'].toString();

            calculateTimeDifference(startTime, endTime);
            setState(() {
              isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }


  void calculateTimeDifference(String startTimeStr, String endTimeStr) {
    try {
      DateTime startTime = DateTime.parse(startTimeStr);
      DateTime endTime = DateTime.parse(endTimeStr);

      int _seconds = endTime.difference(startTime).inSeconds;

      int hours = _seconds ~/ 3600;
      int minutes = (_seconds % 3600) ~/ 60;
      int remainingSeconds = _seconds % 60;

      String formattedTime =
          '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

      duration = formattedTime;
    } catch (e) {
      print('Error parsing dates: $e');
      duration = 'NA'; // Set a default value or handle the error as needed
    }
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // orderData == null
                           Text(
                              "Date : ${orderData['date']} ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                     
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // orderData == null
                           Text(
                              "Category :  ${widget.category}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                      orderData == null
                          ? Text("NA")
                          : Text(
                              "Order Id : ${orderData['orderId'] != null ? orderData['orderId'].toString() : 'NA'}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start Time",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          orderData == null
                              ? Text("NA")
                              : Text(
                                  orderData['startTime'] != null
                                      ? orderData['startTime'].toString()
                                      : 'NA',
                                  style: TextStyle(
                                   fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                                  ),
                                ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "End Time",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          orderData == null
                              ? Text("NA")
                              : Text(
                                  orderData['endTime'] != null
                                      ? orderData['endTime'].toString()
                                      : 'NA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  orderData == null
                      ? Text("NA")
                      : Text(
                          "Duration : ${orderData['workingHours'] != null ? orderData['workingHours'].toString() : 'NA'}",
                          style: TextStyle(
                           fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                          ),
                        ),
                  SizedBox(height: screenHeight * 0.02),
                  orderData == null
                      ? Text("NA")
                      : Text(
                          "Pay: ${orderData['totalPayment'] != null ? orderData['totalPayment'].toString() : 'NA'}",
                          style: TextStyle(
                           fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.035,
                          ),
                        ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Select Payment Method:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedPaymentMethod.isEmpty
                          ? null
                          : selectedPaymentMethod,
                      underline: Container(),
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      focusColor: Colors.grey,
                      hint: const Text("Choose Payment Method"),
                      items: <String>['Online', 'Offline'].map((String method) {
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPaymentMethod = newValue.toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedPaymentMethod.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Please select payment method.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                          );
                        } else {
                         // completePayment(context);
                          clearAllFunction();
        isManMapPage = false;
        isManOtpPage = false;
        isEmpDetectPage = false;
        isEmpMapPage = false;
        isEmpOtpPage = false;
                          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>  EmpPaymentSuccess(manpowerId: widget.manpowerId,)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.black,
                      ),
                      child: Text(
                        'Proceed to Pay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Stack(
              children: [
                Opacity(
                  opacity: 0.7,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.grey,
                  ),
                ),
                Center(
                  child: Container(
                    height: screenHeight * 0.1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            width: screenWidth * 0.03,
                          ),
                          Text(
                            'Fetching.....',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
