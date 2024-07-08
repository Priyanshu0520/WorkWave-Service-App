import 'dart:convert';
import 'package:http/http.dart' as http;

import 'global_constants.dart';

class ManCompletedOrderservice {
  final String apiUrl =
      'https://workwave-backend.vercel.app/api/v1/manpower/get/getCompletedOrderByManPowerId/' +
          GlobalConstant.userID;

  Future<List<Map<String, dynamic>>> fetchCompletedOrders() async {
  try {
    final response = await http.get(Uri.parse('$apiUrl'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      print('API Response: $data');

      // Extracting completedOrders directly from the response
      final completedOrders = List<Map<String, dynamic>>.from(data
          .expand((user) =>
              user['completedOrders']
                  .map((order) => order['order'])
                  .toList()));

     final reversedCompletedOrders = completedOrders.reversed.toList();

        return reversedCompletedOrders;
    } else {
      throw Exception('Failed to load completed orders');
    }
  } catch (error) {
    print('Error fetching completed orders: $error');
    throw Exception('No data Available');
  }
}

}
