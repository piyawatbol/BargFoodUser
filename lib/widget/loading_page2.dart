// ignore_for_file: must_be_immutable

import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage2 extends StatefulWidget {
  bool? statusLoading;
  LoadingPage2({required this.statusLoading});

  @override
  State<LoadingPage2> createState() => _LoadingPage2State();
}

class _LoadingPage2State extends State<LoadingPage2> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          widget.statusLoading = false;
        });
      },
      child: Visibility(
        visible: widget.statusLoading == true ? true : false,
        child: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: width,
                height: height,
                color: Colors.white10,
              ),
              Positioned(
                child: Container(
                  width: width * 0.57,
                  height: height * 0.26,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/restaurant.png",
                        width: width * 0.5,
                        height: height * 0.1,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      AutoText(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: null,
                        text: 'Waiting Accept Order',
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      SpinKitFadingCircle(
                        color: Color(0xFF398AE5),
                        size: width * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
