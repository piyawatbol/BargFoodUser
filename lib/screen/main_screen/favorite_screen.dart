import 'package:barg_user_app/screen/main_screen/home_screen/search_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';

class FavariteScreen extends StatefulWidget {
  @override
  State<FavariteScreen> createState() => FavoriteScreen();
}

class FavoriteScreen extends State<FavariteScreen> {
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return SearchScreen();
                }));
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //   return MenuScreen(store_id: '',);
                    // }));
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
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('assets/images/test1.jpg'))),
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
                                  text: 'ก๋วยเตี๋ยวเรือรังสิต',
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
                                    AutoText(
                                      text: "4.7",
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
                                        child: AutoText(
                                          text: "32฿",
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
            ))
          ],
        ),
      ),
    );
  }
}
