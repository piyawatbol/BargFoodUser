import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/add_address_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/edit_address_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  get_address() {}
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        title: AutoText(
          text: "My Address",
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return EditAddressScreen();
                }));
              },
              child: Container(
                width: width,
                height: height * 0.085,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.01, horizontal: width * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.home_outlined,
                                color: blue,
                                size: 25,
                              ),
                              SizedBox(width: 5),
                              AutoText(
                                text: "555/4 pk apartment",
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: null,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.edit,
                            size: 18,
                            color: blue,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: width * 0.065),
                          AutoText(
                            text: "คลองจั่น บางกระปิ กรุงเทพมหานคร 10240",
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddAddressScreen();
          }));
        },
      ),
    );
  }
}
