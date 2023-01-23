// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:barg_user_app/screen/main_screen/home_screen/store/menu_detail_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchMenuScreen extends StatefulWidget {
  String? store_id;
  SearchMenuScreen({required this.store_id});

  @override
  State<SearchMenuScreen> createState() => _SearchMenuScreenState();
}

class _SearchMenuScreenState extends State<SearchMenuScreen> {
  TextEditingController search = TextEditingController();
  List foodList = [];

  search_menu() async {
    final response = await http.post(
      Uri.parse('$ipcon/search_menu/${widget.store_id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "data": search.text,
      }),
    );
    var data = json.decode(response.body);
    setState(() {
      foodList = data;
    });
    print(foodList);
  }

  @override
  void initState() {
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
        appBar: buildAppbar(),
        body: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              buildListMenu(),
            ],
          ),
        ),
      ),
    );
  }

  buildAppbar() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AppBar(
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
              controller: search,
              onChanged: (e) {
                search_menu();
              },
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
    );
  }

  Widget buildListMenu() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return foodList.isEmpty
        ? SizedBox()
        : foodList[0]['item'] == "not have menu"
            ? SizedBox()
            : Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.04),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoText(
                                          text:
                                              "${foodList[index]['food_name']}",
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
