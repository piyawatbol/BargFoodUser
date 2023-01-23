// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:barg_user_app/screen/main_screen/home_screen/store/search_menu_screen.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:barg_user_app/widget/toast_custom.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/store/detail_store_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/store/menu_detail_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  String? store_id;
  String? store_image;
  String? store_name;
  String? star;
  String? delivery_fee;
  String? distance;
  MenuScreen(
      {required this.store_id,
      required this.store_image,
      required this.store_name,
      required this.delivery_fee,
      required this.distance,
      required this.star});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
 
  List foodList = [];
  bool fav = false;
  String? user_id;

 

  get_menu() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_menu_user/${widget.store_id}"));
    var data = json.decode(response.body);
    setState(() {
      foodList = data;
    });
  }

  check_favorite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http
        .get(Uri.parse("$ipcon/check_favorite/$user_id/${widget.store_id}"));
    var data = json.decode(response.body);
    if (data['message'] == "have") {
      setState(() {
        fav = true;
      });
    } else {
      setState(() {
        fav = false;
      });
    }
  }

  delete_favorite() async {
    final response = await http.delete(
        Uri.parse("$ipcon/delete_favorite/$user_id/${widget.store_id}"));
    if (response.statusCode == 200) {
      Toast_Custom("Delete Favorite", Colors.grey);
    }
  }

  add_favorite() async {
    final response = await http
        .get(Uri.parse("$ipcon/add_favorite/$user_id/${widget.store_id}"));
    if (response.statusCode == 200) {
      Toast_Custom("Add Favorite", Colors.grey);
    }
  }

  @override
  void initState() {
    get_menu();
    check_favorite();
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
                      return SearchMenuScreen(
                        store_id: widget.store_id.toString(),
                      );
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
                      return DetailStoreScreen(
                        store_id: '${widget.store_id}',
                      );
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
          padding: EdgeInsets.only(
              top: height * 0.02, left: width * 0.03, right: width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoText(
                text: "${widget.store_name}",
                fontSize: 20,
                color: Colors.black,
                fontWeight: null,
              ),
              GestureDetector(
                onTap: () {
                  if (fav == true) {
                    delete_favorite();
                  } else {
                    add_favorite();
                  }
                  setState(() {
                    fav = !fav;
                  });
                },
                child: fav == true
                    ? Image.asset(
                        "assets/images/heart_full.png",
                        width: width * 0.06,
                      )
                    : Image.asset(
                        "assets/images/heart.png",
                        width: width * 0.06,
                      ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * 0.02),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return DetailStoreScreen(
                            store_id: '${widget.store_id}');
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/star.png",
                      width: width * 0.055,
                      height: height * 0.015,
                      color: Colors.yellow.shade800,
                    ),
                    widget.star == 'null'
                        ? AutoText(
                            text: "no review",
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: null,
                          )
                        : AutoText(
                            text: "${widget.star}",
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: null,
                          ),
                  ],
                ),
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
                text: "${widget.delivery_fee} ฿",
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
                text: "${widget.distance} km",
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
