// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoText extends StatefulWidget {
  String? text;
  Color? color;
  double? fontSize;

  FontWeight? fontWeight;
  AutoText(
      {required this.text,
      required this.fontSize,
      required this.color,
      required this.fontWeight});

  @override
  State<AutoText> createState() => _AutoTextState();
}

class _AutoTextState extends State<AutoText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: AutoSizeText(
        maxLines: 1,
        minFontSize: 1,
        "${widget.text}",
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }
}

class AutoText2 extends StatefulWidget {
  String? text;
  Color? color;
  double? fontSize;

  FontWeight? fontWeight;
  AutoText2(
      {required this.text,
      required this.fontSize,
      required this.color,
      required this.fontWeight});

  @override
  State<AutoText2> createState() => _AutoText2State();
}

class _AutoText2State extends State<AutoText2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      child: AutoSizeText(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        minFontSize: 12,
        "${widget.text}",
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }
}

class AutoText3 extends StatefulWidget {
  String? text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  AutoText3(
      {required this.text,
      required this.fontSize,
      required this.color,
      required this.fontWeight});

  @override
  State<AutoText3> createState() => _AutoText3State();
}

class _AutoText3State extends State<AutoText3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AutoSizeText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        minFontSize: 14,
        "${widget.text}",
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }
}
