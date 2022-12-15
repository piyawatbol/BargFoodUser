import 'dart:convert';
import 'package:barg_user_app/screen/main_screen/cart_screen/pay_screen.dart';
import 'package:barg_user_app/widget/toast_custom.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? user_id;
  List cartList = [];
  int sum_price = 0;
  String? selectItem;
  List item = ["QR CODE", "Pay On Delivery"];
  get_cart() async {
    sum_price = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });

    final response = await http.get(Uri.parse("$ipcon/get_cart/$user_id"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        cartList = data;
      });
    }
    if (cartList[0]['price'] != null) {
      for (var i = 0; i < cartList.length; i++) {
        sum_price = sum_price + int.parse(cartList[i]['price'].toString());
      }
    }
  }

  @override
  void initState() {
    get_cart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Cart',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: cartList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : cartList[0]['item'] == 'not have cart'
              ? Container(
                  child: Center(
                    child: AutoText(
                      color: blue,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      text: 'Cart is Emty',
                    ),
                  ),
                )
              : Container(
                  width: width,
                  height: height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText("Delivery info"),
                        buildAddress(),
                        buildText("Contact info"),
                        buildContactInfo(),
                        SizedBox(height: height * 0.02),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: height * 0.01),
                          height: 5,
                          color: Colors.grey.shade100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText('My Order'),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              child: AutoText(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                text: '${cartList[0]['store_name']}',
                              ),
                            ),
                          ],
                        ),
                        buildListOrder(),
                        SizedBox(height: height * 0.015),
                        buildPayMedthod(),
                        buildTotal(),
                        buildButtonOrderNow()
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget buildText(String? text) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.01),
      child: AutoText(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        text: '$text',
      ),
    );
  }

  Widget buildAddress() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10),
      width: width,
      height: height * 0.05,
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/location.png",
            width: width * 0.05,
            height: height * 0.025,
            color: blue,
          ),
          SizedBox(width: width * 0.03),
          AutoText(
            color: Colors.black,
            fontSize: 14,
            fontWeight: null,
            text: '555/4 คลองจั่น บางกระปิ',
          ),
        ],
      ),
    );
  }

  Widget buildContactInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10),
      width: width,
      height: height * 0.05,
      margin: EdgeInsets.symmetric(horizontal: width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.phone,
            color: blue,
          ),
          SizedBox(width: width * 0.02),
          AutoText(
            color: Colors.black,
            fontSize: 14,
            fontWeight: null,
            text: '0999999',
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
        itemCount: cartList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.045),
            width: width,
            height: height * 0.08,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            )),
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
                        child: Text("${cartList[index]['amount']}"),
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
                          text: '${cartList[index]['food_name']}',
                        ),
                        AutoText(
                          color: Colors.black38,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          text: '${cartList[index]['detail']}',
                        ),
                      ],
                    ),
                  ],
                ),
                AutoText(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  text: '${cartList[index]['price']} ฿',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPayMedthod() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.02, horizontal: width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoText(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            text: 'Payment method',
          ),
          buildDropDown1()
        ],
      ),
    );
  }

  Widget buildDropDown1() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      width: selectItem == "Pay On Delivery" ? width * 0.5 : width * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            spreadRadius: 0.4,
            blurRadius: 0.5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            iconSize: width * 0.1,
            borderRadius: BorderRadius.circular(5),
            value: selectItem,
            isExpanded: true,
            elevation: 2,
            items: item.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Row(
                  children: [
                    SizedBox(width: width * 0.08),
                    AutoText(
                      text: item.toString(),
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) async {
              setState(() {
                selectItem = v.toString();
              });
            }),
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
                text: '${sum_price} ฿',
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildButtonOrderNow() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.02),
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
            onPressed: () {
              if (selectItem == null || selectItem == '') {
                Toast_Custom("Please Choose Payment", Colors.grey);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PayScreen(
                        pay_type: selectItem,
                        cartList: cartList,
                      );
                    },
                  ),
                ).then((value) {
                  get_cart();
                });
              }
            },
            child: Center(
              child: AutoText(
                color: Colors.white,
                fontSize: 14,
                text: 'Order Now',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
