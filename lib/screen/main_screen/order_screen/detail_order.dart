// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';

class DetailOrderScreen extends StatefulWidget {
  String? request_id;
  DetailOrderScreen({required this.request_id});

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  List requestList = [];
  List orderList = [];
  String? success_img;
  int sumPrice = 0;

  get_request_one() async {
    final response = await http
        .get(Uri.parse("$ipcon/get_request_one/${widget.request_id}"));
    var data = json.decode(response.body);
    setState(() {
      requestList = data;
    });
    get_order(requestList[0]['order_id']);
    get_success_img();
  }

  get_order(order_id) async {
    final response = await http.get(Uri.parse("$ipcon/get_order/$order_id"));
    var data = json.decode(response.body);
    setState(() {
      orderList = data;
    });
    sumPrice = 0;
    for (var i = 0; i < orderList.length; i++) {
      sumPrice = sumPrice + int.parse(orderList[i]['price']);
    }
  }

  get_success_img() async {
    final response = await http
        .get(Uri.parse("$ipcon/get_success_img/${widget.request_id}"));
    var data = json.decode(response.body);
    if (data.toString() != '[]') {
      setState(() {
        success_img = data[0]['success_img'];
      });
    }
  }

  @override
  void initState() {
    get_request_one();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.2,
        backgroundColor: Colors.white,
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Order Detail',
        ),
      ),
      body: requestList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildNameStore(),
                    buildAddress(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.04),
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.02),
                      child: AutoText(
                        color: Colors.grey.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        text: 'Menu',
                      ),
                    ),
                    buildListOrder(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02, horizontal: width * 0.04),
                      child: Divider(),
                    ),
                    buildTotal(),
                    success_img == null
                        ? Container()
                        : Container(
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            width: width,
                            height: height * 0.2,
                            child: Image.network(
                              "$path_img/success/$success_img",
                              fit: BoxFit.contain,
                            ),
                          )
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildNameStore() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.03),
      width: width,
      height: height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            color: Colors.black,
            fontSize: 20,
            fontWeight: null,
            text: '${requestList[0]['store_name']}',
          ),
          AutoText(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: null,
            text: '${requestList[0]['date']} ${requestList[0]['time']}',
          ),
        ],
      ),
    );
  }

  Widget buildAddress() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.07,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: width * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.005, vertical: height * 0.003),
                child: Image.asset(
                  "assets/images/location.png",
                  width: width * 0.04,
                  height: height * 0.02,
                  color: Colors.red,
                ),
              ),
              AutoText2(
                color: Colors.grey.shade800,
                fontSize: 14,
                fontWeight: null,
                text:
                    '${requestList[0]['store_house_number']} ${requestList[0]['store_county']} ${requestList[0]['store_district']} ${requestList[0]['store_province']}	',
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: width * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.005, vertical: height * 0.003),
                child: Image.asset(
                  "assets/images/location.png",
                  width: width * 0.04,
                  height: height * 0.02,
                  color: blue,
                ),
              ),
              AutoText2(
                color: Colors.grey.shade800,
                fontSize: 14,
                fontWeight: null,
                text:
                    '${requestList[0]['address_detail']} ${requestList[0]['county']} ${requestList[0]['district']} ${requestList[0]['province']}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildListOrder() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: orderList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.045),
            width: width,
            height: height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: width * 0.07,
                      height: height * 0.035,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 1,
                            spreadRadius: 1,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text("${orderList[index]['amount']}"),
                      ),
                    ),
                    SizedBox(width: width * 0.035),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoText(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          text: '${orderList[index]['food_name']}',
                        ),
                        AutoText(
                          color: Colors.black38,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          text: '${orderList[index]['detail']}',
                        ),
                      ],
                    ),
                  ],
                ),
                AutoText(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  text: '${orderList[index]['price']} ฿',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTotal() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.02, horizontal: width * 0.03),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoText(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                text: 'Total',
              ),
              AutoText(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                text: '$sumPrice ฿',
              ),
            ],
          )
        ],
      ),
    );
  }
}
