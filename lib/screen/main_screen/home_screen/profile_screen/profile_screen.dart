// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/screen/login_system/login_screen.dart';
import 'package:barg_user_app/screen/main_screen/favorite_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/address_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/edit_proflile_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/show_big_img.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List userList = [];

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return LoginScreen();
    }));
  }

  get_user() async {
    String? user_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_user/$user_id"));
    var data = json.decode(response.body);
    setState(() {
      userList = data;
    });
  }

  @override
  void initState() {
    get_user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: AutoText(
          text: "Profile",
          fontSize: 16,
          color: Colors.black,
          fontWeight: null,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return EditProfileScreen(
                      user_id: '${userList[0]['user_id']}',
                      firstname: "${userList[0]['first_name']}",
                      lastname: '${userList[0]['last_name']}',
                      email: '${userList[0]['email']}',
                      phone: '${userList[0]['phone']}',
                      img: '${userList[0]['user_image']}');
                }));
              },
              icon: Icon(
                Icons.edit,
                size: 18,
              ))
        ],
      ),
      backgroundColor: Colors.white,
      body: userList.isEmpty
          ? Center(
              child: CircularProgressIndicator(
              color: blue,
            ))
          : Container(
              width: width,
              height: height,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.04),
                    buildProfile(),
                    buildName(),
                    SizedBox(height: height * 0.03),
                    buildList("My Address"),
                    buildList("Favorite"),
                    buildList("Report"),
                    buildList("Logout"),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildProfile() {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: get_user(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return userList[0]['user_image'] == ""
            ? CircleAvatar(
                radius: width * 0.17,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: width * 0.17,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ShowBigImg(img: userList[0]['user_image']);
                      },
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: width * 0.17,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: width * 0.155,
                    backgroundImage: NetworkImage(
                      "$path_img/users/${userList[0]['user_image']}",
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget buildName() {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.015),
      child: Column(
        children: [
          AutoText(
            text: "${userList[0]['first_name']} ${userList[0]['last_name']}",
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          AutoText(
              text: "${userList[0]['email']}",
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget buildList(String? text) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (text == "Logout") {
          showdialogLogout();
        } else if (text == "My Address") {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddressScreen();
          }));
        } else if (text == "Favorite") {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return FavariteScreen();
          }));
        }
      },
      child: Container(
        height: height * 0.07,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 0.1,
              spreadRadius: 0.5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: width * 0.07),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoText(
              text: "$text",
              fontSize: 16,
              color: Colors.black,
              fontWeight: null,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade600,
              size: 17,
            )
          ],
        ),
      ),
    );
  }

  showdialogLogout() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Center(
            child: Text(
          "Do you want Logout?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    logout();
                  },
                  child: Text('yes'),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.red,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('no'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
