import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: AutoText(
            color: Colors.black,
            fontSize: 16,
            fontWeight: null,
            text: 'Order History',
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
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
              TabBar(
                  labelStyle: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: blue,
                      fontSize: 16,
                    ),
                  ),
                  unselectedLabelColor: Colors.grey,
                  labelColor: blue,
                  tabs: [
                    Tab(
                      text: "Delivling",
                    ),
                    Tab(
                      text: "Completed",
                    ),
                    Tab(
                      text: "Cancel",
                    )
                  ]),
              Expanded(
                child: Container(
                  height: height,
                  child: TabBarView(children: [
                    buildDelivering(),
                    Text("data"),
                    Text("data")
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDelivering() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 1),
          padding: EdgeInsets.symmetric(
              vertical: height * 0.015, horizontal: width * 0.07),
          width: width,
          height: height * 0.12,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 0.1,
                spreadRadius: 0.1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoText(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: null,
                    text: '12/12/2565 , 21:10:43',
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.005,
                            vertical: height * 0.003),
                        child: Image.asset(
                          "assets/images/location.png",
                          width: width * 0.04,
                          height: height * 0.02,
                          color: Colors.red,
                        ),
                      ),
                      AutoText(
                        color: Colors.grey.shade800,
                        fontSize: 12,
                        fontWeight: null,
                        text: 'ก๋วยเตี๋ยวเรือรังสิต',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.005,
                            vertical: height * 0.003),
                        child: Image.asset(
                          "assets/images/location.png",
                          width: width * 0.04,
                          height: height * 0.02,
                          color: blue,
                        ),
                      ),
                      AutoText(
                        color: Colors.grey.shade800,
                        fontSize: 12,
                        fontWeight: null,
                        text: '555/4 pk apratment...',
                      ),
                    ],
                  ),
                  AutoText(
                    color: blue,
                    fontSize: 12,
                    fontWeight: null,
                    text: 'Delivering',
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AutoText(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: null,
                    text: '฿220',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
