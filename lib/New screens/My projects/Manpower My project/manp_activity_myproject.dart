import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayforce/new%20utils/const.dart';
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/manpower_completed_order_service.dart';
import '../../../new_services/manpower_ongoing_services.dart';
import '../../TrackPage/manpower_timer_page.dart';
import '../../billing_payment_screens/manPowerBillingScreen.dart';
import '../../TrackPage/manpower_track_page.dart';
import '../../bottomnav bars/manp_bottom_navbar_provider.dart';
import 'project_detail_page.dart';

class ManMyProjects extends StatefulWidget {
  const ManMyProjects({super.key});

  @override
  State<ManMyProjects> createState() => _ManMyProjectsState();
}

class _ManMyProjectsState extends State<ManMyProjects> {
  int counter = 0;

  List<dynamic> instantongoing = [];
  final List<String> data = [];
  String orderId = '';
  String onGoingOrder = '';
  var orderData;
  bool _dispose = false;
  late Timer _timer;

  get json => null;
  @override
  void initState() {
    super.initState();
    Provider.of<ManOngoingOrdersProvider>(context, listen: false)
        .fetchOngoingOrdersMan(context);
 
    _completedOrders = _apiService.fetchCompletedOrders();
  }

  final ManCompletedOrderservice _apiService = ManCompletedOrderservice();
  late Future<List<Map<String, dynamic>>> _completedOrders;
  var orderid;
  var isloading = true;
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ChangeNotifierProvider(
        create: (_) => ManBottomNavBarProvider(), // Provide the TabProvider
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Work',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: mediaQuery.size.width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Wave',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: mediaQuery.size.width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Activity',
                      textAlign: TextAlign.start,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: mediaQuery.size.width * 0.08,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Ongoing',
                      textAlign: TextAlign.start,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: mediaQuery.size.width * 0.05,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FutureBuilder<List<ManOngoingOrder>>(
                      future: Provider.of<ManOngoingOrdersProvider>(context)
                          .fetchOngoingOrdersMan(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            height: MediaQuery.of(context).size.height * 0.16,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var order = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    if (order.startTime.isEmpty &&
                                        order.endTime.isEmpty) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManpowerTrack(
                                                    orderPrice:
                                                        order.bookedPayment,
                                                    orderWorkDetail:
                                                        order.explainYourWork,
                                                    orderWorkingHour:
                                                        order.workingHours,
                                                    orderLocation:
                                                        order.siteLocation,
                                                    orderOtp:
                                                        order.otpSendToEmployer,
                                                    orderCategory:
                                                        order.category,
                                                    employerId:
                                                        order.employerId,
                                                    orderId: order.orderId,
                                                    orderLat: order.lati,
                                                    orderLong: order.long,
                                                  )));
                                    } else if (order.startTime.isNotEmpty &&
                                            order.endTime.isNotEmpty &&
                                            order.orderStatus == 'Ongoing' &&
                                            order.paymentStatus == 'Pending'
                                        //  &&  order.workingHours== order.endTime
                                        ) {
                                      // print(
                                      //     'endTime contains a single-digit number: ${order.endTime}');
                                      manStartWork.value = true;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManpowerTimerPage(
                                                      orderPrice:
                                                          order.bookedPayment,
                                                      orderWorkDetail:
                                                          order.explainYourWork,
                                                      orderWorkingHour:
                                                          order.workingHours,
                                                      orderLocation:
                                                          order.siteLocation,
                                                      orderOtp: order
                                                          .otpSendToEmployer,
                                                      orderCategory:
                                                          order.category,
                                                      employerId:
                                                          order.employerId,
                                                      orderId: order.orderId,
                                                      orderLat: order.lati,
                                                      orderLong:
                                                          order.long)));
                                    } else if (order.startTime.isNotEmpty &&
                                        order.endTime.isNotEmpty &&
                                        order.orderStatus == 'Completed') {
                                      //  print('both not empty');
                                      //  print('payment status${order.paymentStatus}');

                                      // print(
                                      //     'Navigating to ManBillingPage');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ManBillingPage(
                                              orderId: order.orderId,
                                              employerId:  order.employerId,
                                              endTime: order.endTime),
                                        ),
                                      );
                                    }
                                  },
                                  child: Card(
                                    child: Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 2, 5),
                                      padding: const EdgeInsets.fromLTRB(
                                          23, 17, 18.23, 13),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Order ID: ${order.orderId} ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff222222)),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.place_rounded,
                                                      size: 18),
                                                  SizedBox(width: 10),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.36,
                                                    child: Text(
                                                      '${order.siteLocation}',
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color(
                                                              0xff000000)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Text(
                                                "Working Hours : ${order.workingHours}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff222222)),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "${order.category}",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff222222)),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                height: 20,
                                                width: 85,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Icon(Icons.circle,
                                                        color: Colors.green,
                                                        size: 15),
                                                    Text(
                                                      'Ongoing',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0.92,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Price : ${order.bookedPayment}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff222222)),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.lightgrey,
                              ),
                              height: mediaQuery.size.height * 0.10,
                              width: mediaQuery.size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'No ongoing booking',
                                          style: SafeGoogleFont(
                                            'Inter',
                                            fontSize:
                                                mediaQuery.size.width * 0.05,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Be ready for booking',
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        0.04,
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.black,
                                              ),
                                            ),
                                            // Icon(Icons.start)
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: mediaQuery.size.width * 0.20,
                                    ),
                                    Icon(
                                      Icons.work_off_rounded,
                                      size: mediaQuery.size.width * 0.15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Past',
                      textAlign: TextAlign.start,
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: mediaQuery.size.width * 0.05,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: mediaQuery.size.height * 0.9,
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _completedOrders,
                        builder: (context, snapshot) {
                          print(' completed  ${snapshot.data}');
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Something Went Wrong'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No completed orders available.'));
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final order = snapshot.data![
                                      index]; // Assuming only one order is present
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ManOrderdetails(
                                                    emppic: order['employer']
                                                            ['profileImage'] ??
                                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU',
                                                    employername:
                                                        '${order['employer']['name']}',
                                                    price:
                                                        '${order['bookedPayment']}',
                                                        strttime:'${order['startTime']}' ,
                                                        endtime: '${order['endTime']}',
                                                    category:
                                                        '${order['category']}',
                                                    date: '${order['date']}',
                                                    location:
                                                        '${order['siteLocation']}',
                                                    paystatus:
                                                        '${order['paymentStatus']}',
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius:
                                                mediaQuery.size.width * 0.09,
                                            backgroundImage: NetworkImage(order[
                                                        'employer']
                                                    ['profileImage'] ??
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order Id: ${order['orderId']}' ??
                                                      "",
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize:
                                                        mediaQuery.size.width *
                                                            0.03,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Date: ${order['date']}' ??
                                                      "",
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize:
                                                        mediaQuery.size.width *
                                                            0.03,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Price: ${order['totalPayment']}' ??
                                                      "",
                                                  style: SafeGoogleFont(
                                                    'Inter',
                                                    fontSize:
                                                        mediaQuery.size.width *
                                                            0.03,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // SizedBox(width: 10),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
