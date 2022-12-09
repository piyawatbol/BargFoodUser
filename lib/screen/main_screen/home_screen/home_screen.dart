import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/profile_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/store/menu_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/search_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 50,
              floating: true,
              title: Text("Barg Food"),
              centerTitle: false,
              backgroundColor: blue,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ProfileScreen();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/user.png',
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ];
        },
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.02),
                  width: width,
                  height: height * 0.08,
                  color: blue,
                ),
                Container(
                  child: buildList(),
                )
              ],
            ),
            buildSearch(),
          ],
        ),
      ),
    );
  }

  Widget buildSearch() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Positioned(
      top: height * 0.03,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return SearchScreen();
          }));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.02),
          width: width * 0.85,
          height: height * 0.06,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                spreadRadius: 1,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoText(
                  text: "search",
                  fontSize: 16,
                  color: Colors.grey.shade400,
                  fontWeight: null,
                ),
                Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              vertical: height * 0.05, horizontal: width * 0.04),
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.75,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return MenuScreen();
                }));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.19,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/test1.jpg'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoText2(
                        text: "ก๋วยเตี๋ยวเรืออยุทยา",
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/images/fast-delivery.png",
                            width: width * 0.04,
                            height: height * 0.025,
                            color: Colors.grey.shade600,
                          ),
                          AutoText(
                            text: "32 ฿",
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: null,
                          ),
                          Container(
                            width: 1,
                            height: 15,
                            color: Colors.grey.shade500,
                          ),
                          AutoText(
                            text: "5.2 km",
                            fontSize: 14,
                            color: Colors.grey.shade500,
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
                          AutoText(
                            text: "4.7",
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
