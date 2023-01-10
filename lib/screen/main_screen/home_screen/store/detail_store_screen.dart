// ignore_for_file: must_be_immutable
import 'dart:convert';

import 'package:barg_user_app/widget/color.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class DetailStoreScreen extends StatefulWidget {
  String? store_id;
  DetailStoreScreen({required this.store_id});

  @override
  State<DetailStoreScreen> createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen> {
  List storeList = [];
  List rateList = [];
  String select_star = "All";
  double? star_values;
  GoogleMapController? mapController;
  Set<Marker> markers = Set(); //markers for google map

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  get_store_one() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_store_one/${widget.store_id}"));
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/location_marker.png', 130);

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(double.parse(storeList[0]['store_lat']),
              double.parse(storeList[0]['store_long'])),
          infoWindow: InfoWindow(
            title: 'Destination Point ',
            snippet: 'Destination Marker',
          ),
          icon: BitmapDescriptor.fromBytes(markerIcon),
        ),
      );
    });
  }

  get_rate_store() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_rate_store/${widget.store_id}"));
    var data = json.decode(response.body);
    setState(() {
      rateList = data;
    });
  }

  get_rate_store_one() async {
    final response = await http.get(
        Uri.parse("$ipcon/get_rate_store/${widget.store_id}/$star_values"));
    var data = json.decode(response.body);
    setState(() {
      rateList = data;
    });
  }

  @override
  void initState() {
    get_store_one();
    get_rate_store();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: AutoText(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          text: 'Detail',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: storeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMap(),
                      AutoText(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        text: '${storeList[0]['store_name']}',
                      ),
                      SizedBox(height: height * 0.03),
                      AutoText(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        text: 'Review',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            buildStar('All', null),
                            buildStar('5', 5.0),
                            buildStar('4', 4.0),
                            buildStar('3', 3.0),
                            buildStar('2', 2.0),
                            buildStar('1', 1.0)
                          ],
                        ),
                      ),
                      rateList.isEmpty
                          ? Container(
                              width: width,
                              height: height * 0.4,
                              child: Center(child: CircularProgressIndicator()))
                          : rateList[0]['star'] == null
                              ? Container()
                              : buildRateList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildStar(String? star, double? values) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        setState(() {
          select_star = star!;
          star_values = values;
        });
        if (values != null) {
          get_rate_store_one();
        } else {
          get_rate_store();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.005),
        width: width * 0.14,
        height: height * 0.04,
        decoration: BoxDecoration(
            color: select_star == star ? Colors.blue.shade300 : null,
            border: Border.all(
              color: blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoText(
              color: select_star == star ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              text: '$star',
            ),
            SizedBox(width: 3),
            Image.asset(
              "assets/images/star2.png",
              color: select_star == star ? Colors.white : Colors.black,
              width: width * 0.025,
            )
          ],
        ),
      ),
    );
  }

  Widget buildMap() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.02),
        color: Colors.white,
        width: width,
        height: height * 0.23,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GoogleMap(
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
              zoom: 16,
              target: storeList.isEmpty
                  ? LatLng(0.0, 0.0)
                  : LatLng(double.parse(storeList[0]['store_lat']),
                      double.parse(storeList[0]['store_long'])),
            ),
          ),
        ));
  }

  Widget buildRateList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      itemCount: rateList.length,
      itemBuilder: (BuildContext context, int index) {
        double star = double.parse(rateList[index]['star'].toString());
        return Container(
          width: width,
          height: rateList[index]['rate_store_img'] == ''
              ? height * 0.12
              : height * 0.23,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundImage: NetworkImage(
                        "$path_img/users/${rateList[index]['user_image']}"),
                  ),
                  SizedBox(width: width * 0.01),
                  AutoText(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: null,
                    text:
                        '${rateList[index]['first_name']} ${rateList[index]['last_name']}',
                  ),
                ],
              ),
              RatingBarIndicator(
                rating: star,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: width * 0.04,
              ),
              rateList[index]['rate_store_img'] == ''
                  ? Container()
                  : Image.network(
                      "$path_img/rate_store/${rateList[index]['rate_store_img']}",
                      width: width * 0.25,
                      height: height * 0.1,
                      fit: BoxFit.cover,
                    ),
              AutoText(
                color: Colors.black,
                fontSize: 14,
                fontWeight: null,
                text: '${rateList[index]['rate_store_detail']}',
              ),
              AutoText(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: null,
                text: '${rateList[index]['date']} ${rateList[index]['time']}',
              ),
            ],
          ),
        );
      },
    ));
  }
}
