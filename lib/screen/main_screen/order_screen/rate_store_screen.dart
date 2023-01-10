// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';
import 'package:barg_user_app/widget/show_modol_img.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class RateStoreScreen extends StatefulWidget {
  String? request_id;
  String? store_id;

  RateStoreScreen({required this.request_id, required this.store_id});

  @override
  State<RateStoreScreen> createState() => _RateStoreScreenState();
}

class _RateStoreScreenState extends State<RateStoreScreen> {
  TextEditingController rate_detail = TextEditingController();
  String? rider_id;
  double star = 5;
  List storeList = [];
  List distanceList = [];
  Position? userLocation;
  double? distance;
  File? image;

  get_store_one() async {
    print(widget.store_id.toString());
    final response =
        await http.get(Uri.parse("$ipcon/get_store_one/${widget.store_id}"));
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
  }

  add_rate_store() async {
    final uri = Uri.parse("$ipcon/add_rate_store");
    var request = http.MultipartRequest('POST', uri);
    var img = await http.MultipartFile.fromPath("img", image!.path);
    request.files.add(img);
    request.fields['request_id'] = widget.request_id.toString();
    request.fields['store_id'] = widget.store_id.toString();
    request.fields['star'] = star.toString();
    request.fields['rate_detail'] = rate_detail.text;
    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    Navigator.pop(context);
  }

  Future pickCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    get_store_one();

    super.initState();
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
          text: 'Rate Store',
        ),
      ),
      body: storeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.03),
                      child: CircleAvatar(
                        radius: width * 0.2,
                        backgroundImage: NetworkImage(
                            "$path_img/store/${storeList[0]['store_image']}"),
                      ),
                    ),
                    AutoText(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      text: '${storeList[0]['store_name']} ',
                    ),
                    SizedBox(height: height * 0.02),
                    buildStar(),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            barrierColor: Colors.black26,
                            context: this.context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (context) {
                              return ShowMoDalImg(
                                  pickCamera: pickCamera, pickImage: pickImage);
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: height * 0.02, horizontal: width * 0.07),
                        width: width,
                        height: height * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300),
                        child: image != null
                            ? Image.file(
                                image!,
                                fit: BoxFit.contain,
                              )
                            : Center(
                                child: Icon(
                                Icons.image,
                                size: width * 0.12,
                                color: Colors.grey.shade800,
                              )),
                      ),
                    ),
                    buildInputBox(),
                    buildSaveButton()
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildStar() {
    return RatingBar.builder(
      initialRating: 5,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: blue,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          star = rating;
        });
        print(star);
      },
    );
  }

  Widget buildInputBox() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.07),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300),
        child: TextField(
          controller: rate_detail,
          minLines: 6,
          maxLines: 9,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.02),
            border: UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      width: width * 0.3,
      height: height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          add_rate_store();
        },
        child: Center(
          child: AutoText(
            color: Colors.white,
            fontSize: 18,
            text: 'Save',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
