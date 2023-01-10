// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:barg_user_app/screen/main_screen/tab_screen.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateRiderScreen extends StatefulWidget {
  String? request_id;
  String? rider_id;
  RateRiderScreen({required this.request_id, required this.rider_id});

  @override
  State<RateRiderScreen> createState() => _RateRiderScreenState();
}

class _RateRiderScreenState extends State<RateRiderScreen> {
  List userList = [];
  TextEditingController rate_detail = TextEditingController();
  double star = 5;
  add_rate_rider() async {
    final response = await http.post(
      Uri.parse('$ipcon/add_rate_rider'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "rider_id": "${widget.rider_id}",
        "request_id": "${widget.request_id}",
        "rate_detail": rate_detail.text,
        "star": star.toString(),
      }),
    );
    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return TabScreen();
      }), (route) => false);
    }
  }

  get_user() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_user/${widget.rider_id}"));
    var data = json.decode(response.body);
    setState(() {
      userList = data;
    });
  }

  @override
  void initState() {
    get_user();
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
          text: 'Rate Rider',
        ),
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.05),
                    child: CircleAvatar(
                      radius: width * 0.2,
                      backgroundImage: NetworkImage(
                          "$path_img/users/${userList[0]['user_image']}"),
                    ),
                  ),
                  AutoText(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    text:
                        '${userList[0]['first_name']} ${userList[0]['last_name']}',
                  ),
                  SizedBox(height: height * 0.04),
                  RatingBar.builder(
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
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.03, horizontal: width * 0.07),
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
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          border:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  buildSaveButton()
                ],
              ),
            ),
    );
  }

  Widget buildSaveButton() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
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
          add_rate_rider();
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
