import 'package:barg_user_app/screen/main_screen/cart_screen/cart%20_screen.dart';
import 'package:barg_user_app/screen/main_screen/favorite_screen.dart';
import 'package:barg_user_app/screen/main_screen/home_screen/home_screen.dart';
import 'package:barg_user_app/screen/main_screen/order_screen/orders_screen.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    OrdersScreen(),
    CartScreen(),
    FavariteScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        iconSize: 24,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/home.png"),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/clock.png"),
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/shopping-cart.png"),
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/heart.png"),
            ),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
