import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barg_user_app/ipcon.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/add_address_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/profile_screen/address_screen/edit_address_screen.dart';
import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List addressList = [];
  String? user_id;

  get_address() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_address/$user_id"));
    var data = json.decode(response.body);
    setState(() {
      addressList = data;
    });
    print(addressList);
  }

  @override
  void initState() {
    get_address();
    super.initState();
  }

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
          children: [buildListAddress()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddAddressScreen();
          })).then((value) => get_address());
        },
      ),
    );
  }

  buildListAddress() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: ListView.builder(
        itemCount: addressList.length,
        itemBuilder: (BuildContext context, int index) {
          return addressList[0]['item'] == "not have address"
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return EditAddressScreen(
                        address_id:
                            '${addressList[index]['address_id'].toString()}',
                      );
                    })).then((value) => get_address());
                  },
                  child: Container(
                    width: width,
                    height: height * 0.13,
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
                                  SizedBox(width: width * 0.001),
                                  AutoText(
                                    text:
                                        "${addressList[index]['address_detail']} ",
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
                              SizedBox(width: width * 0.01),
                              Container(
                                width: width * 0.7,
                                child: AutoText3(
                                  text:
                                      "${addressList[index]['house_number']} ${addressList[index]['county']} ${addressList[index]['district']} ${addressList[index]['province']}  ${addressList[index]['zip_code']} ",
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: null,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: height * 0.004,
                                horizontal: width * 0.011),
                            width: addressList[index]['address_status_id'] == 1
                                ? width * 0.16
                                : addressList[index]['address_status_id'] == 2
                                    ? width * 0.3
                                    : width * 0.16,
                            height: height * 0.025,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: addressList[index]
                                                ['address_status_id'] ==
                                            1
                                        ? Colors.red
                                        : Colors.grey)),
                            child: Center(
                              child: AutoText(
                                text:
                                    "${addressList[index]['address_status_name']} ",
                                fontSize: 16,
                                color:
                                    addressList[index]['address_status_id'] == 1
                                        ? Colors.red
                                        : Colors.grey,
                                fontWeight: null,
                              ),
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
