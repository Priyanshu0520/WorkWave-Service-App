// ignore_for_file: use_build_context_synchronously, must_be_immutable, deprecated_member_use, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wayforce/New%20screens/bottomnav%20bars/manp_bottom_navbar_provider.dart';
import 'package:wayforce/new%20utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayforce/new_services/global_constants.dart';
import '../../new utils/const.dart';
import 'manpower_description_screen.dart';
import 'manpower_timer_page.dart';

class ManpowerTrack extends StatefulWidget {
  var employerid;
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
  ManpowerTrack(
      {this.employerid,
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
  State<ManpowerTrack> createState() => ManpowerTrackState();
}

class ManpowerTrackState extends State<ManpowerTrack> {
  int currentPageIndex = 0;

  void ontogglechange(int? index) {
    setState(() {
      currentPageIndex = index!;
    });
  }

  double _distance = 0.0;
  OtpFieldController otpController = OtpFieldController();

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
  Timer? _timer;
  double empLat = 0;
  double empLong = 0;
  String locationName = '';
  String empId = '';
  String otp = '';
  String orderId = '';
  var orderData;
  bool _dispose = false;
  bool isLoading = true;
  bool isExpand = false;
  String fillOtp = '';

  String profileUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOjXY44xj2kDrEwinLBEsObi_d-A57IoxIS8eWI3UfYK4WK8oapJJiVTcb8eM5cLJc-r8&usqp=CAU';
  String workingTime = '';
  DateTime ?endtimee;
  Future<void> _sendLocationToBackend(latitude, longitude, locationName) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String id = prefs.getString("manpoweraccesstoken") ?? "";
      // print(id);

      final apiUrl =
          'https://workwave-backend.vercel.app/api/v1/manpower/updateManpowerLocation/${GlobalConstant.userID}';

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'siteLocation': locationName,
          'lati': latitude,
          'longi': longitude,
        }),
      );
      if (response.statusCode == 200) {
        print('manpower current location  sent to backend successfully');
      } else {
        print(
            'Failed to sendmanpower current location to backend 22. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sendingmanpower current locationn to backend: $error');
    }
  }

  _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission per = await Geolocator.requestPermission();
      if (per == LocationPermission.denied ||
          per == LocationPermission.deniedForever) {
        openAppSettings();
      } else {
        _getLocation();
      }
    } else {
      _getLocation();
    }
  }

  _getLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;
      print('CURRENT POS: $_currentPosition');
      _initialLocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18.0,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          locationName =
              '${placemark.subLocality ?? 'Unknown'}, ${placemark.locality ?? 'Unknown'}';
        });
      }

      await _sendLocationToBackend(
          position.latitude, position.longitude, locationName);
    }).catchError((e) {
      print('error: $e');
      Navigator.pop(context);
    });
    // Timer(const Duration(seconds: 5), () {
    _calculateDistance();
    // });
  }

  Marker? tappedMarker;
  late String destinationCoordinatesString;
  double destinationLatitude = 0.0;
  double destinationLongitude = 0.0;
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
      double startLatitude = _currentPosition.latitude;
      double startLongitude = _currentPosition.longitude;

      print("LOCATIOOOOON");

      double destinationLatitude = empLat;
      double destinationLongitude = empLong;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesStringg =
          '($destinationLatitude, $destinationLongitude)';
      setState(() {
        destinationCoordinatesString = destinationCoordinatesStringg;
        destinationLatitude = destinationLatitude;
        destinationLongitude = destinationLongitude;
      });
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          // snippet: 'Your location',
        ),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(7, 7)),
            'assets/images/man.png'),
      );
      
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: const InfoWindow(
          title: 'Job Location ',
          //   snippet: 'Your Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      tappedMarker = destinationMarker;
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );
      double distance = await Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        destinationLatitude,
        destinationLongitude,
      );
      double distanceInKm = distance / 1000;

      print('DISTANCE: $distanceInKm kilometers');
      setState(() {
        _distance = distanceInKm;
      });

      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);
      if (_timer == null) {
        return false;
      }
      setState(() {
        isLoading = false;
      });
      return true;
    } catch (e) {
      print('erroe: $e');
    }
    return false;
  }

  void _openMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // Google Maps API Key
      'AIzaSyDPqZ0_gzMHgTKMc9l6F_VKZOpaX4eytkE',
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
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
    if (mapController != null) {
      LatLngBounds bounds = calculateBounds();
      mapController!.moveCamera(CameraUpdate.newLatLngBounds(
        bounds,
        100.0, // padding
      ));
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

  @override
  void initState() {
    super.initState();
    isBusy = true;
    getData();
    getdataofemployer();
    _getOrderDetailsStatus();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SPkey.orderOnGoing, "true");
    empId = prefs.getString(SPkey.orderEmpId) ?? '';

    orderId = prefs.getString(orderId) ?? "";
    if (!manStartWork.value) {
      ismanMapPage = true;
      _getOrderDetails();
      _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (manStartWork.value) {
          if (_timer != null) {
            _timer!.cancel();
          }
        } else {
          _getCurrentLocation();
        }
      });
    } else {
      ismanOtpPage = true;
      ismanMapPage = false;
      // if (_timer != null) {
      //   _timer!.cancel();
      // }
      
    }
  }

  Future<void> _getOrderDetails() async {
  try {
    var id = widget.orderid;
    var response = await http.get(Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$id"));
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = json['data'];
      if (data != null && data is Map<String, dynamic>) {
        String orderSts = data['orderStatus'] ?? '';

        setState(() {
          orderData = data;
          print('orderData:::${widget.orderid}?? $orderId');
        });

        if (orderSts.toLowerCase().contains('cancel')) {
          // ... (rest of the cancellation logic)
        } else {
         empLat = data['lati'] ?? 0;
empLong = data['longi'] ?? 0;
workingTime = data['workingHours'].toString() ;
int workingTimeInHours = int.parse(workingTime);
int workingTimeInSeconds = workingTimeInHours * 3600;
// Format the working time and update the state

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(SPkey.orderWorkingTime, workingTime.toString());

          if (!_dispose) {
            _getCurrentLocation();
          }
        }
      }
      //getdataofemployer();
    }
  } catch (e) {
    print(e.toString());
  }
}
var employerdata;
  Future<void> getdataofemployer() async {
    try {
      // String id = manPoerId;
      var id = widget.employerid;
      final apiUrl = 'https://workwave-backend.vercel.app/api/v1/employer/$id';
      print(apiUrl);
      print('7');
      final response = await http.get(Uri.parse(apiUrl));

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('8');
        // Token sent to backend successfully
        if (json['data'] != null) {
          print('9');
          // manLat = json['data']['serviceLocation']['lati'];
          // manLong = json['data']['serviceLocation']['longi'];
          employerdata = json['data'];
          // print(manLat);
          // print(manLong);
          if (_dispose) {
            print('10');
            return;
          } else {
            print('11');
            setState(() {
              isLoading = false;
            });
          }
         // _calculateDistance();
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
DateTime formatHours(int totalSeconds) {
  // Create a DateTime object from the total seconds
  DateTime dateTime = DateTime(0, 1, 1).add(Duration(seconds: totalSeconds));

  // Return the formatted DateTime object
  setState(() {
    endtimee=dateTime;
  });
  return dateTime;
}


  Future<bool> _getOrderDetailsStatus() async {
    bool sts = false;

    var id = widget.orderid;
    var url =
        'https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$id';
    print('uuu22 :::$url');
    try {
      var response = await http.get(Uri.parse(url));
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var data = json['data'];
        if (data != null && data is Map<String, dynamic>) {
          orderData = data;
          String orderSts = orderData['orderStatus'] ?? '';
          if (orderSts.toLowerCase().contains('Cancel')) {
            clearAllFunction();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove(SPkey.orderOnGoing);
            prefs.remove(SPkey.orderEmpId);
            prefs.remove(SPkey.orderId);
            prefs.remove(SPkey.orderOTP);
            prefs.remove(SPkey.orderWorkingTime);
            manStartWork.value = false;
            manExtantTime.value = false;
            isBusy = false;
            _timer!.cancel();
            Get.defaultDialog(
              barrierDismissible: false,
              title: 'Cancel Request',
              middleText: 'Request Cancel By Employer',
              titleStyle: const TextStyle(color: Colors.black87, fontSize: 24),
              middleTextStyle: const TextStyle(color: Colors.black),
              textConfirm: "Okay",
              onConfirm: () {
                Get.back();
                if (ismanMapPage || ismanOtpPage) {
                  ismanMapPage = false;
                  ismanOtpPage = false;
                  Get.offAll(() =>  ManNavTab());
                }
              },
              confirmTextColor: Colors.white,
              radius: 30,
            );
          } else {
            empLat = orderData['lati'] ?? 0;
            empLong = orderData['longi'] ?? 0;
            String workStartTime = orderData['startTime'] ?? '0';
            workingTime = data['workingHours'].toString();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(SPkey.orderWorkingTime, workingTime.toString());
            if (_dispose) {
              return sts;
            } else {
              sts = true;
              setState(() {
                isLoading = false;
              });
            }
          }
        }
      }
    } catch (e) {
      print(" {e.toString()}");
    }
    return sts;
  }

  //for Timer Page Function

  @override
  void dispose() {
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
   
    var mediaQuery = MediaQuery.of(context);
    var dis = _distance.toStringAsFixed(2);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Text(
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Stack(
                    children: [
                      // if (ismanMapPage)
                        SizedBox(
                          width:  MediaQuery.of(context).size.width,
                         height: MediaQuery.of(context).size.height * 0.7,
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
                              : mediaQuery.size.height * 0.35,
                          decoration: BoxDecoration(
                              color: AppColors.lightgrey,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35))),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Center(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey.shade200,
                                          ),
                                          child: Text(
                                            'Distance: ${dis} km',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight
                                                  .bold, // Change the text color as needed
                                              fontSize:
                                                  mediaQuery.size.width * 0.035,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: mediaQuery.size.width * 0.03),
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
                                              ?  Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  size: mediaQuery.size.width *
                                                    0.09,
                                                  color: Colors.blueGrey,
                                                )
                                              :  Icon(
                                                  Icons.keyboard_arrow_up_rounded,
                                                size: mediaQuery.size.width *
                                                    0.09,
                                                  color: Colors.blueGrey)),
                                      SizedBox(
                                          width: mediaQuery.size.width * 0.07),
                                      GestureDetector(
                                        onTap: () {
                                          _openMaps(empLat, empLong);
                                        },
                                        child: Container(
                                          height: mediaQuery.size.height * 0.043,
                                          width: mediaQuery.size.width * 0.28,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: AppColors.black),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    mediaQuery.size.width * 0.03,
                                                right:
                                                    mediaQuery.size.width * 0.03,
                                                top:
                                                    mediaQuery.size.height * 0.01,
                                                bottom: mediaQuery.size.height *
                                                    0.01),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Get Direction ',
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        mediaQuery.size.width *
                                                            0.025,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.directions,
                                                  size: mediaQuery.size.width *
                                                      0.05,
                                                  color: AppColors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: mediaQuery.size.width * 0.5),
                                Center(
                                  child: CircleAvatar(
                                    radius: mediaQuery.size.width * 0.08,
                                    backgroundImage: NetworkImage(employerdata?['profileImage'] ?? profileUrl),
                                  ),
                                ),
                                 SizedBox(
                                  height: mediaQuery.size.height*0.01,
                                ),
                                Center(
                                  child: Text(
                                      employerdata?['name'] ?? '',
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: mediaQuery.size.width * 0.04,
                                    ),
                                  ),
                                ),
                                  SizedBox(
                                  height: mediaQuery.size.height*0.02,
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
                                          borderRadius: BorderRadius.circular(
                                              mediaQuery.size.width * 0.03),
                                        ),
                                        minimumSize: const Size(100, 35),
                                      ),
                                      onPressed: () async {
                                        String contactNo =
                                            employerdata?['mobile'] ?? '';
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
                                          borderRadius: BorderRadius.circular(
                                              mediaQuery.size.width * 0.03),
                                        ),
                                        minimumSize: const Size(
                                            110, 35), // set the button size
                                      ),
                                      onPressed: () { },
                                      icon: const Icon(Icons.chat,
                                          color: Colors.white), // add icon here
                                      label: const Text(
                                        'Chat',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                   
                                         bottomSheets(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    minimumSize: const Size(
                                        100, 35), 
                                  ),
                                  child: Text(
                               
                                         'Start Your Work',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
                                isExpand
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: mediaQuery.size.width * 0.01,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              mediaQuery.size.width * 0.03),
                                        ),
                                        child: ToggleSwitch(
                                          minWidth: mediaQuery.size.width * 0.450,
                                          minHeight:
                                              mediaQuery.size.height * 0.03,
                                          cornerRadius:
                                              mediaQuery.size.width * 0.01,
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
                                          labels: const [
                                            'Description',
                                            // 'Work Infor!'
                                          ],
                                          radiusStyle: true,
                                          onToggle: ontogglechange,
                                        ),
                                      )
                                    : SizedBox(
                                        height: mediaQuery.size.height * 0.00,
                                      ),
                                isExpand
                                    ? Column(
                                        children: [
                                          if (currentPageIndex == 0)
                                            ManDiscriptionScreen(
                                               orederemployerid: widget.employerid,
                                              orderid: widget.orderid,
                                              orderlocation: orderData['siteLocation'],
                                               orderprice: orderData['bookedPayment'],
                                              orderworkdetail:
                                                 orderData['explainYourWork'],
                                              orderworkinghrs:
                                                 orderData['workingHours'],
                                            )
                                        ],
                                      )
                                    : SizedBox(
                                        width: mediaQuery.size.width * 0.03),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    height: mediaQuery.size.height * 0.30,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Fetching.....',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: mediaQuery.size.width * 0.03),
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
  Future<void> startWork(BuildContext ctx) async {
    if (_dispose) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      var headers = {'Content-Type': 'application/json'};

      DateTime now = DateTime.now();
      //workStartTime = DateFormat('HH:mm:ss').format(now);
      var workStartDateTime = DateFormat('HH:mm:ss').format(now);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(SPkey.orderStartDateTime, workStartDateTime);
      print('working time  :${workingTime}');
       print('endtime time  :${workStartDateTime}');
      final data =  jsonEncode({
        "startTime": workStartDateTime,
        "endTime": workingTime,
        "orderStatus": "Ongoing"
      });

      var endpoint = widget.orderid;
      var url = Uri.parse(
          "https://workwave-backend.vercel.app/api/v1/employer/upadtePost/ByStatusOfCompletion/$endpoint");
      print('url${url}');
      var response = await http.put(url, body: data, headers: headers);
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('starting');
        if (_dispose) {
          return;
        }
        sendMsgToEmp(ctx);
      } else {
        print('resss${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(json["errors"][0]["msg"].toString(),
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ));
      }
    } catch (e) {
      if (_dispose) {
        setState(() {
          isLoading = false;
        });
      }

      print('123 ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "An error occurredd: ${e.toString()}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ));
    }
  }
  void bottomSheets(BuildContext context) {
  
    var mediaQuery = MediaQuery.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: mediaQuery.size.height * 0.12),
              Text(
                'Enter OTP here',
                style: TextStyle(
                    fontSize: mediaQuery.size.width * 0.03,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.black),
                ),
                child: OTPTextField(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 20,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceEvenly,
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {
                    fillOtp = pin;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.black,
                  backgroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(10, 45), // set the button size
                ),
                onPressed: () async{
                  print('otp${widget.orderotp}');
                  if (fillOtp == widget.orderotp) {
                  print('otp filled ${widget.orderotp}');
                    //sendMsgToEmp(context);
                    await  startWork(context);
                    Navigator.of(context).pop();
                    print(' idd aayi hhh${widget.orderid}');
                     Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               ManpowerTimerPage( 
                                                employerid: widget.employerid,
                                                orderid: widget.orderid,
                                               )));
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "Invalid OTP",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ));
                  }
                },
                child: const Text(
                  'Submit OTP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          SizedBox(
            height: mediaQuery.size.height * 0.02,
          ),
            ],
          ),
        ),
      ),
    );
  }
  Future sendMsgToEmp(BuildContext ctx) async {
    try {
     

      final data = jsonEncode({
        "body": "Manpower Strting Your Work",
        "title": "Work Start",
        "senderId": GlobalConstant.userID,
        "receiverId": widget.employerid,
        "category": "",
        "siteLocation": "",
        "explainYourWork": "",
        "date": ""
      });

      var headers = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          "https://workwave-backend.vercel.app/api/v1/employer/findParticularManpowerOrEmployer");

      var response = await http.post(url, body: data, headers: headers);
      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('sent not to strt');
        var arg = {"empId": empId, "workingTime": workingTime};
        setState(() {
          manStartWork.value = true;
          isLoading = false;
        });
        getData();
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "An error occurred to start work",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "An error occurre: ${e.toString()}",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ));
    }
  }

}
////////////////////////////////////////////////////////////////////////////////////////////