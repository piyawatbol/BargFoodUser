// ignore_for_file: unused_local_variable
import 'dart:async';
import 'package:barg_user_app/widget/color.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:geocoding/geocoding.dart';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_picker/map_picker.dart';

class MappickerScreen extends StatefulWidget {
  const MappickerScreen({Key? key}) : super(key: key);

  @override
  _MappickerScreenState createState() => _MappickerScreenState();
}

class _MappickerScreenState extends State<MappickerScreen> {
  bool statusLoading = false;
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();
  Position? userLocation;
  double? lati;
  double? longti;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 18,
  );

  Future<Position?> _getLocation() async {
    userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return userLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
              // pass icon widget
              iconWidget: Image.asset(
                "assets/images/pin.png",
                height: 60,
              ),
              //add map picker controller
              mapPickerController: mapPickerController,
              child: FutureBuilder(
                future: _getLocation(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return GoogleMap(
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      // hide location button
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      //  camera position
                      initialCameraPosition: CameraPosition(
                        zoom: 18,
                        target: LatLng(
                            userLocation!.latitude, userLocation!.longitude),
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMoveStarted: () {
                        // notify map is moving
                        mapPickerController.mapMoving!();
                      },
                      onCameraMove: (cameraPosition) {
                        this.cameraPosition = cameraPosition;
                      },
                      onCameraIdle: () async {
                        // notify map stopped moving
                        mapPickerController.mapFinishedMoving!();
                        //get address name from camera position
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                          cameraPosition.target.latitude,
                          cameraPosition.target.longitude,
                        );
                        // update the ui with the address
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: TextFormField(
              maxLines: 3,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, border: InputBorder.none),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 50,
              child: TextButton(
                child: const Text(
                  "Pin",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFFFFFFF),
                    fontSize: 19,
                  ),
                ),
                onPressed: () {
                  if (cameraPosition.target.latitude != 0.0) {
                    setState(() {
                      statusLoading = true;
                    });
                    // print(
                    //     "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                    List latlong = [
                      cameraPosition.target.latitude,
                      cameraPosition.target.longitude
                    ];
                    Navigator.pop(context, latlong);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 35,
                      color: blue,
                    ),
                  ),
                  Text(
                    "Pin Store",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: blue),
                  ),
                ],
              ),
            ),
          ),
          LoadingPage(statusLoading: statusLoading)
        ],
      ),
    );
  }
}
