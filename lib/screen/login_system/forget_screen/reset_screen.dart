// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, deprecated_member_use, must_be_immutable
import 'dart:convert';
import 'package:barg_user_app/screen/login_system/login_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/back_button.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  String? email;
  ResetScreen({required this.email});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  bool statusLoading = false;
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();

  reset_password() async {
    final response = await http.post(
      Uri.parse('$ipcon/reset_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': widget.email.toString(),
        'pass_word': pass1.text,
        'status_id': '2'
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      var data = json.decode(response.body);
      if (data == "reset success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return LoginScreen();
          }),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: width,
              height: height,
              color: blue,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BackArrowButton(text: "Reset Password", width2: 0.34),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.04),
                        child: AutoText(
                          text: "Reset Password",
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BuildPassBox("Password", pass1, 0.15),
                      SizedBox(height: height * 0.02),
                      BuildPassBox("Confirm Password", pass2, 0.28),
                      buildButtonContinnue()
                    ],
                  ),
                ),
              ),
            ),
            LoadingPage(statusLoading: statusLoading)
          ],
        ),
      ),
    );
  }

  Widget BuildPassBox(
      String? text, TextEditingController? controller, double? width2) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            text: text,
            fontSize: 14,
            color: Colors.white,
            fontWeight: null,
          ),
          SizedBox(height: height * 0.004),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                color: blue,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: blue,
                  ),
                  hintText: "$text",
                  hintStyle: TextStyle(color: blue)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtonContinnue() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.04, horizontal: width * 0.07),
      width: double.infinity,
      height: height * 0.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          if (pass1.text != pass2.text) {
            buildShowAlert("Passwords do not match");
          } else {
            setState(() {
              statusLoading = true;
            });
            reset_password();
          }
        },
        child: Center(
          child: AutoText(
            color: blue,
            fontSize: 24,
            text: 'Continnue',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  buildShowAlert(String? text) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Center(
            child: Text(
          "$text",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.1, vertical: height * 0.01),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: AutoText(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                text: 'Ok',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
