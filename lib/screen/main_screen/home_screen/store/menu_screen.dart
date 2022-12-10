// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:barg_user_app/widget/color.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/search_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/store/detail_store_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/store/menu_detail_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  String? store_id;
  String? store_image;
  String? store_name;
  MenuScreen(
      {required this.store_id,
      required this.store_image,
      required this.store_name});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List foodList = [];
  get_menu() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_menu_user/${widget.store_id}"));
    var data = json.decode(response.body);
    setState(() {
      foodList = data;
    });
  }

  @override
  void initState() {
    get_menu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [buildAppbar()];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHead(),
            Container(
              margin: EdgeInsets.symmetric(vertical: height * 0.01),
              height: 5,
              color: Colors.grey.shade100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.01, horizontal: width * 0.03),
              child: AutoText(
                text: "Menu",
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            buildListMenu()
          ],
        ),
      ),
    );
  }

  Widget buildAppbar() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      expandedHeight: height * 0.27,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: width * 0.05,
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: width * 0.05,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return SearchScreen();
                    }));
                  },
                ),
              ),
              SizedBox(width: width * 0.02),
              CircleAvatar(
                radius: width * 0.05,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DetailStoreScreen();
                    }));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          '$path_img/store/${widget.store_image}',
          fit: BoxFit.cover,
        ),
        stretchModes: [
          StretchMode.zoomBackground,
        ],
      ),
    );
  }

  Widget buildHead() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.02, left: width * 0.03),
          child: AutoText(
            text: "${widget.store_name}",
            fontSize: 20,
            color: Colors.black,
            fontWeight: null,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * 0.02),
          child: Row(
            children: [
              Image.asset(
                "assets/images/star.png",
                width: width * 0.055,
                height: height * 0.015,
                color: Colors.yellow.shade800,
              ),
              AutoText(
                text: "4.7",
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: null,
              ),
              Container(
                margin: EdgeInsets.all(5),
                width: 2,
                height: 2,
                color: Colors.grey.shade500,
              ),
              Image.asset(
                "assets/images/fast-delivery.png",
                width: width * 0.045,
                height: height * 0.025,
                color: Colors.grey.shade600,
              ),
              SizedBox(width: 3),
              AutoText(
                text: "32 ฿",
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: null,
              ),
              Container(
                margin: EdgeInsets.all(5),
                width: 2,
                height: 2,
                color: Colors.grey.shade600,
              ),
              AutoText(
                text: "5.2 km",
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListMenu() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: foodList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MenuDetailScreen(
                  food_image: '${foodList[index]['food_image']}',
                  food_name: '${foodList[index]['food_name']}',
                  food_id: '${foodList[index]['food_id']}',
                  store_id: '${widget.store_id}',
                  price: '${foodList[index]['price']}',
                );
              }));
            }),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.05),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              )),
              width: width,
              height: height * 0.14,
              child: Row(
                children: [
                  Container(
                    width: width * 0.24,
                    height: height * 0.11,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            '$path_img/food/${foodList[index]['food_image']}'),
                      ),
                    ),
                  ),
                  Container(
                    width: width * 0.66,
                    height: height * 0.09,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoText(
                                text: "${foodList[index]['food_name']}",
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: null,
                              ),
                              AutoText(
                                text: "${foodList[index]['price']} ฿",
                                fontSize: 15,
                                color: blue,
                                fontWeight: null,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              "assets/images/add.png",
                              width: width * 0.06,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
