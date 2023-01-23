import 'dart:convert';
import 'dart:math';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/add_address_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/store/menu_screen.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController search = TextEditingController();
  List distanceList = [];
  List rateList = [];
  List storeList = [];
  List userList = [];
  List delivery_feeList = [];
  List addressList = [];
  double distance = 0;
  double? _lat;
  double? _long;
  String? user_id;

  search_store() async {
    final response = await http.post(
      Uri.parse('$ipcon/search_store'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "data": search.text,
      }),
    );
    var data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
  }

  get_rate_store(index, String? store_id) async {
    final response =
        await http.get(Uri.parse("$ipcon/sum_rate_store/$store_id"));
    var data = json.decode(response.body);
    if (storeList.isNotEmpty) {
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
  }

  calculateDistance(index, double lat, double long) async {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat - _lat!) * p) / 2 +
        c(_lat! * p) * c(lat * p) * (1 - c((_long! - long) * p)) / 2;

    distance = double.parse((12742 * asin(sqrt(a))).toStringAsFixed(1));

    if (storeList.isNotEmpty) {
      double delivery_fee = distance * 5;

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
  }

  get_address_default() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/get_address_default/$user_id"));
    var data = await json.decode(response.body);
    setState(() {
      addressList = data;
    });

    if (addressList[0]['item'] == "not have address") {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return AddAddressScreen();
      }));
    } else {
      _lat = double.parse(addressList[0]['latitude'].toString());
      _long = double.parse(addressList[0]['longtitude'].toString());
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // simple as that!
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              Expanded(
                child: TextField(
                  onChanged: (e) {
                    setState(() {
                      distanceList = [];
                      rateList = [];
                      distanceList = [];
                    });
                    search_store();
                  },
                  controller: search,
                  cursorColor: Colors.black,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: "Search",
                    hintStyle: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.black38,
                        fontSize: 16,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.013),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [buildStoreList()],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStoreList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return storeList.isEmpty
        ? SizedBox()
        : storeList[0]['item'] == "not have store"
            ? SizedBox()
            : SizedBox(
                height: height,
                child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.05, horizontal: width * 0.04),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.76,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemCount: storeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      get_rate_store(
                          index, storeList[index]['store_id'].toString());
                      calculateDistance(
                          index,
                          double.parse(
                              storeList[index]['store_lat'].toString()),
                          double.parse(
                              storeList[index]['store_long'].toString()));
                      return rateList.length != storeList.length
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                if (delivery_feeList.isNotEmpty &&
                                    distanceList.isNotEmpty) {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return MenuScreen(
                                      store_id:
                                          '${storeList[index]['store_id']}',
                                      store_image:
                                          '${storeList[index]['store_image']}',
                                      store_name:
                                          '${storeList[index]['store_name']}',
                                      delivery_fee:
                                          '${delivery_feeList[index]}',
                                      distance: '${distanceList[index]}',
                                      star: '${rateList[index]}',
                                    );
                                  }));
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: width * 0.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 3,
                                      spreadRadius: 3,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: height * 0.19,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              '$path_img/store/${storeList[index]['store_image']}'),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoText2(
                                        text:
                                            "${storeList[index]['store_name']}",
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                            "assets/images/fast-delivery.png",
                                            width: width * 0.04,
                                            height: height * 0.025,
                                            color: Colors.grey.shade600,
                                          ),
                                          delivery_feeList.isEmpty
                                              ? AutoText(
                                                  text: "...",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: null,
                                                )
                                              : AutoText(
                                                  text:
                                                      "${delivery_feeList[index]} ฿",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: null,
                                                ),
                                          Container(
                                            width: 1,
                                            height: 15,
                                            color: Colors.grey.shade500,
                                          ),
                                          distanceList.isEmpty
                                              ? AutoText(
                                                  text: "...",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: null,
                                                )
                                              : distanceList[index] == null ||
                                                      distanceList[index] == ''
                                                  ? Text("")
                                                  : AutoText(
                                                      text:
                                                          "${distanceList[index]} km",
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontWeight: null,
                                                    ),
                                          Container(
                                            width: 1,
                                            height: 15,
                                            color: Colors.grey.shade500,
                                          ),
                                          Image.asset(
                                            "assets/images/star.png",
                                            width: width * 0.03,
                                            height: height * 0.02,
                                            color: Colors.yellow.shade800,
                                          ),
                                          rateList.isEmpty
                                              ? AutoText(
                                                  text: "...",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: null,
                                                )
                                              : AutoText(
                                                  text: "${rateList[index]}",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade500,
                                                  fontWeight: null,
                                                ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                    }),
              );
  }
}
