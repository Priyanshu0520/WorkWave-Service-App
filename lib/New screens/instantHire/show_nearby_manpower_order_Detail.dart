

import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:wayforce/new%20utils/utils.dart';

import '../../new utils/colors.dart';
import '../../new utils/utils.dart';
import '../../new_services/global_constants.dart';
import '../alerts/new_loader.dart';
import 'waiting_manpower_acceptpage.dart';
import 'package:http/http.dart' as http;

class ManpowerNearBy extends StatefulWidget {
  
  String? sitelocation;
  String ?price;
  int? duration;
  String? category;
String ?lat ;
  String ?long;
  ManpowerNearBy(
      {this.lat, this.long,  this.sitelocation, this.category, this.price, this.duration, super.key});
  @override
  _ManpowerNearByState createState() => _ManpowerNearByState();
}

class _ManpowerNearByState extends State<ManpowerNearBy> {
var slat;
var slog;
  late GoogleMapController mapController;


 late LatLng sourceLocation;
late List<dynamic> manpowerList;
  late List<LatLng> destinationCoordinates;
  late List<Marker> destinationMarkers;
  late Set<Polyline> polylines;

  @override
   @override
  void initState() {
    super.initState();
    sourceLocation =  LatLng(double.parse(widget.lat??" "), double.parse(widget.long??""));
      

    destinationCoordinates = [];
    polylines = {};
    getOrderID();
  }
  var orderid;
  
