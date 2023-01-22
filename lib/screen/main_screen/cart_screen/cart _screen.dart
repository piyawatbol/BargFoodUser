import 'dart:convert';
import 'dart:math';
import 'package:barg_user_app/screen/main_screen/cart_screen/edit_menu_screen.dart';
import 'package:barg_user_app/screen/main_screen/cart_screen/pay_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/address_screen.dart';
import 'package:barg_user_app/widget/loadingPage.dart';
import 'package:barg_user_app/widget/toast_custom.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  List storeList = [];
  int sum_price = 0;
  String? selectItem;
  double? distance;
  double? delivery_fee;
  double? total;
  bool statusLoading = false;
  List foodList = [];
  int amount = 1;
  List addressList = [];
  List buyerList = [];
  List item1 = [];
  double? _lat;
  double? _long;
  List walletList = [];
  int? wallet_id;

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
      get_store_one(cartList[0]['store_id']);
      for (var i = 0; i < cartList.length; i++) {
        sum_price = sum_price + int.parse(cartList[i]['price'].toString());
      }
    }
  }

  get_store_one(store_id) async {
    final response =
        await http.get(Uri.parse("$ipcon/get_store_one/$store_id"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        storeList = data;
      });
    }
    calculateDistance(double.parse(storeList[0]['store_lat'].toString()),
        double.parse(storeList[0]['store_long'].toString()));
  }

  calculateDistance(double lat, double long) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat - _lat!) * p) / 2 +
        c(_lat! * p) * c(lat * p) * (1 - c((_long! - long) * p)) / 2;

    distance = double.parse((12742 * asin(sqrt(a))).toStringAsFixed(1));

    setState(() {
      delivery_fee = distance! * 5;
      total = sum_price + delivery_fee!;
    });
  }

  get_cart_one(String? cart_id) async {
    setState(() {
      statusLoading = true;
    });
    final response = await http.get(Uri.parse("$ipcon/get_cart_one/$cart_id"));
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
        foodList = data;
      });
    }
  }

  delete_cart_one(String? cart_id) async {
    setState(() {
      statusLoading = true;
    });
    final response =
        await http.delete(Uri.parse("$ipcon/delete_cart_one/$cart_id"));
    // var data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
    }
    Navigator.pop(context);
    get_cart();
  }

  get_address_default() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/get_address_default/$user_id"));
    var data = json.decode(response.body);
    setState(() {
      addressList = data;
      _lat = double.parse(addressList[0]['latitude']);
      _long = double.parse(addressList[0]['longtitude']);
    });
    get_cart();
  }

  get_buyer() async {
    final response = await http.get(Uri.parse("$ipcon/get_buyer"));
    var data = json.decode(response.body);
    setState(() {
      buyerList = data;
    });

    for (var i = 0; i < buyerList.length; i++) {
      item1.add(buyerList[i]['buyer_name']);
    }
  }

  pay_wallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.patch(
      Uri.parse('$ipcon/pay_wallet/$user_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "wallet_id": wallet_id.toString(),
        "wallet_amount": total.toString(),
        "wallet_total": walletList[0]['wallet_total'].toString(),
      }),
    );
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      if (data == "pay wallet Success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PayScreen(
                pay_type: selectItem,
                cartList: cartList,
                delivery_fee: delivery_fee,
                total: total,
                sum_price: sum_price,
                buyer_name: selectItem,
              );
            },
          ),
        ).then((value) {
          get_cart();
        });
      } else if (data == "The amount in the wallet is insufficient") {
        Toast_Custom(data, Colors.red);
      }
    }
  }

  get_wallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_wallet/$user_id"));
    var data = json.decode(response.body);
    setState(() {
      walletList = data;
    });
    wallet_id = walletList[0]['wallet_id'];
  }

  @override
  void initState() {
    get_buyer();
    get_wallet();
    get_address_default();
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
              child: CircularProgressIndicator(
                color: blue,
              ),
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
              : Stack(
                  children: [
                    Container(
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
                              margin:
                                  EdgeInsets.symmetric(vertical: height * 0.01),
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
                    LoadingPage(statusLoading: statusLoading)
                  ],
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return AddressScreen();
        }));
      },
      child: Container(
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
              text:
                  '${addressList[0]['address_detail']} ${addressList[0]['house_number']} ${addressList[0]['county']} ',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10),
      width: width,
      height: height * 0.1,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: blue,
              ),
              SizedBox(width: width * 0.02),
              AutoText(
                color: Colors.black,
                fontSize: 14,
                fontWeight: null,
                text: '${addressList[0]['name']}',
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Row(
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
                text: '${addressList[0]['phone']}',
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
        itemCount: cartList.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            endActionPane: ActionPane(
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  foregroundColor: Colors.white,
                  backgroundColor: blue,
                  icon: Icons.edit,
                  label: 'edit',
                  onPressed: (context) async {
                    await get_cart_one(cartList[index]['cart_id'].toString());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return EditMenuScreen(
                        food_image: "${foodList[0]['food_image']}",
                        food_name: "${foodList[0]['food_name']}",
                        food_id: "${foodList[0]['food_id']}",
                        store_id: "${foodList[0]['store_id']}",
                        price: "${foodList[0]['price']}",
                        amount: int.parse(cartList[index]['amount'].toString()),
                        detaill: '${cartList[index]['detail']}',
                        cart_id: '${cartList[index]['cart_id']}',
                      );
                    })).then((value) => get_cart());
                  },
                ),
                SlidableAction(
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'delete',
                  onPressed: (context) {
                    _showModalBottomSheet(
                        cartList[index]['cart_id'].toString());
                  },
                )
              ],
            ),
            child:
                LayoutBuilder(builder: (contextFromLayoutBuilder, constraints) {
              return GestureDetector(
                onTap: () {
                  final slidable = Slidable.of(contextFromLayoutBuilder);
                  slidable?.openEndActionPane(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.decelerate,
                  );
                },
                child: Container(
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
                ),
              );
            }),
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
            items: item1.map((item) {
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
                fontSize: 16,
                fontWeight: FontWeight.w500,
                text: 'Subtotal',
              ),
              AutoText(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                text: '$sum_price ฿',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoText(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                text: 'delivery fee',
              ),
              AutoText(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                text: '$delivery_fee ฿',
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoText(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                text: 'Total',
              ),
              total == null
                  ? Text("...")
                  : AutoText(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      text: '$total ฿',
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
                if (selectItem == "Wallet") {
                  pay_wallet();
                } else if (selectItem == "Pay On Delivery") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return PayScreen(
                          pay_type: selectItem,
                          cartList: cartList,
                          delivery_fee: delivery_fee,
                          total: total,
                          sum_price: sum_price,
                          buyer_name: selectItem,
                        );
                      },
                    ),
                  ).then((value) {
                    get_cart();
                  });
                }
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

  Widget buildButtonOk(String? cart_id) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.01),
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
              setState(() {
                statusLoading = true;
              });
              delete_cart_one(cart_id);
            },
            child: Center(
              child: AutoText(
                color: Colors.white,
                fontSize: 14,
                text: 'Ok',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButtonCancel() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.9,
          height: height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.black, width: 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Center(
              child: AutoText(
                color: Colors.black,
                fontSize: 14,
                text: 'Cancel',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showModalBottomSheet(String cart_id) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          width: width,
          height: height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AutoText(
                color: Colors.black,
                fontSize: 16,
                text: 'Do you want to delete?',
                fontWeight: FontWeight.bold,
              ),
              Column(
                children: [
                  buildButtonOk(cart_id),
                  buildButtonCancel(),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
