
// ignore_for_file: unused_local_variable, override_on_non_overriding_member, unused_field, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:wayforce/new%20utils/const.dart';
import 'package:wayforce/new%20utils/colors.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'emp_description_screen.dart';
import 'emp_timer_page.dart';

class EmployeTrack extends StatefulWidget {
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
  EmployeTrack(
      {
      required this.manpowerid,
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
      super.key});

  @override
  State<EmployeTrack> createState() => EmployeTrackState();
}

class EmployeTrackState extends State<EmployeTrack> {
  bool isExpand = false;
  int currentPageIndex = 0;

  void ontogglechange(int? index) {
    setState(() {
      currentPageIndex = index!;
    });
  }
  late Timer _timer;
  String profileUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU';

  @override
  void initState() {
    print(widget.orderid);
   
    super.initState();
    getData();
   _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Fetch data from the API
      fetchDataFromAPI();
     });
    print('16');
  }
  bool isApiCallActive = true;
   Future<void> fetchDataFromAPI() async {
    var id = widget.orderid; // Make sure to have access to the orderid
      while (isApiCallActive){final response = await http.get(Uri.parse(
        'https://workwave-backend.vercel.app/api/v1/employer/getStartEmdTimeByOrderId/$id'));

    if (response.statusCode == 200) {
      // print("i am rumming");
      // Parse the response body
      Map<String, dynamic> apiResponse = json.decode(response.body);
      // Extract the start time from the API response
      String? startTimeString = apiResponse['startTime'];
      // Navigate to the timer page passing the start time
   if (startTimeString != null && startTimeString.isNotEmpty) {
      // Start time is not empty, navigate to the timer page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EmpTimerPage(
            orderprice: widget.orderprice,
            orderworkdetail: widget.orderworkdetail,
            orderworkinghrs: widget.orderworkinghrs,
            orderlocation: widget.orderlocation ,
            orderotp: widget.orderotp,
            ordercategory: widget.ordercategory,
            manpowerid: widget.manpowerid,
            orderid: widget.orderid,
            orderlat: widget.orderlat,
            orderlongi: widget.orderlongi,
          ),
        ),
      );
        setState(() {
          isApiCallActive = false;
        });
    }
   
    } else {
      throw Exception('Failed to load data from API');
    }
     await Future.delayed(Duration(seconds: 2));
  }}

  var passordid;
  String? instantcategory = '';
  CameraPosition _initialLocation =
  const CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController? mapController;
  final startAddressController = TextEditingController();
  final startAddressControllerForLocation = TextEditingController();
  late Position _currentPosition;
  final destinationAddressController = TextEditingController();
  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  bool enabledtext = true;
  Set<Marker> markers = {};
  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  var manPowerdata;
  double manLat = 0;
  double manLong = 0;
  bool _dispose = false;
  double _distance = 0.0;
  bool isLoading = true;
  double empLat = 0;
  double empLong = 0;
  bool isBusy = false;
  bool ismanMapPage = false;
  bool ismanOtpPage = false;
  bool isEmpDedectPage = false;
  bool isEmpMapPage = false;
  bool isEmpOtpPage = false;

  Future<bool> _getOrderDetailsStatus() async {
    bool sts = false;
    var id = widget.orderid;
    try {
      var response = await http.get(Uri.parse(
          "https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$id"));
      var json = jsonDecode(response.body);

      setState(() {
        passordid = widget.orderid;
        print('pasoid : ${passordid}');
      });
      if (response.statusCode == 200) {
        if ((json['data'] as Map).isNotEmpty) {
          var orderData = json['data'];
          print('order status: ${orderData['orderStatus']}');

          String orderSts = orderData['orderStatus'] ?? '';
          if (orderSts.toLowerCase().contains('cancel')) {
            //     clearAllFunction();
            print('Order canceled');
          } else {
            var lat = orderData['lati'] ?? 0;
            var long = orderData['longi'] ?? 0;

            setState(() {
              empLat = lat;
              empLong = long;
            });

            print('Working time: ${orderData['workingHours']}');

            if (_dispose) {
              return sts;
            } else {
              sts = true;
              print('Tasks performed successfully');
            }
          }
        }
      }
    } catch (e) {
      print(" {e.toString()}");
    }
    return sts;
  }

  Future getData() async {
    await _getOrderDetailsStatus();

    print('19');
    if (!manStartWork.value) {
      print('20');
      isEmpMapPage = true;
  _getOrderDetails();
      _getCurrentLocation();
 
    } else {
      print('24');

     //

      print('done not');
    }
  }

  var orderData;
  String workingTime = '0';
  String bookedPayment='0';
  int _seconds = 0;
  int totalWorkTimmingInSecond = 0;
  Timer? _timer1;
  bool timeOver = false;
  Future _getOrderDetails() async {
    try {
      var id = widget.orderid;
      print('30');
      var orderId;
          var url ="https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$id";
                  print('url ::::${url}');
      var response = await http.get(Uri.parse(url
          ));
  
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var lat = widget.orderlat;
        var long = widget.orderlongi;
         setState(() {
              empLat = lat;
              empLong = long;
              workingTime = orderData['workingHours'] ?? '';
        bookedPayment = orderData['bookedPayment'] ?? '';
        print('working hrs:${workingTime}');
         print('working hrs:${bookedPayment}');
            });
        // setState(() {
        //   empLat = lat;
        //   empLong = long;
        // });
        print('${lat}');
        print('${long}');
        if ((json['data'] as List).isNotEmpty) {

         
          if (_dispose) {
            return;
          } else {
            print('32');
            orderData = json['data'];
            var lat = orderData['lati'] ?? 0;
            var long = orderData['longi'] ?? 0;
            
          
            
            totalWorkTimmingInSecond = int.parse(workingTime) * 3600;
             String workStartTime = orderData['startTime'] ?? '0';

          }
        }
      }
    } catch (e) {
      print('33');
      print(e.toString());
    }

    getdataofmanpower();
  }

  
  @override
  _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission per = await Geolocator.requestPermission();
      if (per == LocationPermission.denied ||
          per == LocationPermission.deniedForever) {
        //openAppSettings();
        print('1');
      } else {
        print('2');
        _getLocation();
      }
    } else {
      _getLocation();
      print('3');
    }
  }

  _getLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;
      print('4');
      print('CURRENT POS: $_currentPosition');
      _initialLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18.0,
      );
    }).catchError((e) {
      print('5');
      print(e);
      Navigator.pop(context);
    });
    // Timer(const Duration(seconds: 5), () {
    getdataofmanpower();
    print('6');
    // });
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
          manLat = json['data']['serviceLocation']['lati'];
          manLong = json['data']['serviceLocation']['longi'];
          manPowerdata = json['data'];
         // _getDirections();
          print(manLat);
          print(manLong);
          if (_dispose) {
            print('10');
            return;
          } else {
            print('11');
            setState(() {
              isLoading = false;
            });
          }
         _calculateDistance();
          
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

  LatLngBounds calculateBounds() {
    double minLat = double.infinity;
    double minLng = double.infinity;
    double maxLat = double.negativeInfinity;
    double maxLng = double.negativeInfinity;

    for (LatLng point in polylineCoordinates) {
      minLat = min(minLat, point.latitude);
      minLng = min(minLng, point.longitude);
      maxLat = max(maxLat, point.latitude);
      maxLng = max(maxLng, point.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
   var _duration;
  Future<void> _getDirections() async {
    // Replace 'YOUR_API_KEY' with your actual Google Maps API key
    final apiKey = 'AIzaSyDPqZ0_gzMHgTKMc9l6F_VKZOpaX4eytkE';
    final origin = '$manLat,$manLong';
  final destination = '$empLat,$empLong';
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&departure_time=now&key=$apiKey'));
  print('nhiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    if (response.statusCode == 200) {
      print('dattttttttttttttttttttttttt');
      final decoded = json.decode(response.body);
      final routes = decoded['routes'];
      if (routes.isNotEmpty) {
        final route = routes[0];
        final overviewPolyline = route['overview_polyline']['points'];
        final legs = route['legs'];
        final distance = legs[0]['distance']['text'];
        final duration = legs[0]['duration']['text'];

        setState(() {
          _distance = distance;
           _duration = duration;
        
        });
      }
    }
  }


  Future<bool> _calculateDistance() async {
    if (markers.isNotEmpty) {
      markers.clear();
    }
    if (polylines.isNotEmpty) {
      polylines.clear();
    }
    if (polylineCoordinates.isNotEmpty) {
      polylineCoordinates.clear();
    }
    try {
      var empLatitude = widget.orderlat;
      print('emplat ${empLong}');
      var empLongitude = widget.orderlongi;

      double startLatitude = manLat;
      double startLongitude = manLong;

      print("LOCATIOOOOON");

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString = '($empLat, $empLong)';

      Marker destinationMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: 'ManPower Location',
        ),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(5, 5)),
            'assets/images/man.png'),
      );

      Marker startMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(empLat, empLong),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: 'Your Location',
        ),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(1, 1)),
            'assets/images/location.png'),
      );

      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($empLat, $empLong)',
      );
      double distance = await Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        empLat,
        empLong,
      );
      double distanceInKm = distance / 1000;

      print('DISTANCE: $distanceInKm kilometers');
      setState(() {
        _distance = distanceInKm;
      });
      double miny = (startLatitude <= empLat) ? startLatitude : empLat;
      double minx = (startLongitude <= empLong) ? startLongitude : empLong;
      double maxy = (startLatitude <= empLat) ? empLat : startLatitude;
      double maxx = (startLongitude <= empLong) ? empLong : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // if (timer == null || _dispose) {
      //   return false;
      // }

      Timer(const Duration(seconds: 1), () {
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        );
      });

      await _createPolylines(startLatitude, startLongitude, empLat, empLong);
      // if (timer == null) {
      //   return false;
      // }
      setState(() {
        isLoading = false;
      });
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future _createPolylines(
    double startLatitude,
    double startLongitude,
    double empLat,
    double empLong,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDPqZ0_gzMHgTKMc9l6F_VKZOpaX4eytkE', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(empLat, empLong),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    PolylineId id = const PolylineId('poly');

    Polyline polyline = Polyline(
      jointType: JointType.round,
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    Marker startMarker = Marker(
      markerId: MarkerId('Manpower Location'),
      position: LatLng(startLatitude, startLongitude),
      infoWindow: InfoWindow(
        title: 'Manpower Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('Job Location'),
      position: LatLng(empLat, empLong),
      infoWindow: InfoWindow(
        title: 'Job Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markers.add(startMarker);
    markers.add(destinationMarker);
    LatLngBounds bounds = calculateBounds();
    if (mapController != null) {
      mapController!.moveCamera(CameraUpdate.newLatLngBounds(
        bounds,
        100.0, // padding
      ));
    }
  }
  

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var _dis = _distance.toStringAsFixed(2);
    print('jai hoo ${manPowerdata?['experience']}');
    print('iddd :  ${widget.orderid}');
    print(widget.manpowerid);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Your Booking',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: mediaQuery.size.width * 0.05,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.200000003,
              color: Color(0xff272729),
            ),
          ),
        ),
        body: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                   // if (isEmpMapPage)
                      SizedBox(
                        width:  MediaQuery.of(context).size.width ,
                        height: mediaQuery.size.height*0.6,
                        child: GoogleMap(
                          markers: Set<Marker>.from(markers),
                          initialCameraPosition: _initialLocation,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          mapType: MapType.terrain,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          polylines: Set<Polyline>.of(polylines.values),
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                        ),
                      ),
                 
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: isExpand
                            ? mediaQuery.size.height * 0.8
                            : mediaQuery.size.height * 0.3,
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
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.shade200,
                                        ),
                                        child: Text(
                                          'Distance: ${ _dis} km',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                mediaQuery.size.width * 0.03,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: mediaQuery.size.width * 0.08),
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
                                  backgroundImage: NetworkImage(manPowerdata?['profileImage'] ?? profileUrl),
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
                                        labels:  [
                                          'Description',
                                        ],
                                        radiusStyle: true,
                                        onToggle: ontogglechange,
                                      ),
                                    )
                                  :  SizedBox(
                                     height:  mediaQuery.size.height * 0.00,
                                    ),
                              isExpand
                ? EmpDiscriptionScreen(
   
                                          
                                          manpowername: manPowerdata?['name'] ?? '',
                                            orderid: widget.orderid,
                                            manpowerid: widget.manpowerid,
                                            orderlocation: widget.orderlocation,
                                            orderprice: widget.orderprice,
                                            orderworkdetail:
                                                widget.orderworkdetail,
                                            orderworkinghrs:
                                               widget.orderworkinghrs,
                                            manworkexp:
                                                manPowerdata?['experience'] ??
                                                    '',
                                                    will: 0,
                                                  rating:manPowerdata?['averageRating'] ?? '' ,
                                          
                  )
                : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            Stack(
              children: [
                const Opacity(
                  opacity: 0.7,
                  child: ModalBarrier(dismissible: false, color: Colors.grey),
                ),
                Center(
                  child: Container(
                    height: 40,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Fetching.....',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
        ]));
  }
}
