// ignore_for_file: unused_element

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wayforce/main.dart';
import 'package:wayforce/new_services/firebase/new_local_notification.dart';
import 'package:wayforce/new_services/global_constants.dart';
import 'package:wayforce/shared_pref_service.dart';
import '../../../new utils/colors.dart';
import '../../../new utils/utils.dart';
import '../../../new_services/category_services.dart';
import '../../../new_services/emp_completed _order_services.dart';
import '../../../new_services/get_all_manpower_services.dart';
import '../../instantHire/instanthire.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import '../../instantHire/show_nearby_manpower_order_Detail.dart';
import 'category_list_screen.dart';

class EmpHomePage extends StatefulWidget {
  const EmpHomePage({super.key});

  @override
  State<EmpHomePage> createState() => _EmpHomePageState();
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

class _EmpHomePageState extends State<EmpHomePage> {
  final AllManpower allManpower = AllManpower();
  String locationName = '';
  double latitude = 0.0;
  double longitude = 0.0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final EmpCompletedOrderService _apiService = EmpCompletedOrderService();
  late Future<List<Map<String, dynamic>>> _completedOrders;
  List<dynamic> _data = [];
  @override
  void initState() {
    super.initState();
     fetchData();
    _getCurrentLocation();
    //sendFCMTokenToBackend();
    loadCategories();
    _firebaseMessaging.requestPermission();
    _initFirebaseMessaging();

    _completedOrders = _apiService.fetchCompletedOrders();
  }

  Future<void> _initFirebaseMessaging() async {
    _firebaseMessaging.requestPermission();
    String? token = await _firebaseMessaging.getToken();
    print('Device Token: $token');
    sendTokenToBackend(token);
  }

  List<String> categoryNames = [];
  List<String> categoryId = [];
  List<String> categoryImage = [];

  Future<void> loadCategories() async {
    await CategoryService.fetchCategories();
    setState(() {
      categoryNames = CategoryService.getCategoryNames();
      categoryId = CategoryService.getCategoryId();
      categoryImage = CategoryService.getCategoryImages().cast<String>();
    });
  }

