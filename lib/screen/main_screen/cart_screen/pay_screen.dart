// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:barg_user_app/screen/main_screen/cart_screen/status_screen/status_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayScreen extends StatefulWidget {
  List? cartList;
  String? pay_type;
  double? delivery_fee;
  int? sum_price;
  double? total;

  PayScreen(
      {required this.pay_type,
      required this.cartList,
      required this.delivery_fee,
      required this.sum_price,
      required this.total});
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  bool statusLoading = false;
  String? user_id;
  int? id;

  get_user_id() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
  }

  add_request() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    String order_id = DateFormat('yMdHms').format(DateTime.now());
    final response = await http.post(
      Uri.parse('$ipcon/add_request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id.toString(),
        "address_id": "1",
        "store_id": widget.cartList![0]['store_id'].toString(),
        "order_id": '$order_id',
        "status": "1",
        "sum_price": widget.sum_price.toString(),
        "delivery_fee": widget.delivery_fee.toString(),
        "total": widget.total.toString(),
      }),
    );
    if (response.statusCode == 200) {
      await get_request_id();
      add_order(order_id);
    }
  }

  add_order(order_id) async {
    for (var i = 0; i < widget.cartList!.length; i++) {
      await http.post(
        Uri.parse('$ipcon/add_order'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "order_id": order_id.toString(),
          "food_id": widget.cartList![i]['food_id'].toString(),
          "food_name": widget.cartList![i]['food_name'],
          "amount": widget.cartList![i]['amount'],
          "price": widget.cartList![i]['price'],
          "detail": widget.cartList![i]['detail'],
        }),
      );
    }
    delete_cart_all();
    setState(() {
      statusLoading = false;
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return StatusScreen(
        request_id: '$id',
      );
    }));
  }

  get_request_id() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_request_id/$user_id"));
    var data = json.decode(response.body);
    id = data[0]['request_id'];
    print(id);
  }

  delete_cart_all() async {
    await http.delete(Uri.parse("$ipcon/delete_cart_all/$user_id"));
  }

  @override
  void initState() {
    get_user_id();
    if (widget.pay_type == "Pay On Delivery") {
      setState(() {
        statusLoading = true;
      });
      add_request();
    }
    super.initState();
  }

  List cartList = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Pay',
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Column(
              children: [],
            ),
            LoadingPage(statusLoading: statusLoading)
          ],
        ),
      ),
    );
  }
}
