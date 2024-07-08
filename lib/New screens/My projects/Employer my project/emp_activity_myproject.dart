import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wayforce/new%20utils/const.dart';
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/emp_completed _order_services.dart';
import '../../../new_services/employer_ongoing_services.dart';
import '../../TrackPage/emp_timer_page.dart';
import '../../billing_payment_screens/empBillingScreen.dart';
import '../../TrackPage/employer_track_page.dart';
import '../../instantHire/instanthire.dart';
import 'project_details.dart';

class EmployerMyProject extends StatefulWidget {
  const EmployerMyProject({super.key});

  @override
  State<EmployerMyProject> createState() => _EmployerMyProjectState();
}

class _EmployerMyProjectState extends State<EmployerMyProject> {
  int counter = 0;
  @override
  void initState() {
    super.initState();

    Provider.of<EmpOngoingOrdersProvider>(context, listen: false)
      .fetchOngoingOrders(context);

  
  Timer.periodic(Duration(seconds: 30), (timer) {
    Provider.of<EmpOngoingOrdersProvider>(context, listen: false)
        .fetchOngoingOrders(context);
  });
    _completedOrders = _apiService.fetchCompletedOrders();
  }
   List<dynamic> instantongoing = [];
 
 


  var orderid;
  final EmpCompletedOrderService _apiService = EmpCompletedOrderService();
  late Future<List<Map<String, dynamic>>> _completedOrders;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
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
                ],
              ),
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
                child: Container(
                    // color: AppColors.grey,
                    width: mediaQuery.size.width * 0.90,
                    height: mediaQuery.size.height * 0.17,
                    child: Consumer<EmpOngoingOrdersProvider>(
                      builder: (context, provider, child) {
                        if (provider.ongoingOrders.isNotEmpty) {
                       
                          return ListView.builder(
                            itemCount: provider.ongoingOrders.length,
                            itemBuilder: (context, index) {
                              var order = provider.ongoingOrders[index];
                              return GestureDetector(
                                onTap: () {
                                   if (order.startTime.isEmpty && order.endTime.isEmpty){
                                  
                                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                           EmployeTrack(
                                            orderprice: order.bookedPayment ??"",
                                            orderworkdetail: order.explainYourWork??"",
                                            orderworkinghrs: order.workingHours??"",
                                            orderlocation: order.siteLocation??"" ,
                                            orderotp: order.otpSendToEmployer??"",
                                             ordercategory: order.category??"", manpowerid: order.manpowerId??"", orderid: order.orderId??"", orderlat: order.lati??"", orderlongi: order.longi??"")));
          
                                   }else if(order.startTime.isNotEmpty&& order.endTime.isNotEmpty&& order.orderStatus =='Ongoing'&&order.paymentStatus =='Pending'){
                                    // print('end empty');
                                      manStartWork.value = true;
                                      Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      EmpTimerPage(orderprice: order.bookedPayment ??"",
                                            orderworkdetail: order.explainYourWork??"",
                                            orderworkinghrs: order.workingHours??"",
                                            orderlocation: order.siteLocation??"" ,
                                            orderotp: order.otpSendToEmployer??"",
                                             ordercategory: order.category??"", manpowerid: order.manpowerId??"", orderid: order.orderId??"", orderlat: order.lati??"", orderlongi: order.longi??"")
                                          ));
                                   }else if(order.startTime.isNotEmpty&& order.endTime.isNotEmpty&&  order.orderStatus =='Completed'){
                                    //  print('both not empty');
                                    //  print('${order.paymentStatus}');
                             
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                           EmpBillingPageIn(newOrderId: order.orderId??"",
                                           category: order.category??"",
                                           )));
                          
                                   }
                                },
                                child: Card(
                                    child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 2, 5),
                                  padding: const EdgeInsets.fromLTRB(
                                      23, 17, 18.23, 13),
                                  decoration: BoxDecoration(
                                    //color: AppColors.lightgrey,
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
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2125,
                                              color: const Color(0xff222222),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.place_rounded,
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: mediaQuery.size.width *
                                                    0.02,
                                              ),
                                              SizedBox(
                                                width: mediaQuery.size.width *
                                                    0.36,
                                                child: Text(
                                                  '${order.siteLocation}',
                                                  overflow: TextOverflow.clip,
                                                  style: SafeGoogleFont(
                                                    'League Spartan',
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    height: 0.92,
                                                    color: const Color(
                                                        0xff000000),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            "Working Hours : ${order.workingHours}",
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2125,
                                              color: const Color(0xff222222),
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "${order.category}",
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2125,
                                              color: const Color(0xff222222),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.black,
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
                                                const Icon(
                                                  Icons.circle,
                                                  color: Colors.green,
                                                  size: 15,
                                                ),
                                                Text(
                                                  'Ongoing',
                                                  style: SafeGoogleFont(
                                                    'League Spartan',
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    height: 0.92,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Price : ${order.bookedPayment}',
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              height: 1.2125,
                                              color: const Color(0xff222222),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                              );
                            },
                          );
                        } else {
                          // print('not coming');
                           return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                           InstantHirePage()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.lightgrey,
                              ),
                              height: mediaQuery.size.height * 0.10,
                              width: mediaQuery.size.width ,
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
                                          height: mediaQuery.size.width*0.05,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Reserve your Work ',
                                              style: SafeGoogleFont(
                                                'Inter',
                                                fontSize:
                                                    mediaQuery.size.width *
                                                        0.04,
                                                fontWeight: FontWeight.w300,
                                                color: AppColors.black,
                                              ),
                                            ),
                                            const Icon(Icons.forward)
                                          ],
                                        ),
                                      ],
                                    ),
                                     SizedBox(
                                      width: mediaQuery.size.width*0.20,
                                    ),
                                     Icon(
                                      Icons.work_off_rounded,
                                      size: mediaQuery.size.width*0.15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )),
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
                  height: mediaQuery.size.height*0.90,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    
                    future: _completedOrders,
                    builder: (context, snapshot) {
                    print(' completed  ${snapshot.data}');
                                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong..'));
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No completed orders available.'));
                                } else {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final order = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmpOrderdetails(
                                          strttime:'${order['startTime']}' ,
                                          endtime: '${order['endTime']}',
                                          manpowerpic:order['manpower']['profileImage'],
                                              manpowername: '${order['manpower']['name']}',
                                              price: '${order['bookedPayment']}',
                                              category: '${order['category']}',
                                              date: '${order['date']}',
                                              location: '${order['siteLocation']}',
                                              paystatus: '${order['paymentStatus']}',
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    
                                      CircleAvatar(
                                    radius: mediaQuery.size.width * 0.09,
                                    backgroundImage: NetworkImage(order['manpower']['profileImage']??  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU',),
                                  ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: ${order['manpower']['name']??""}',
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize:
                                                  mediaQuery.size.width * 0.03,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Date :  ${order['date']??""}',
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize:
                                                  mediaQuery.size.width * 0.03,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.black,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Price :  ${order['bookedPayment']}',
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize:
                                                  mediaQuery.size.width * 0.03,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '   ${order['category']}',
                                            style: SafeGoogleFont(
                                              'Inter',
                                              fontSize:
                                                  mediaQuery.size.width * 0.03,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                           
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