  int hoveredIndex = -1;
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
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(height: mediaQuery.size.height * 0.03),
          Container(
            height: mediaQuery.size.height * 0.09,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(50.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppColors.black,
                  size: mediaQuery.size.width * 0.09,
                ),
                SizedBox(width: mediaQuery.size.width * 0.03),
                Expanded(
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InstantHirePage()));
                      },
                      child: Text(
                        'Search\nManpower',
                        style: SafeGoogleFont('Montserrat',
                            fontSize: mediaQuery.size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700),
                      )),
                ),
                const VerticalDivider(
                  color: AppColors.blackShadow,
                  thickness: 1,
                ),
                SizedBox(width: mediaQuery.size.width * 0.04),
                Container(
                    width: mediaQuery.size.width * 0.32,
                    height: mediaQuery.size.height * 0.05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: AppColors.white),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Icon(Icons.date_range_outlined),
                            SizedBox(
                              width: mediaQuery.size.width * 0.01,
                            ),
                            Text(
                              'Now',
                              style: SafeGoogleFont('Montserrat',
                                  fontSize: mediaQuery.size.width * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black),
                            ),
                            const RotationTransition(
                                turns: AlwaysStoppedAnimation(270 / 360),
                                child: Icon(Icons.navigate_before)),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
  future: _completedOrders,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else {
      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
        return SizedBox(
          height: null, // If there is data, let the height be determined by the content
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length >= 2 ? 2 : snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![snapshot.data!.length - index - 1];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstantHirePage(
                        lati: order['lati'].toString(),
                        longitude: order['longi'].toString(),
                        workDetail: order['explainYourWork'],
                        workHour: order['workingHours'],
                        //  price: order['bookedPayment'],
                        category1: order['category'],
                        siteLocation: order['siteLocation'],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.category),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '   ${order['category']}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ' ${order['siteLocation']}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: mediaQuery.size.width * 0.03,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.navigate_next_sharp),
                ),
              );
            },
          ),
        );
      } else {
        // If no data, return a placeholder or an empty container
        return Container();
      }
    }
  },
),
// _data.isEmpty
//           ? Center(child: SizedBox())
//           : _buildCarouselSlider(),

           SizedBox(height: mediaQuery.size.height * 0.02),
          _buildAnimatedCategoryList(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mediaQuery.size.height * 0.02),
                Text(
                  'Manpowers',
                  style: SafeGoogleFont(
                    'Montserrat',
                    fontSize: mediaQuery.size.width * 0.06,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.02),
                SizedBox(
                  height: mediaQuery.size.height * 0.17,
                  child: FutureBuilder<List<Manpower>>(
                    future: allManpower.fetchManpowerData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('ara');
                        List<Manpower>? manpowerList = snapshot.data;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length > 2
                              ? 2
                              : snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: SizedBox(
                                height: mediaQuery.size.height * 0.15,
                                width: mediaQuery.size.width * 0.90,
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 100, 0),
                                              height:
                                                  mediaQuery.size.height * 0.03,
                                              width:
                                                  mediaQuery.size.width * 0.35,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.yellow,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  50),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  50))),
                                              child: Center(
                                                child: Text(
                                                  "${manpowerList?[index].category ?? 'Unknown'}",
                                                  style: SafeGoogleFont(
                                                    'Montserrat',
                                                    fontWeight:FontWeight.bold,
                                                    fontSize: mediaQuery.size.width * 0.03,
                                                    color:
                                                        const Color(0xff222222),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.015,
                                                  ),
                                                  Text(
                                                    'Name : ${manpowerList?[index].name}',
                                                    style: SafeGoogleFont(
                                                      'Montserrat',
                                                      fontSize: mediaQuery
                                                              .size.width *
                                                          0.035,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.2175,
                                                      color: const Color(
                                                          0xff222222),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.01,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            size: 16,
                                                          ),
                                                          SizedBox(
                                                            width: mediaQuery
                                                                    .size
                                                                    .width *
                                                                0.01,
                                                          ),
                                                          Text(
                                                            "${manpowerList?[index].currentLocation}" 
                                                                ,
                                                            maxLines:
                                                                2, // Allow up to 2 lines of text
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.01,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .currency_rupee,
                                                            size: 15,
                                                          ),
                                                          Text(
                                                              "${manpowerList?[index].minSalary}-${manpowerList?[index].maxSalary}" 
                                                                  ),
                                                        ],
                                                      ),
                                                     
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        mediaQuery.size.height *
                                                            0.01,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildAnimatedCategoryList() {
    var mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Categories',
              style: SafeGoogleFont(
                'Montserrat',
                fontSize: mediaQuery.size.width * 0.06,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              width: mediaQuery.size.width * 0.42,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CategoryList()));
                },
                child: Text(
                  'View All',
                  style: SafeGoogleFont(
                    'Montserrat',
                    fontSize: mediaQuery.size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ))
          ],
        ),
        SizedBox(height: mediaQuery.size.height * 0.02),
        SizedBox(
          height: mediaQuery.size.height * 0.30,
          width: mediaQuery.size.width * 0.90,
          child: FutureBuilder(
            future: CategoryService.fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return SingleChildScrollView(
  child: GridView.builder(
    physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
    shrinkWrap: true, // Make GridView wrap its content
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // Number of columns in the grid
      crossAxisSpacing: mediaQuery.size.width * 0.05, // Spacing between columns
      mainAxisSpacing: mediaQuery.size.width * 0.06, // Spacing between rows
    ),
    itemCount: CategoryService.categories.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InstantHirePage(
                category1: CategoryService.categories[index].name,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: mediaQuery.size.width * 0.09,
              child: Image.network(
                CategoryService.categories[index].image,
                scale: mediaQuery.size.width * 0.017,
              ),
            ),
            // SizedBox(height:mediaQuery.size.height*0.05),
            Text(
              CategoryService.categories[index].name,
              style: SafeGoogleFont(
                'Montserrat',
                fontSize: mediaQuery.size.width * 0.03,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      );
    },
  ),
);

              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permission are denied.');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              "Please allow Location permission",
              style: TextStyle(color: Colors.white),
            )));
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
          Placemark placemark = placeMarks[0];
          setState(() {
            locationName =
                '${placemark.subLocality ?? 'Unknown'}, ${placemark.locality ?? 'Unknown'}';
            latitude = position.latitude;
            longitude = position.longitude;
          });

          // Send the location data to the backend
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
      latitude, longitude, locationName) async {
    print(GlobalConstant.firebaseToken);
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/update/EmployerLocation/" +
            GlobalConstant.userID);

    await http
        .put(requestUri,
            body: jsonEncode({
              'current_location': locationName,
              'current_lati': latitude,
              'current_longi': longitude,
            }),
            headers: {
              'Content-Type': 'application/json',
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
    print(GlobalConstant.firebaseToken);
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/update/EmployerToken/" +
            GlobalConstant.userID);

    await http
        .put(requestUri, body: jsonEncode({"newToken": token}), headers: {
          'Content-Type': 'application/json',
        })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          if (response.statusCode == 200 || response.statusCode == 201) {
            var jsonResponse = jsonDecode(response.body);
            print('321111${jsonResponse}');
          } else if (response.statusCode == 400) {
            print('tyt1: ${response}');
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            print('tyt2: ${response}');
          } else if (response.statusCode == 500) {
            print('tyt: ${response}');
          }
        })
        .catchError((error) {
          print(error);
        });
  }
   Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://workwave-backend.vercel.app/api/v1/banner/show'));
    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  int _currentIndex = 0;
  Widget _buildCarouselSlider() {
  return Stack(
    children: [
      CarouselSlider(
        items: _data.map<Widget>((item) {
          return Image.network(
            item['image'],
            fit: BoxFit.cover,
          );
        }).toList(),
        options: CarouselOptions(
          
          aspectRatio: 16 / 4,
          autoPlay: true,
          enlargeCenterPage: true,
          enableInfiniteScroll: false, // Disabling infinite scroll if there are only 1 or 2 items
          onPageChanged: (index, _) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      Positioned(
        bottom: 0.0,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _data.map((url) {
            int index = _data.indexOf(url);
            return AnimatedContainer(
              duration: Duration(milliseconds: 150),
              width: _currentIndex == index ? 10.0 : 8.0,
              height: _currentIndex == index ? 10.0 : 8.0,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.black : Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

}
