import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Status',
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
