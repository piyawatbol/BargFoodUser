import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';

class DetailStoreScreen extends StatefulWidget {
  DetailStoreScreen({Key? key}) : super(key: key);

  @override
  State<DetailStoreScreen> createState() => _DetailStoreScreenState();
}

class _DetailStoreScreenState extends State<DetailStoreScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: AutoText(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          text: 'Detail',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: width,
        height: height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.02),
                width: width,
                height: height * 0.2,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
              ),
              AutoText(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                text: 'ก๋วยเตี๋ยวเรือรังสิต',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
