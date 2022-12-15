import 'package:barg_user_app/widget/auto_size_text.dart';
import 'package:barg_user_app/widget/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateStarScreen extends StatefulWidget {
  RateStarScreen({Key? key}) : super(key: key);

  @override
  State<RateStarScreen> createState() => _RateStarScreenState();
}

class _RateStarScreenState extends State<RateStarScreen> {
  double? star;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.2,
        backgroundColor: Colors.white,
        title: AutoText(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          text: 'Rate',
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.05),
              child: CircleAvatar(
                radius: width * 0.2,
                backgroundColor: Colors.grey,
              ),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: blue,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  star = rating;
                });
                print(star);
              },
            ),
          ],
        ),
      ),
    );
  }
}
