import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(4, 131, 184, .1),
  100: Color.fromRGBO(4, 131, 184, .2),
  200: Color.fromRGBO(4, 131, 184, .3),
  300: Color.fromRGBO(4, 131, 184, .4),
  400: Color.fromRGBO(4, 131, 184, .5),
  500: Color.fromRGBO(4, 131, 184, .6),
  600: Color.fromRGBO(4, 131, 184, .7),
  700: Color.fromRGBO(4, 131, 184, .8),
  800: Color.fromRGBO(4, 131, 184, .9),
  900: Color.fromRGBO(4, 131, 184, 1),
};

class AppColors {
  static Color appColor = MaterialColor(0xff4276E3, color);
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color greyColor = Colors.black45;
  static Color background = Colors.grey[200];
  static Color fbColor = Color(0xff3B5998);
  static Color googleColor = Color(0xffDE5246);
  static Color strongCyan = Color(0xff00B894);

  //button gradient
  static Color buttonGradient1 = Color(0xff046BE4);
  static Color buttonGradient2 = Color(0xff5205F6);

  //inrto slider color
  static Color introColor1 = Color(0xff3490DC);
  static Color introColor2 = Color(0xff38C172);
  static Color introColor3 = Color(0xff6C5CE7);
  static Color introColor4 = Color(0xffE17055);
}