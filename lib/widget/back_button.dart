// ignore_for_file: must_be_immutable

import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';

class BackArrowButton extends StatelessWidget {
  String? text;
  double? width2;
  BackArrowButton({required this.text, required this.width2});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.018, horizontal: width * 0.025),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: width * 0.07,
              color: Colors.white,
            ),
          ),
          AutoText(
          
            text: "${text}",
            fontSize: 18,
            color: Colors.white,
          
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}
