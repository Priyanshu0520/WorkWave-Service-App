// ignore_for_file: unnecessary_type_check

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../shared_pref_service.dart';

class EmpOngoingOrdersProvider extends ChangeNotifier {
  List<EmpOngoingOrder> _ongoingOrders = [];

  List<EmpOngoingOrder> get ongoingOrders => _ongoingOrders;

  Future<void> fetchOngoingOrders(BuildContext context) async {
  try {
    // Retrieve user data from SharedPreferences
    String? userData = await SharedPreferencesHelper.getUserData();

    if (userData != null) {
      Map<String, dynamic> userMap = json.decode(userData);
      String userId = userMap['userID'];

      List<EmpOngoingOrder> orders =
          await EmpOngoingOrdersService.fetchOngoingOrders(userId);

      _ongoingOrders = orders;
      notifyListeners();
    } else {
      print('User data not found in SharedPreferences');
    }
  } catch (error, stackTrace) {
    print('Error fetching ongoing orders: $error');
    print('Stack trace: $stackTrace');
  }
}
}
class EmpOngoingOrdersService {
 static Future<List<EmpOngoingOrder>> fetchOngoingOrders(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://workwave-backend.vercel.app/api/v1/employer/getOngoingOrder/$userId',
        ),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData != null && responseData is Map<String, dynamic>) {
          final List<dynamic>? data = responseData['data'];

          if (data != null && data is List<dynamic>) {
            final List<EmpOngoingOrder> ongoingOrders = data
                .expand((employerData) =>
                    (employerData['ongoingOrders'] as List<dynamic>)
                        .map((orderData) =>
                            EmpOngoingOrder.fromJson(orderData))
                        .toList())
                .toList();
                final reversedongoingorder = ongoingOrders.reversed.toList();
            return reversedongoingorder;
          } else {
            throw Exception('Invalid data field format');
          }
        } else {
          throw Exception('Invalid response data format');
        }
      } else {
        throw Exception('Failed to load ongoing orders');
      }
    } catch (error) {
      print('Error fetching ongoing orders: $error');
      throw Exception('Failed to load ongoing orders');
    }
  }

}

class EmpOngoingOrder {
  final String id;
  final String siteLocation;
  final String category;
  final String explainYourWork;
  //final DateTime date;
  final double lati;
  final double longi;
  final String instantOrdirect;
  final String orderId;
  final int? workingHours;
  final int? bookedPayment;
  final String orderStatus;
  final String paymentStatus;
  final String employerId;
  final String manpowerId;
  final String otpSendToEmployer;
  final String otpSendToManpower;
  final String endTime;
  final String startTime;

  EmpOngoingOrder({
   required this.id,
    required this.siteLocation,
    required this.category,
    required this.explainYourWork,
  //  required this.date,
    required this.lati,
    required this.longi,
    required this.instantOrdirect,
    required this.orderId,
    required this.workingHours,
    required this.bookedPayment,
    required this.orderStatus,
    required this.paymentStatus,
    required this.employerId,
    required this.manpowerId,
    required this.otpSendToEmployer,
    required this.otpSendToManpower,
    required this.endTime,
    required this.startTime,
  });

  factory EmpOngoingOrder.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value);
      } else {
        return null;
      }
    }

    return EmpOngoingOrder(
      id: json['_id'],
      siteLocation: json['siteLocation'],
      category: json['category'],
      explainYourWork: json['explainYourWork'],
    //  date: DateTime.parse(json['date']),
      lati: json['lati'].toDouble(),
      longi: json['longi'].toDouble(),
      instantOrdirect: json['instantOrdirect'],
      orderId: json['orderId'],
      workingHours: parseNullableInt(json['workingHours']),
      bookedPayment: parseNullableInt(json['bookedPayment']) ?? 0,
      orderStatus: json['orderStatus'],
      paymentStatus: json['paymentStatus'],
      employerId: json['employerId'],
      manpowerId: json['manpowerId'],
      otpSendToEmployer: json['otpSendToEmployer'],
      otpSendToManpower: json['otpSendToManpower'],
      endTime: json['endTime'],
      startTime: json['startTime'],
    );
  }
}


