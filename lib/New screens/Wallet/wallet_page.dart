// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wayforce/new_services/global_constants.dart';
import '../../new utils/colors.dart';

class WalletPage extends StatefulWidget {
  int ?last7daypay;
  int ?last7dayorder;
  int ?last30daypay;
  int ?last30dayorder;
   WalletPage({  this.last30dayorder,  this.last30daypay,  this.last7daypay,  this.last7dayorder,   Key? key}) ;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late List<dynamic> _transactionsList = [];
double ?_walletData;
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
  final apiUrl = 'https://workwave-backend.vercel.app/api/v1/transactions/' +
      GlobalConstant.userID; // Replace with your actual API endpoint

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> transactions = data['transactions'];
      // Assuming there's only one transaction in the list for simplicity
      if (transactions.isNotEmpty) {
        final userTransactions = transactions[0]['userTransactions'];
        final walletData = transactions[0]['wallet'];

        // Check the type of walletData
        final reversedTransactions = List.from(userTransactions.reversed);

        // Check the type of walletData
        if (walletData is int) {
          // If it's an int, assign it to _walletData
          setState(() {
            _transactionsList = reversedTransactions;
            _walletData = walletData.toDouble();
          });
        } else if (walletData is double) {
          // If it's a double, assign it to _walletData
          setState(() {
            _transactionsList = reversedTransactions;
            _walletData = walletData;
          });
        } else {
          // Handle other cases if necessary
        }
      }
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to load data: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
     final fontSizeTitle = mediaQuery.size.width * 0.04;
    final fontSizeAmount = mediaQuery.size.width * 0.037;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wallet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: mediaQuery.size.height * 0.25,
                width: mediaQuery.size.width * 0.90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                   color: AppColors.lightgrey,
                  // gradient: LinearGradient(
                  //   colors: [
                  //     AppColors.white,
                  //     AppColors.blackshadow,
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('WayForce Wallet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              )),
                          Text('₹${_walletData != null ? _walletData!.toStringAsFixed(2) : '0.00'}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(height: mediaQuery.size.height * 0.07),
                          Row(
                            children: [
                              Container(
                                width: mediaQuery.size.width * 0.30,
                                height: mediaQuery.size.height * 0.04,
                                decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    '+ Add money',
                                    style: TextStyle(
                                      fontSize: mediaQuery.size.width * 0.03,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: mediaQuery.size.width * 0.18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(height: mediaQuery.size.height * 0.02),
              if(GlobalConstant.userType == "Manpower")
              Center(
                child: Container(
                          width: mediaQuery.size.width * 0.88,
                          height: mediaQuery.size.height * 0.14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.lightgrey,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Last 7 Days',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeTitle),
                      ),
                      // Divider(
                      //   color: Colors.grey,
                      //   thickness: 2,
                      // ),
                      Text(
                        '₹${widget.last7daypay}',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeAmount),
                      ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                       Text(
                        'Orders',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeTitle),
                      ),
                       Text(
                      '${widget.last7dayorder}',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeAmount),
                      ),
                    ],
                  ),
                ),
                // VerticalDivider(
                //   color: Colors.grey,
                //   thickness: 2,
                // ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Last 30 Days',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeTitle),
                      ),
                      // Divider(
                      //   color: Colors.grey,
                      //   thickness: 2,
                      // ),
                      Text(
                          '₹${widget.last30daypay}',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeAmount),
                      ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Text(
                        'Orders',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeTitle),
                      ),
                       Text(
                        '${widget.last30dayorder}',
                        style: TextStyle(color: Colors.black, fontSize: fontSizeAmount),
                      ),
                    ],
                  ),
                ),
                            ],
                          ),
                        ),
              ),
      
              SizedBox(height: mediaQuery.size.height * 0.02),
              Text(
                'Payment History',
                style: TextStyle(
                  fontSize: mediaQuery.size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.02),
              Expanded(
                child: ListView.builder(
                  itemCount: _transactionsList.length,
                  itemBuilder: (context, index) {
                    final transaction = _transactionsList[index];
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2125,
                                    color: const Color(0xff272729),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "₹${transaction['amount']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2125,
                                    color: const Color(0xff8c8d99),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Description: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2125,
                                  color: const Color(0xff272729),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${transaction['description']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2125,
                                  color: const Color(0xff8c8d99),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
