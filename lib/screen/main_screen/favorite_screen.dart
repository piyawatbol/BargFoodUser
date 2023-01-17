import 'dart:convert';
import 'dart:math';
import 'package:barg_user_app/screen/main_screen/home_screen/store/menu_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavariteScreen extends StatefulWidget {
  @override
  State<FavariteScreen> createState() => FavoriteScreen();
}

class FavoriteScreen extends State<FavariteScreen> {
  List storeList = [];
  String? user_id;
  List distanceList = [];
  Position? userLocation;
  double? distance;
  List delivery_feeList = [];
  List rateList = [];
  double? _lat;
  double? _long;
  List addressList = [];

  get_fav() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_favorite/$user_id"));
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
    for (var i = 0; i < storeList.length; i++) {
      sum_rate_store(i, storeList[i]['store_id'].toString());
    }
    for (var i = 0; i < storeList.length; i++) {
      calculateDistance(i, double.parse(storeList[i]['store_lat'].toString()),
          double.parse(storeList[i]['store_long'].toString()));
    }
  }

  calculateDistance(index, double lat, double long) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat - _lat!) * p) / 2 +
        c(_lat! * p) * c(lat * p) * (1 - c((_long! - long) * p)) / 2;

    distance = double.parse((12742 * asin(sqrt(a))).toStringAsFixed(1));

    double delivery_fee = distance! * 5;

    if (distanceList.length >= storeList.length) {
      distanceList[index] = distance;
    } else {
      distanceList.add(distance);
    }

    if (delivery_feeList.length >= storeList.length) {
      distanceList[index] = distance;
    } else {
      delivery_feeList.add(delivery_fee);
    }
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
    get_fav();
  }

  sum_rate_store(index, String? store_id) async {
    final response =
        await http.get(Uri.parse("$ipcon/sum_rate_store/$store_id"));
    var data = json.decode(response.body);

    if (this.mounted) {
      setState(() {
        if (rateList.length >= storeList.length) {
          if (data != null) {
            double rate = double.parse(data.toString());
            rateList[index] = rate.toStringAsFixed(1);
          } else {
            rateList[index] = '0';
          }
        } else {
          if (data != null) {
            double rate = double.parse(data.toString());
            rateList.add(rate.toStringAsFixed(1));
          } else {
            rateList.add('0');
          }
        }
      });
    }
  }

  @override
  void initState() {
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
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Favorite',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: storeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : storeList[0]['store_name'] == null
              ? Container()
              : Container(
                  width: width,
                  height: height,
                  child: Column(
                    children: [buildListFav()],
                  ),
                ),
    );
  }

  Widget buildListFav() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: ListView.builder(
        itemCount: storeList.length,
        itemBuilder: (BuildContext context, int index) {
          return rateList.length != storeList.length
              ? Container()
              : GestureDetector(
                  onTap: () {
                    if (delivery_feeList.isNotEmpty &&
                        distanceList.isNotEmpty) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MenuScreen(
                            store_id: '${storeList[index]['store_id']}',
                            store_image: '${storeList[index]['store_image']}',
                            store_name: '${storeList[index]['store_name']}',
                            delivery_fee: '${delivery_feeList[index]}',
                            distance: '${distanceList[index]}',
                            star: "${rateList[index]}");
                      })).then((value) => get_fav());
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 1),
                    width: width,
                    height: height * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 0.1,
                          spreadRadius: 0.1,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.02),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.25,
                            height: height * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "$path_img/store/${storeList[index]['store_image']}"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoText(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  text: '${storeList[index]['store_name']}',
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/star.png",
                                      width: width * 0.03,
                                      height: height * 0.02,
                                      color: Colors.yellow.shade800,
                                    ),
                                    SizedBox(width: width * 0.015),
                                    rateList.isEmpty
                                        ? Text("...")
                                        : AutoText(
                                            text: "${rateList[index]}",
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            fontWeight: null,
                                          ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/fast-delivery.png",
                                        width: width * 0.041,
                                        height: height * 0.025,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(width: 3),
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: blue,
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        child: delivery_feeList.isEmpty
                                            ? Text("...")
                                            : AutoText(
                                                text:
                                                    "${delivery_feeList[index]} ฿",
                                                fontSize: 11,
                                                color: Colors.white,
                                                fontWeight: null,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
