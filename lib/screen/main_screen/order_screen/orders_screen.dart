import 'dart:convert';
import 'package:barg_user_app/screen/main_screen/cart_screen/status_screen/status_screen.dart';
import 'package:barg_user_app/screen/main_screen/order_screen/detail_order.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? user_id;
  List requestList = [];
  int sum_price = 0;

  get_request() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/get_request_all/$user_id"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        requestList = data;
      });
    }
  }

  @override
  void initState() {
    get_request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: AutoText(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            text: 'Order History',
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              TabBar(
                  labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: blue,
                      fontSize: 16,
                    ),
                  ),
                  unselectedLabelColor: Colors.grey,
                  labelColor: blue,
                  tabs: [
                    Tab(
                      text: "Delivering",
                    ),
                    Tab(
                      text: "Completed",
                    ),
                    Tab(
                      text: "Cancel",
                    )
                  ]),
              Expanded(
                child: Container(
                  height: height,
                  child: TabBarView(children: [
                    requestList.isEmpty ? Container() : buildDelivering(),
                    requestList.isEmpty ? Container() : buildCompleted(),
                    requestList.isEmpty ? Container() : buildCancel()
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDelivering() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (BuildContext context, int index) {
        return requestList[index]['order_status_id'] > 6
            ? Container()
            : GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return StatusScreen(
                      request_id: '${requestList[index]['request_id']}',
                    );
                  })).then((value) => get_request());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.015, horizontal: width * 0.07),
                  width: width,
                  height: height * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0.1,
                        spreadRadius: 0.1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoText(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: null,
                            text:
                                '${requestList[index]['date']} , ${requestList[index]['time']}',
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                    vertical: height * 0.003),
                                child: Image.asset(
                                  "assets/images/location.png",
                                  width: width * 0.04,
                                  height: height * 0.02,
                                  color: Colors.red,
                                ),
                              ),
                              AutoText(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                                fontWeight: null,
                                text: '${requestList[index]['store_name']}',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                    vertical: height * 0.003),
                                child: Image.asset(
                                  "assets/images/location.png",
                                  width: width * 0.04,
                                  height: height * 0.02,
                                  color: blue,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.71,
                                child: AutoText2(
                                  color: Colors.grey.shade800,
                                  fontSize: 12,
                                  fontWeight: null,
                                  text:
                                      '${requestList[index]['address_detail']} ${requestList[index]['house_number']} ${requestList[index]['county']} ${requestList[index]['district']}',
                                ),
                              ),
                            ],
                          ),
                          AutoText(
                            color: blue,
                            fontSize: 12,
                            fontWeight: null,
                            text: '${requestList[index]['order_status_name']}',
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoText(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: null,
                            text: '${requestList[index]['total']} ฿',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget buildCompleted() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (BuildContext context, int index) {
        return requestList[index]['order_status_id'] == 7
            ? GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return DetailOrderScreen(
                      request_id: '${requestList[index]['request_id']}',
                      store_id: '${requestList[index]['store_id']}',
                    );
                  })).then((value) => get_request());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.015, horizontal: width * 0.07),
                  width: width,
                  height: height * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0.1,
                        spreadRadius: 0.1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoText(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: null,
                            text:
                                '${requestList[index]['date']} , ${requestList[index]['time']}',
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                    vertical: height * 0.003),
                                child: Image.asset(
                                  "assets/images/location.png",
                                  width: width * 0.04,
                                  height: height * 0.02,
                                  color: Colors.red,
                                ),
                              ),
                              AutoText(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                                fontWeight: null,
                                text: '${requestList[index]['store_name']}',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                    vertical: height * 0.003),
                                child: Image.asset(
                                  "assets/images/location.png",
                                  width: width * 0.04,
                                  height: height * 0.02,
                                  color: blue,
                                ),
                              ),
                              AutoText(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                                fontWeight: null,
                                text:
                                    '${requestList[index]['address_detail']} ${requestList[index]['house_number']} ${requestList[index]['county']} ${requestList[index]['district']}',
                              ),
                            ],
                          ),
                          AutoText(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: null,
                            text: '${requestList[index]['order_status_name']}',
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoText(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: null,
                            text: '${requestList[index]['total']} ฿',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget buildCancel() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: requestList.length,
      itemBuilder: (BuildContext context, int index) {
        return requestList[index]['order_status_id'] == 8
            ? GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return DetailOrderScreen(
                      request_id: '${requestList[index]['request_id']}',
                      store_id: '${requestList[index]['store_id']}',
                    );
                  })).then((value) => get_request());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.015, horizontal: width * 0.07),
                  width: width,
                  height: height * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 0.1,
                        spreadRadius: 0.1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoText(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: null,
                            text:
                                '${requestList[index]['date']} , ${requestList[index]['time']}',
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                    vertical: height * 0.003),
                                child: Image.asset(
                                  "assets/images/location.png",
                                  width: width * 0.04,
                                  height: height * 0.02,
                                  color: Colors.red,
                                ),
                              ),
                              AutoText(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                                fontWeight: null,
                                text: '${requestList[index]['store_name']}',
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                    vertical: height * 0.003),
                                child: Image.asset(
                                  "assets/images/location.png",
                                  width: width * 0.04,
                                  height: height * 0.02,
                                  color: blue,
                                ),
                              ),
                              AutoText(
                                color: Colors.grey.shade800,
                                fontSize: 12,
                                fontWeight: null,
                                text:
                                    '${requestList[index]['house_number']} ${requestList[index]['county']} ${requestList[index]['district']}',
                              ),
                            ],
                          ),
                          AutoText(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: null,
                            text: '${requestList[index]['order_status_name']}',
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoText(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: null,
                            text: '${requestList[index]['total']}฿',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
