// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wayforce/main.dart';
import 'package:wayforce/new%20utils/colors.dart';
import 'package:wayforce/new%20utils/const.dart';
import 'package:wayforce/new_services/manpower_ongoing_services.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/UserInfo/man_info_services.dart';
import '../../../new_services/firebase/new_local_notification.dart';
import '../../../new_services/global_constants.dart';

import '../../../shared_pref_service.dart';
import '../../TrackPage/manpower_timer_page.dart';
import '../../TrackPage/manpower_track_page.dart';
import '../../billing_payment_screens/manPowerBillingScreen.dart';

class ManPowerHomePage extends StatefulWidget {
  const ManPowerHomePage({Key? key}) : super(key: key);

  @override
  State<ManPowerHomePage> createState() => _ManPowerHomePageState();
}

class _ManPowerHomePageState extends State<ManPowerHomePage> with SingleTickerProviderStateMixin {
  String locationName = '';
  double latitude = 0.0;
  double longitude = 0.0;
  Set<Marker> markers = {};
  bool isSwitchScreenOpen = false;
  late GoogleMapController _mapController;
  late LatLng _initialPosition;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
 ManpowerUserService _manpowerUserService = ManpowerUserService();
  Map<String, dynamic>? manpowerUserData;
  List<dynamic> instantOngoing = [];
  final List<String> data = [];
  String orderId = '';
  String onGoingOrder = '';
  var orderData;
  AnimationController ?_controller;
    late Timer _timer;
  @override
  void initState() {
    _initialPosition = const LatLng(28.474388, 77.503990);
    super.initState();
     _initCurrentLocation();
   
     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Fetch data from the API
     _getUserLocation();
    _getUserLocation();
     });
    _initFirebaseMessaging();
      fetchManpowerUserData();
       Provider.of<ManOngoingOrdersProvider>(context, listen: false)
        .fetchOngoingOrdersMan(context);
        _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Adjust the duration as needed
    )..repeat(reverse: true);
  }

  Future<void> fetchManpowerUserData() async {
    try {
      final Map<String, dynamic>? data =
          await _manpowerUserService.fetchManpowerUserData();

      if (data != null) {
        setState(() {
          manpowerUserData = data;
        });
      } else {
        print('Received null data from the API');
        // Handle the case when data is null, if needed
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }
  Future<void> _initFirebaseMessaging() async {
    _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    print('Device Token: $token');
    sendTokenToBackend(token);
  }

  handleBackgroundClick() async {
    var allFirebaseBackgroundNotificationData =
        await SharedPreferencesHelper.getBackgroundNotificationData();
    if (allFirebaseBackgroundNotificationData != null &&
        allFirebaseBackgroundNotificationData.length > 0) {
      var savedFirebaseBackgroundNotificationData =
          jsonDecode(allFirebaseBackgroundNotificationData);

      NewPushNotification().showNewNotification(
          globalNavigatorKey.currentContext,
          savedFirebaseBackgroundNotificationData['notificationTitle'],
          savedFirebaseBackgroundNotificationData['notificationBody'],
          savedFirebaseBackgroundNotificationData['notificationData']);
    }
  }

  final Geolocator _geolocator = Geolocator();

  Position? _currentLocation;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    handleBackgroundClick();
   
      var mediaQuery = MediaQuery.of(context);
      return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Image.asset(
              'assets/images/iclogo.png',
              width: mediaQuery.size.width * 0.2, 
              height: mediaQuery.size.height * 0.11,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                'Employer',
                style: SafeGoogleFont(
                  'Montserrat',
                  fontSize: mediaQuery.size.width * 0.03,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
                Text(
                  locationName,
                  style: SafeGoogleFont('Montserrat',
                      fontSize: mediaQuery.size.width * 0.03,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            size: 30,
            color: Colors.black,
            Icons.notifications),
        )],
        
      ),
        body: Stack(
        children: [
         
          Stack(
            children:[ GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: CameraPosition(
                      
            target: _initialPosition,
            zoom: 10.0,
                    ),
                    myLocationEnabled: true, // Show user's location on the map
                    myLocationButtonEnabled: true, // Enable button to center map on user's location
                    markers: _markers,
                    zoomControlsEnabled: false,
                   cameraTargetBounds: CameraTargetBounds.unbounded, // Allow user to explore map freely
                  ),
                     Positioned(
                      bottom: 10,
                      right: 10,
                       child: ElevatedButton(onPressed: () {
                             setState(() {
                               isSwitchScreenOpen = !isSwitchScreenOpen;
                             });
                           },
                           child: isSwitchScreenOpen ? Icon(Icons.arrow_upward, color: AppColors.black,) : Icon(Icons.arrow_upward, color: AppColors.black), // Toggle icon based on isSwitchScreenOpen state
                           
                         ),
                     ),
         ] ),
         
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: isSwitchScreenOpen ?  mediaQuery.size.height*0.90 :  mediaQuery.size.height*0.05,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isSwitchScreenOpen = isSwitchScreenOpen;
                });
              },
              child: Container(
                decoration: BoxDecoration(

                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
                ),
                height: mediaQuery.size.height*0.90,
                
                child: 
            Container(
              height: mediaQuery.size.height * 0.155,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.lightgrey,
                border: Border.all(color: AppColors.grey)
              ),
              child: Column(
                children: [
                   Stack(
      children: [
        if(manpowerUserData?['isKyc'] =="No")
       AnimatedBuilder(
  animation: _controller!,
  builder: (context, child) {
    double screenWidth = MediaQuery.of(context).size.width;
    double translation = screenWidth * _controller!.value;
    bool moveToLeft = _controller!.value <0.5;
    if (!moveToLeft) {
      translation = screenWidth - translation;
    }
    return Transform.translate(
      offset: Offset(moveToLeft ? translation : -translation, 0),
      child: Text(
        'Please Verify your KYC..',
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
    );
  },
),

      ],
    ),
                 
                  SizedBox(
                height: mediaQuery.size.height * 0.1,
              ),
                   Image.asset(
                'assets/images/iclogo.png',
                scale:mediaQuery.size.width * 0.006 ,
                // width: mediaQuery.size.width * 0.65, 
                // height: mediaQuery.size.height * 0.65,
              ),
              
              // SizedBox(
              //   height: mediaQuery.size.height * 0.2,
              // )
              Text(manpowerUserData?['name'] ?? ''),
               SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(" Location : ",
                          style: SafeGoogleFont(
                            'Inter',
                            fontSize: mediaQuery.size.width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          )),
                      Text(
                        "  ${locationName}",
                        style: SafeGoogleFont(
                          'Inter',
                          fontSize: mediaQuery.size.width * 0.03,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff222222),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(
                        height: mediaQuery.size.height * 0.03,
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Today's Orders.",
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: mediaQuery.size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                          Text(
                            manpowerUserData?['totalOrdersToday'].toString() ?? '',
                            style: SafeGoogleFont(
                              'Inter',
                              fontSize: mediaQuery.size.width * 0.03,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff222222),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: mediaQuery.size.width * 0.10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: AppColors.lightgrey,
                        ),
                        child: Column(
                          children: [
                            
                            Text(
                              "Today's Payments",
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: mediaQuery.size.width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              manpowerUserData?['totalPaymentToday'].toString() ?? '',
                              style: SafeGoogleFont(
                                'Inter',
                                fontSize: mediaQuery.size.width * 0.03,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff222222),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.16,
                  ),
               Padding(
                 padding:  EdgeInsets.only(left: mediaQuery.size.width * 0.72),
                 child: ElevatedButton(onPressed: () {
                               setState(() {
                                 isSwitchScreenOpen = !isSwitchScreenOpen;
                               });
                             },
                             child: isSwitchScreenOpen ? Icon(Icons.arrow_downward, color: AppColors.black,) : Icon(Icons.arrow_downward, color: AppColors.black), // Toggle icon based on isSwitchScreenOpen state
                             
                           ),
               ),
                
                ],
              ),
            ),
              ),
            ),
          ),
         
           Positioned(
            bottom: mediaQuery.size.height*0.0,
             child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: FutureBuilder<List<ManOngoingOrder>>(
                        future: Provider.of<ManOngoingOrdersProvider>(context)
                            .fetchOngoingOrdersMan(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: Text('   '));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: MediaQuery.of(context).size.height * 0.16,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ManBillingPage(
                                                 orderId: order.orderId,
                                                 employerId: order.employerId,
                                                endTime: order.endTime),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: mediaQuery.size.height * 0.16,
                                      width: mediaQuery.size.width * 0.98,

                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 2, 5),
                                      padding: const EdgeInsets.fromLTRB(
                                          23, 17, 18.23, 13),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
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
                                  );
                                },
                              ),
                            );
                          } else {
                            return Text(' ');
                          }
                        },
                      ),
                    ),
           ),
        ],
      ),
   
);
    
      
    
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        markerId: MarkerId("userLocation"),
        position: _initialPosition,
        infoWindow: InfoWindow(title: "Your Location"),
      ));
    });
  }

  Future<void> _initCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permission are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permission are permanently denies, we cannot get you location for job');
      }
      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placeMarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placeMarks.isNotEmpty) {
          Placemark placeMark = placeMarks[0];
          setState(() {
            locationName =
                '${placeMark.subLocality ?? 'Unknown'}, ${placeMark.locality ?? 'Unknown'}';
            latitude = position.latitude;
            longitude = position.longitude;
            _currentLocation = position;
         //   _updateMarkers();
          });

          await sendManpowerCurrentLocationBackend(
              latitude, longitude, locationName);

          print('Location Name: $locationName');
          print('Latitude: $latitude');
          print('Longitude: $longitude');
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }


  Future<void> sendManpowerCurrentLocationBackend(
      double latitude, double longitude, String locationName) async {
    print(GlobalConstant.firebaseToken);
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/manpower/updateManpowerLocation/" +
            GlobalConstant.userID);

    await http
        .put(requestUri,
            body: jsonEncode({
              'siteLocation': locationName,
              'lati': latitude,
              'longi': longitude
            }),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
          } else if (response.statusCode == 400) {
            print(response);
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print(response);
          } else if (response.statusCode == 500) {
            print(response);
          }
        })
        .catchError((error) {
          print(error);
        });
  }

  void sendTokenToBackend(token) async {
    print(token);
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/update/ManpowerToken/" +
            GlobalConstant.userID);

    await http
        .put(requestUri,
            body: jsonEncode({"newToken": token}),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
          } else if (response.statusCode == 400) {
            print(response);
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print(response);
          } else if (response.statusCode == 500) {
            print(response);
          }
        })
        .catchError((error) {
          print(error);
        });
  }
}
