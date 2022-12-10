import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  AddAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        title: AutoText(
          text: "Add My Address",
          fontSize: 16,
          color: Colors.black,
          fontWeight: null,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
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
