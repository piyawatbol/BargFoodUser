import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/map_picker.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:barg_user_app/widget/inputstyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class EditAddressScreen extends StatefulWidget {
  EditAddressScreen({Key? key}) : super(key: key);

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  TextEditingController house_number = TextEditingController();
  TextEditingController county = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController zipcode = TextEditingController();
  GoogleMapController? mapController;
  Position? userLocation;
  double? lat;
  double? long;
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

  @override
  void initState() {
    _getLocation();
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
          text: "Edit My Address",
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
          child: Column(
            children: [
              SizedBox(height: height * 0.01),
              buildBox("Houe Number", house_number),
              buildBox("County", county),
              buildBox("District", district),
              buildBox("Province", province),
              buildBox("Zipcode", zipcode),
              lat == null
                  ? GestureDetector(
                      onTap: () async {
                        callback_location();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.02),
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
              buildButtonSave()
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
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
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
        onPressed: () {},
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
