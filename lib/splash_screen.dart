import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:barg_user_app/screen/main_screen/tab_screen.dart';
import 'package:barg_user_app/screen/login_system/login_screen.dart';
import 'package:page_transition/page_transition.dart'; // อย่าลืมตัวนี้
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? user_id;
  String? store_id;
  get_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    print(user_id);
  }

  @override
  void initState() {
    get_user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: SizedBox(
            width: 1000,
            height: 1000,
            child: Image.asset("assets/images/logo.png")),
      ),
      nextScreen:
          user_id == null || user_id == '' ? LoginScreen() : TabScreen(),
      splashIconSize: 250,
      backgroundColor: Color(0xff85BFF4),
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.topToBottom,
    );
  }
}
