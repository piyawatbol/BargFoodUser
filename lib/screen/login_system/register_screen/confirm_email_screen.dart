// ignore_for_file: deprecated_member_use, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:barg_user_app/screen/login_system/login_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/back_button.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:barg_user_app/widget/show_aleart.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:flutter/material.dart';

class ConfirmEmailScreen extends StatefulWidget {
  String first_name;
  String last_name;
  String user_name;
  String pass_word;
  String phone;
  String email;
  ConfirmEmailScreen(
      {required this.first_name,
      required this.last_name,
      required this.user_name,
      required this.pass_word,
      required this.phone,
      required this.email});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  bool statusLoading = false;
  TextEditingController otp = TextEditingController();

  int _Counter = 60;
  late Timer _timer;

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
      //   print(_Counter);
    });
  }

  check_otp(sum) async {
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
        register();
      }
    }
  }

  register() async {
    final response = await http.post(
      Uri.parse('$ipcon/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'first_name': widget.first_name,
        'last_name': widget.last_name,
        'user_name': widget.user_name,
        'pass_word': widget.pass_word,
        'email': widget.email,
        'phone': widget.phone,
        'user_image': "",
        "status_id": "2",
      }),
    );
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      register_wallet(data[0]['user_id'].toString());
    }
  }

  register_wallet(String user_id) async {
    final response = await http.post(
      Uri.parse('$ipcon/register_wallet'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id,
      }),
    );
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      if (data == "register wallet Success") {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return LoginScreen();
        }), (route) => false);
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
        buildShowAlert(context, "Send email Again");
        startTimer();
      }
    }
  }

  @override
  void initState() {
    startTimer();
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
        body: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF73AEF5),
                    Color(0xFF61A4F1),
                    Color(0xFF478De0),
                    Color(0xFF398AE5)
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BackArrowButton(text: "Confirm Email", width2: 0.3),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.05),
                        child: AutoText(
                          text: "${widget.email}",
                          fontSize: 24,
                          color: Colors.white,
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
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: otp,
              obscureText: false,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                hintMaxLines: 1,
                hintText: "Enter your otp",
                hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
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
              color: Colors.white,
              fontSize: 14,
              fontWeight: null,
              text: 'send again',
            ))
        : Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.02),
            child: AutoText(
              text: "Resend in $_Counter seconds",
              fontSize: 14,
              color: Colors.white,
              fontWeight: null,
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
          setState(() {
            statusLoading = true;
          });
          check_otp(otp.text);
        },
        child: Center(
          child: AutoText(
            color: Color(0xFF527DAA),
            fontSize: 24,
            text: 'Continnue',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
