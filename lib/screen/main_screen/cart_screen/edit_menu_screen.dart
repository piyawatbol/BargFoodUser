// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:barg_user_app/widget/color.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/toast_custom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMenuScreen extends StatefulWidget {
  String? store_id;
  String? food_id;
  String? food_image;
  String? food_name;
  String? price;
  int? amount;
  String? detaill;
  String? cart_id;
  EditMenuScreen(
      {required this.food_image,
      required this.food_name,
      required this.food_id,
      required this.store_id,
      required this.price,
      required this.amount,
      required this.detaill,required this.cart_id});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  TextEditingController detail = TextEditingController();
  String? user_id;
  List cartList = [];

  edit_menu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    int price = int.parse(widget.price.toString()) * widget.amount!;
    final response = await http.post(
      Uri.parse('$ipcon/add_cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id.toString(),
        "store_id": '${widget.store_id}',
        "food_id": '${widget.food_id}',
        "food_name": '${widget.food_name}',
        "amount": widget.amount.toString(),
        "price": '${price}',
        "detail": detail.text,
      }),
    );
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      Toast_Custom("Add to Cart Success", Colors.green);
      Navigator.pop(context);
    }
  }

  setTextController() async {
    detail = TextEditingController(text: widget.detaill);
  }

  @override
  void initState() {
    setTextController();
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
        body: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImg(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.015, horizontal: width * 0.03),
                    child: AutoText(
                      text: "${widget.food_name}",
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: null,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: height * 0.003),
                    height: 5,
                    color: Colors.grey.shade200,
                  ),
                  buildBox(),
                ],
              ),
              Column(
                children: [buildAmount(), buildButtonAddCart()],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImg() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          width: width,
          height: height * 0.35,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("$path_img/food/${widget.food_image}"))),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: height * 0.05, horizontal: width * 0.04),
          width: width * 0.1,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  Widget buildBox() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            text: 'Additional Request',
          ),
          SizedBox(height: height * 0.01),
          TextField(
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            controller: detail,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: width * 0.05, vertical: height * 0.013),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAmount() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height * 0.08,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.amount != 1) {
                  setState(() {
                    widget.amount = widget.amount! - 1;
                  });
                }
              },
              child: widget.amount == 1
                  ? GestureDetector(
                      onTap: () {},
                      child: Image.asset('assets/images/minus.png',
                          width: width * 0.1,
                          height: height * 0.1,
                          color: Colors.black12),
                    )
                  : Image.asset('assets/images/minus.png',
                      width: width * 0.1,
                      height: height * 0.1,
                      color: Colors.black54),
            ),
            Container(
              width: width * 0.15,
              child: Center(
                child: AutoText(
                  text: "${widget.amount}",
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: null,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.amount = widget.amount! + 1;
                });
              },
              child: Image.asset(
                'assets/images/add.png',
                width: width * 0.1,
                height: height * 0.1,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButtonAddCart() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.025),
          width: width * 0.9,
          height: height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            onPressed: () {},
            child: Center(
              child: AutoText(
                color: Colors.white,
                fontSize: 14,
                text: 'Update to Cart',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
