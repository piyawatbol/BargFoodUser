// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:barg_user_app/screen/main_screen/cart_screen/status_screen/rate_rider_screen.dart';
import 'package:barg_user_app/screen/main_screen/order_screen/detail_order.dart';
import 'package:barg_user_app/widget/loading_page2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class StatusScreen extends StatefulWidget {
  String? request_id;
  StatusScreen({required this.request_id});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  Set<Marker> markers = Set(); //markers for google map
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyB69O3HUJkJwXLuvu3jfqgW7EUOzGvVxlI";
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  Position? driverLocation;
  String? user_id;
  List requestList = [];
  bool statusLoading = false;
  Timer? _timer;
  double? store_lat;
  double? store_long;
  double? rider_lat;
  double? rider_long;
  LatLng? startLocation;
  LatLng? endLocation;
  double latmap = 0.0;
  double longmap = 0.0;
  double? zoom;
  double? distance;
  String? status;
  late BitmapDescriptor mapMaker;
  List orderList = [];
  List userList = [];
  String? rider_id;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  get_user(rider_id) async {
    final response = await http.get(Uri.parse("$ipcon/get_user/$rider_id"));
    var data = json.decode(response.body);
    setState(() {
      userList = data;
    });
  }

  get_request_one() async {
    final response = await http
        .get(Uri.parse("$ipcon/get_request_one/${widget.request_id}"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        statusLoading = false;
        requestList = data;
        status = requestList[0]['status'];
        if (status == '1') {
          setState(() {
            statusLoading = true;
          });
        }
        if (requestList[0]['rider_id'] != "") {
          get_user(requestList[0]['rider_id']);
        }
        store_lat = double.parse(requestList[0]['store_lat']);
        store_long = double.parse(requestList[0]['store_long']);
        if (requestList[0]['rider_lati'] != "") {
          rider_lat = double.parse(requestList[0]['rider_lati']);
          rider_long = double.parse(requestList[0]['rider_longti']);
        }
      });
    }

    final Uint8List markerIcon1 =
        await getBytesFromAsset('assets/images/store_location.png', 130);
    final Uint8List markerIcon2 =
        await getBytesFromAsset('assets/images/rider.png', 100);
    final Uint8List markerIcon3 =
        await getBytesFromAsset('assets/images/location_marker.png', 130);
    if (this.mounted) {
      setState(() {
        startLocation = LatLng(double.parse(requestList[0]['latitude']),
            double.parse(requestList[0]['longtitude']));

        if (status == '6' || status == "7") {
          endLocation = LatLng(rider_lat!, rider_long!);
        } else {
          endLocation = LatLng(store_lat!, store_long!);
        }

        if (requestList[0]['status'] == "6" ||
            requestList[0]['status'] == "7") {
          latmap = double.parse(requestList[0]['latitude']) + rider_lat!;
          latmap = latmap / 2;
          longmap = double.parse(requestList[0]['longtitude']) + rider_long!;
          longmap = longmap / 2;
          double cal = calculateDistance(rider_lat!, rider_long!);
          check_zoom(cal);
        } else {
          latmap = double.parse(requestList[0]['latitude']) + store_lat!;
          latmap = latmap / 2;
          longmap = double.parse(requestList[0]['longtitude']) + store_long!;
          longmap = longmap / 2;
          double cal = calculateDistance(store_lat!, store_long!);
          check_zoom(cal);
        }
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: zoom!,
              target: LatLng(latmap, longmap),
            ),
          ),
        );
        markers.add(
          Marker(
            markerId: MarkerId('1'),
            position: LatLng(double.parse(requestList[0]['latitude']),
                double.parse(requestList[0]['longtitude'])),
            infoWindow: InfoWindow(
              title: 'Destination Point ',
              snippet: 'Destination Marker',
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon3),
          ),
        );
        markers.add(
          Marker(
            markerId: MarkerId('2'),
            position: LatLng(store_lat!, store_long!),
            infoWindow: InfoWindow(
              title: 'Destination Point ',
              snippet: 'Destination Marker',
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon1),
          ),
        );
        if (requestList[0]['rider_lati'] != '') {
          markers.add(
            Marker(
              markerId: MarkerId('3'),
              position: LatLng(rider_lat!, rider_long!),
              infoWindow: InfoWindow(
                title: 'Destination Point ',
                snippet: 'Destination Marker',
              ),
              icon: BitmapDescriptor.fromBytes(markerIcon2),
            ),
          );
        }
      });
    }
    if (status == '6') {
      add_maker_polyline();
    }
  }

  add_maker_polyline() async {
    if (this.mounted) {
      setState(
        () {
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: zoom!,
                target: LatLng(latmap, longmap),
              ),
            ),
          );
        },
      );
    }
    await getDirections();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation!.latitude, startLocation!.longitude),
      PointLatLng(endLocation!.latitude, endLocation!.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: blue,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  check_zoom(double cal) {
    if (cal <= 0.3) {
      return zoom = 17;
    } else if (cal <= 1) {
      return zoom = 16;
    } else if (cal <= 2) {
      return zoom = 15;
    } else if (cal <= 3) {
      return zoom = 14;
    } else if (cal <= 4) {
      return zoom = 13;
    } else if (cal <= 5) {
      return zoom = 12;
    } else if (cal <= 6) {
      return zoom = 11;
    } else if (cal <= 7) {
      return zoom = 10;
    } else if (cal <= 8) {
      return zoom = 9;
    } else if (cal <= 9) {
      return zoom = 8;
    }
  }

  calculateDistance(double lat, double long) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat - double.parse(requestList[0]['latitude'])) * p) / 2 +
        c(double.parse(requestList[0]['latitude']) * p) *
            c(lat * p) *
            (1 - c((double.parse(requestList[0]['longtitude']) - long) * p)) /
            2;

    distance = double.parse((12742 * asin(sqrt(a))).toStringAsFixed(2));
    return distance;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    driverLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return driverLocation;
  }

  @override
  void initState() {
    _getLocation();
    statusLoading = true;
    get_request_one();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (status == '7') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return RateRiderScreen(
            request_id: '${requestList[0]['request_id']}',
            rider_id: '${requestList[0]['rider_id']}',
          );
        }));
      }
      get_request_one();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.2,
        backgroundColor: Colors.white,
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Order Status',
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            buildMap(),
            requestList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [buildInfo(), buildStatus()],
                  ),
            LoadingPage2(statusLoading: statusLoading)
          ],
        ),
      ),
    );
  }

  Widget buildInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      width: width,
      height: height * 0.08,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/location.png",
                          width: width * 0.035,
                          height: height * 0.015,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                        AutoText(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: null,
                          text: '${requestList[0]['store_name']}',
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/location.png",
                          width: width * 0.035,
                          height: height * 0.015,
                          color: blue,
                        ),
                        SizedBox(width: 4),
                        SizedBox(
                          width: width * 0.77,
                          child: AutoText2(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: null,
                            text: '${requestList[0]['address_detail']}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DetailOrderScreen(
                        request_id: '${widget.request_id}',
                        store_id: '',
                      );
                    }));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoText(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: null,
                        text: 'detail',
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMap() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot<Position?> snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              markers: markers,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: requestList.isEmpty
                    ? LatLng(0.0, 0.0)
                    : LatLng(double.parse(requestList[0]['latitude']),
                        double.parse(requestList[0]['longtitude'])),
              ),
            );
          } else {
            return Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget buildStatus() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.022, horizontal: width * 0.025),
      width: width,
      height: userList.isEmpty ? height * 0.1 : height * 0.22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/rider2.png',
                    color:
                        int.parse(status.toString()) >= 4 ? blue : Colors.grey,
                    width: width * 0.08,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.018),
                    width: width * 0.15,
                    height: height * 0.01,
                    decoration: BoxDecoration(
                      color: int.parse(status.toString()) >= 4
                          ? blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Image.asset(
                    'assets/images/shop.png',
                    color:
                        int.parse(status.toString()) >= 5 ? blue : Colors.grey,
                    width: width * 0.065,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                    width: width * 0.15,
                    height: height * 0.01,
                    decoration: BoxDecoration(
                        color: int.parse(status.toString()) >= 5
                            ? blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Image.asset(
                    'assets/images/rider3.png',
                    color:
                        int.parse(status.toString()) >= 6 ? blue : Colors.grey,
                    width: width * 0.063,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                    width: width * 0.15,
                    height: height * 0.01,
                    decoration: BoxDecoration(
                        color: int.parse(status.toString()) >= 6
                            ? blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Image.asset(
                    'assets/images/home2.png',
                    color: status == '7' ? blue : Colors.grey,
                    width: width * 0.06,
                  ),
                ],
              ),
            ),
          ),
          userList.isEmpty
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: Divider(),
                ),
          userList.isEmpty
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.018, horizontal: width * 0.03),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: width * 0.08,
                        backgroundImage: NetworkImage(
                            '$path_img/users/${userList[0]['user_image']}'),
                      ),
                      SizedBox(width: width * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoText(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: null,
                            text:
                                '${userList[0]['first_name']} ${userList[0]['last_name']}',
                          ),
                          AutoText(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: null,
                            text: 'tel : ${userList[0]['phone']} ',
                          ),
                        ],
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
