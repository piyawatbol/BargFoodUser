import 'dart:convert';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/map_picker.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:barg_user_app/widget/inputstyle.dart';
import 'package:barg_user_app/widget/toast_custom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class AddAddressScreen extends StatefulWidget {
  AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController house_number = TextEditingController();
  TextEditingController county = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  TextEditingController address_detail = TextEditingController();
  GoogleMapController? mapController;
  Position? userLocation;
  double? lat;
  double? long;
  String? user_id;
  Set<Marker> markers = Set(); //markers for google map
  bool statusLoading = false;
  List statusNameList = [];
  String? select_status_id;

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

  Future<Position?> _getLocation() async {
    userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return userLocation;
  }

  callback_location() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MappickerScreen()),
    );
    if (result != null) {
      lat = double.parse(result[0].toString());
      long = double.parse(result[1].toString());
      print(lat);
      print(long);
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/images/location_marker.png', 130);

      setState(() {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 16,
              target: LatLng(lat!, long!),
            ),
          ),
        );
        markers.add(
          Marker(
            markerId: MarkerId('1'),
            position: LatLng(lat!, long!),
            infoWindow: InfoWindow(
              title: 'Destination Point ',
              snippet: 'Destination Marker',
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      });
    }
  }

  add_address() async {
    print("user_id : $user_id");
    print(name.text);
    print(phone.text);
    print(house_number.text);
    print(district.text);
    print(county.text);
    print(province.text);
    print(zipcode.text);
    print(lat);
    print(long);
    print(address_detail.text);
    print(select_status_id);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.post(
      Uri.parse('$ipcon/add_address'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id.toString(),
        "name": name.text,
        "phone": phone.text,
        "house_number": house_number.text,
        "county": county.text,
        "district": district.text,
        "province": province.text,
        "zip_code": zipcode.text,
        "latitude": lat.toString(),
        "longtitude": long.toString(),
        "address_detail": address_detail.text,
        "address_status_id": select_status_id.toString()
      }),
    );
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      Toast_Custom("Add to Address Success", Colors.green);
      Navigator.pop(context);
    }
  }

  get_address_status() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_address_status"));
    var data = json.decode(response.body);
    setState(() {
      statusNameList = data;
    });
  }

  @override
  void initState() {
    _getLocation();
    get_address_status();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0.2,
        title: AutoText(
          text: "Add My Address",
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.01),
                    buildBox("Name", name),
                    buildBox("Phone", phone),
                    buildBox("House Number", house_number),
                    buildBox("County", county),
                    buildBox("District", district),
                    buildBox("Province", province),
                    buildBox("Zipcode", zipcode),
                    buildBox("Detail", address_detail),
                    lat == null
                        ? GestureDetector(
                            onTap: () async {
                              callback_location();
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: height * 0.02),
                              width: width * 0.9,
                              height: height * 0.2,
                              color: Colors.grey.shade200,
                              child: Center(
                                child: AutoText(
                                  color: null,
                                  fontSize: 16,
                                  fontWeight: null,
                                  text: 'Pin Your Location',
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              buildMap(),
                              GestureDetector(
                                onTap: () {
                                  callback_location();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  height: height * 0.2,
                                ),
                              ),
                            ],
                          ),
                    Container(
                      height: height * 0.05,
                      child: ListView.builder(
                        itemCount: statusNameList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                select_status_id = statusNameList[index]
                                        ['address_status_id']
                                    .toString();
                              });
                            },
                            child: statusNameList[index]
                                        ['address_status_name'] ==
                                    ""
                                ? SizedBox()
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.02),
                                    width: width * 0.2,
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 3,
                                            color: statusNameList[index][
                                                            'address_status_id']
                                                        .toString() ==
                                                    select_status_id
                                                ? Colors.red
                                                : Colors.white)),
                                    child: Center(
                                      child: AutoText(
                                        color: Colors.black,
                                        fontSize: 14,
                                        text:
                                            '${statusNameList[index]['address_status_name']}',
                                        fontWeight: null,
                                      ),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    buildButtonSave()
                  ],
                ),
              ),
              LoadingPage(statusLoading: statusLoading)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBox(String? text1, TextEditingController? controller) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            text: '$text1',
          ),
          SizedBox(height: height * 0.01),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกข้อมูล';
              }
              return null;
            },
            style: GoogleFonts.itim(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            controller: controller,
            decoration: inputStyle(context),
          ),
        ],
      ),
    );
  }

  Widget buildMap() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: _getLocation(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.symmetric(
                vertical: height * 0.02, horizontal: width * 0.05),
            color: Colors.white,
            width: width,
            height: height * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: GoogleMap(
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                onMapCreated: _onMapCreated,
                myLocationEnabled: false,
                initialCameraPosition: CameraPosition(
                  zoom: 16,
                  target: LatLng(lat!, long!),
                ),
              ),
            ),
          );
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildButtonSave() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.04),
      width: width * 0.3,
      height: height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          final isValid = formKey.currentState!.validate();
          if (isValid) {
            if (lat == null) {
              Toast_Custom("Please Pin map", Colors.red);
            } else if (select_status_id == null) {
              Toast_Custom("Please Selct Status", Colors.red);
            } else {
              // setState(() {
              //   statusLoading = true;
              // });
              add_address();
            }
          }
        },
        child: Center(
          child: AutoText(
            color: Colors.black,
            fontSize: 14,
            text: 'Save',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
