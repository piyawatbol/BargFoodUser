
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: width,
              height: height * 0.2,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
            )
          ],
        ),
      ),
    );
  }
}
