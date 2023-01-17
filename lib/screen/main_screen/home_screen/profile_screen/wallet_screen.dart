import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'My Wallet',
          style: TextStyle(),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Text(
                    'ยอดเงินในวอลเล็ท',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '100 ฿',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.payment,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  Text("ถอน"),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: (() {}),
                    icon: Icon(
                      Icons.add_card,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  Text("เติมเงิน")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.autorenew,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  Text("โอน")
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.access_time,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  Text("รายการ")
                ],
              )
            ],
          ),
          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 15),
          Container(
            width: 170,
            height: 60,
            color: Colors.white,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 35,
                ),
              ),
              Text(
                'เพิ่มบัญชี',
                style: TextStyle(fontSize: 16),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
