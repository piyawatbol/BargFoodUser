// ignore_for_file: must_be_immutable
import 'package:barg_user_app/ipcon.dart';
import 'package:flutter/material.dart';

class ShowBigImg extends StatefulWidget {
  String? img;
  ShowBigImg({required this.img});

  @override
  State<ShowBigImg> createState() => _ShowBigImgState();
}

class _ShowBigImgState extends State<ShowBigImg> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Image.network("$path_img/users/${widget.img}"))),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/images/cancel.png",
                      width: width * 0.15,
                      height: height * 0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
