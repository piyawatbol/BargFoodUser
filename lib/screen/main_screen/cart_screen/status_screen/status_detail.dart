import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';

class StatusDetail extends StatefulWidget {
  StatusDetail({Key? key}) : super(key: key);

  @override
  State<StatusDetail> createState() => _StatusDetailState();
}

class _StatusDetailState extends State<StatusDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Order Detail',
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