  Future<void> _fetchManpowerData() async {
    try {
      var requestBody = {
        "employerId": GlobalConstant.userID,
        "orderId": orderid,
        "latitude": GlobalConstant.instantHireLat,
        "longitude": GlobalConstant.instantHireLong,
        "radiusInKm": 10,
        "category": GlobalConstant.instantHireCategory,
        "body": "",
        "isNotification": "No"
      };

      var response = await http.post(
        Uri.parse('https://workwave-backend.vercel.app/api/v1/employer/findManpower'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          manpowerList = data['manpower'];
          _generateDestinationCoordinates();
        });
      } else {
        throw Exception('Failed to fetch manpower data');
      }
    } catch (error) {
      print('Error fetching manpower data: $error');
    }
  }

  void _generateDestinationCoordinates() {
    destinationCoordinates = manpowerList.map((manpower) {
      var latiString = manpower['serviceLocation']['lati'].toString();
      var longiString = manpower['serviceLocation']['longi'].toString();
      var lati = double.tryParse(latiString) ?? 0.0;
      var longi = double.tryParse(longiString) ?? 0.0;
      return LatLng(lati, longi);
    }).toList();
    _createPolylines();
  }

  Future<void> _createPolylines() async {
    Set<Polyline> newPolylines = {};

    for (var destination in destinationCoordinates) {
      var points = await _getPolylinePoints(sourceLocation, destination);
      newPolylines.add(Polyline(
        polylineId: PolylineId(destination.toString()),
        color: Colors.black,
        points: points,
        width: 4,
      ));
    }

    setState(() {
      polylines = newPolylines;
    });
  }

  Future<List<LatLng>> _getPolylinePoints(
      LatLng source, LatLng destination) async {
    List<LatLng> polylinePoints = [];

    String apiUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyDPqZ0_gzMHgTKMc9l6F_VKZOpaX4eytkE";
    

    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> routes = data["routes"];
      routes.forEach((route) {
        List<dynamic> legs = route["legs"];
        legs.forEach((leg) {
          List<dynamic> steps = leg["steps"];
          steps.forEach((step) {
            var polyline = step["polyline"]["points"];
            List<LatLng> decodedPolyline =
                _decodeEncodedPolyline(polyline);
            polylinePoints.addAll(decodedPolyline);
          });
        });
      });
    }

    return polylinePoints;
  }

  List<LatLng> _decodeEncodedPolyline(String encoded) {
    List<LatLng> decoded = [];
    var index = 0;
    var lat = 0;
    var lng = 0;

    while (index < encoded.length) {
      var b;
      var shift = 0;
      var result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      var dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      var dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      decoded.add(LatLng((lat / 1E5), (lng / 1E5)));
    }

    return decoded;
  }


  @override
  Widget build(BuildContext context) {
    print('lat${widget.lat}');
     print('long${widget.long}');
        var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manpower Near You'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: mediaQuery.size.height*0.60,
              child: GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target: sourceLocation,
                  zoom: 13.0,
                ),
                markers: _createMarkers(),
                polylines: polylines,
                onMapCreated: (controller) {
                  mapController = controller;
                },
              ),
            ),
          ),
          SizedBox(height: mediaQuery.size.height*0.02),
          Text(
            ' ${widget.sitelocation}',
            style: TextStyle(
              fontSize: mediaQuery.size.width*0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
           SizedBox(height: mediaQuery.size.height*0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' ${widget.category} ',
                style: TextStyle(
                  fontSize: mediaQuery.size.width*0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width:mediaQuery.size.width*0.15),
         
           Text(
                      'Rs ${price} ',
                      style: TextStyle(
          fontSize: mediaQuery.size.width*0.04,
          fontWeight: FontWeight.bold,
          color: Colors.black,
                      ),
                    ),
            ],
          ),

          SizedBox(height: mediaQuery.size.height*0.02),
          Text(
            ' ${widget.duration} hrs',
            style: TextStyle(
              fontSize: mediaQuery.size.width*0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: mediaQuery.size.height*0.02),
          ElevatedButton(
            onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                             WaitingManpowerToAccept(

                              sitelocation: widget.sitelocation,
                             )));

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              minimumSize: Size(150, 50),
            ),
            child: Text(
              'Confirm Booking',
              style: TextStyle(
                fontSize: mediaQuery.size.width*0.04,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
var price;
   Future<void> _getOrderDetails() async {
  try {
    var id = orderid;
    var response = await http.get(Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/get/getStatusOfOrderId?orderId=$id"));
    var json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var data = json['data'];
      if (data != null && data is Map<String, dynamic>) {
        String orderSts = data['orderStatus'] ?? '';
setState(() {
  price = data['bookedPayment'] ?? 0;
});
       
      }
      //getdataofemployer();
    }
  } catch (e) {
    print(e.toString());
  }
}
Set<Marker> _createMarkers() {
  Set<Marker> markers = {};

  // Add source marker
  if (widget.lat != null && widget.long != null) {
    double? lat = double.tryParse(widget.lat!);
    double? long = double.tryParse(widget.long!);
    if (lat != null && long != null) {
      markers.add(Marker(
        markerId: MarkerId('sourceMarker'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: 'Source Location'),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
  }

  // Add manpower markers with custom image
  for (var destination in destinationCoordinates) {
    markers.add(Marker(
      markerId: MarkerId(destination.toString()),
      position: destination,
      infoWindow: InfoWindow(title: 'Manpower Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Example: Change marker color to green
    ));
  }

  return markers;
}


Future getOrderID() async {
    // Loader().show(context);
    var map = {
      "siteLocation": widget.sitelocation,
      "category": GlobalConstant.instantHireCategory,
      "explainYourWork": GlobalConstant.instantHireWork,
      "workingHours": GlobalConstant.instantHireWorkingHrs,
      "lati": widget.lat??"",
      "longi": widget.long??"",
    };
    // http://3.110.135.177/api/api/v1/user/getOtp
    var requestUri = Uri.parse(
        "https://workwave-backend.vercel.app/api/v1/employer/instant/detail/" +
            GlobalConstant.userID);
    print("request url: " + requestUri.toString());
    var jsonBody = const JsonEncoder().convert(map);

    await http
        .post(requestUri, body: jsonBody, headers: {
          'Content-Type': 'application/json',
        })
        .timeout(Duration(seconds: 30))
        .then((http.Response response) async {
          // LoaderWidget.hideLoader(context);
          if (response.statusCode == 200 || response.statusCode == 201) {
      
            var jsonResponse = jsonDecode(response.body);
            print(jsonResponse);
            var value = jsonResponse['order']['orderId'];
setState(() {
  orderid =jsonResponse['order']['orderId'];
});
            GlobalConstant.instantHireOrderId =
                jsonResponse['order']['orderId'];
                      _getOrderDetails();
 _fetchManpowerData();
 
            // print('ordeeerrr id :${GlobalConstant.instantHireOrderId}');
            // Loader().dismiss();
           
          } else if (response.statusCode == 401 || response.statusCode == 422) {
            var jsonResponse = jsonDecode(response.body);
            // Loader().dismiss();
          } else if (response.statusCode == 500) {
            var jsonResponse = jsonDecode(response.body);
            // Loader().dismiss();
          }
        })
        .catchError((error) {
          print(' errorrr   ${error}');
          // Loader().dismiss();
        });
  }



}