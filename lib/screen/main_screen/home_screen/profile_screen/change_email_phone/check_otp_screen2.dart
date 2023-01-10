// ignore_for_file: deprecated_member_use, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:barg_user_app/widget/show_aleart.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOtpScreen2 extends StatefulWidget {
  String email;
  CheckOtpScreen2({required this.email});

  @override
  State<CheckOtpScreen2> createState() => _CheckOtpScreen2State();
}

class _CheckOtpScreen2State extends State<CheckOtpScreen2> {
  bool statusLoading = false;
  TextEditingController otp = TextEditingController();
  String? user_id;
  int _Counter = 60;
  late Timer _timer;

  get_user_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
  }

  void startTimer() {
    _Counter = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_Counter > 0) {
        if (this.mounted) {
          setState(() {
            _Counter--;
          });
        }
      } else {
        _timer.cancel();
      }
    });
  }

  check_otp() async {
    final response = await http.post(
      Uri.parse('$ipcon/check_otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': widget.email,
        'otp': otp.text,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      var data = json.decode(response.body);
      print(data);
      if (data == "not correct") {
        buildShowAlert(context, "Otp Incorrect");
      } else if (data == "correct") {
        setState(() {
          statusLoading = true;
        });
        change_email();
      }
    }
  }

  change_email() async {
    final response = await http.patch(
      Uri.parse('$ipcon/change_email/$user_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": widget.email,
      }),
    );
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      if (data == "update email success") {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  send_otp() async {
    final response = await http.post(
      Uri.parse('$ipcon/send_otp_email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': widget.email,
      }),
    );
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      if (data == "send email success") {
        // buildShowAlert("Send email Again");
        buildShowAlert(context, "Send email Again Success");
        startTimer();
      }
    }
  }

  @override
  void initState() {
    startTimer();
    get_user_id();
    super.initState();
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
        backgroundColor: Colors.white,
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.05),
                        child: AutoText(
                          text: "${widget.email}",
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildInputBoxOtp(),
                      buildSendAgain(),
                      buildButtonContinnue(),
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

  Widget buildInputBoxOtp() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            text: "Otp",
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: height * 0.01,
          ),
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
            child: TextField(
              keyboardType: TextInputType.number,
              controller: otp,
              obscureText: false,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                hintMaxLines: 1,
                hintText: "Enter your otp",
                hintStyle: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSendAgain() {
    double height = MediaQuery.of(context).size.height;
    return _Counter == 0
        ? TextButton(
            onPressed: () {
              setState(() {
                statusLoading = true;
              });
              send_otp();
            },
            child: AutoText(
              color: Colors.black,
              fontSize: 14,
              fontWeight: null,
              text: 'send again',
            ))
        : Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            child: AutoText(
              text: "Resend in $_Counter seconds",
              fontSize: 14,
              color: Colors.black,
              fontWeight: null,
            ),
          );
  }

  Widget buildButtonContinnue() {
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
          vertical: height * 0.04, horizontal: width * 0.07),
      width: double.infinity,
      height: height * 0.055,
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
          setState(() {
            statusLoading = true;
          });
          check_otp();
        },
        child: Center(
          child: AutoText(
            color: Colors.black,
            fontSize: 24,
            text: 'Continnue',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
