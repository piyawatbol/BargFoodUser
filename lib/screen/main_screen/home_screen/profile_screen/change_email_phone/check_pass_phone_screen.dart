// ignore_for_file: deprecated_member_use, unused_local_variable
import 'dart:convert';
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/change_email_phone/check_phone_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';

import 'package:barg_user_app/widget/color.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:barg_user_app/widget/show_aleart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckPassPhoneScreen extends StatefulWidget {
  CheckPassPhoneScreen({Key? key}) : super(key: key);

  @override
  State<CheckPassPhoneScreen> createState() => _CheckPassPhoneScreenState();
}

class _CheckPassPhoneScreenState extends State<CheckPassPhoneScreen> {
  bool pass = true;
  bool statusLoading = false;
  TextEditingController pass_word = TextEditingController();

  check_password() async {
    String? user_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.post(
      Uri.parse('$ipcon/check_password/$user_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"pass_word": pass_word.text}),
    );
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      var data = json.decode(response.body);
      print(data);
      if (data == "correct") {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return CheckPhoneScreen();
        }));
      } else if (data == "not correct") {
        buildShowAlert(context, "Password Incorrect");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        title: AutoText(
          text: "Check Password",
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [],
      ),
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.04),
                          child: AutoText(
                            text: "Enter Password",
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        buildBoxPass(),
                        buildButtonContinue()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          LoadingPage(statusLoading: statusLoading)
        ],
      ),
    );
  }

  Widget buildBoxPass() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            text: "Password",
            fontSize: 14,
            color: Colors.black,
            fontWeight: null,
          ),
          SizedBox(height: height * 0.004),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 1,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: TextFormField(
              obscureText: pass,
              controller: pass_word,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  suffixIcon: pass == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              pass = !pass;
                            });
                          },
                          icon: Icon(
                            Icons.visibility_off,
                            color: Colors.black,
                          ))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              pass = !pass;
                            });
                          },
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.black,
                          )),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.key,
                    color: Colors.black,
                  ),
                  hintText: "Enter your Password",
                  hintStyle: TextStyle(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtonContinue() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
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
      margin: EdgeInsets.symmetric(
          vertical: height * 0.07, horizontal: width * 0.07),
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
          setState(() {
            statusLoading = true;
          });
          check_password();
        },
        child: Center(
          child: AutoText(
            color: Colors.black,
            fontSize: 24,
            text: 'Continue',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
