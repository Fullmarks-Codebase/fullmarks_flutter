import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/IntroSliderScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'ChangeGradeScreen.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _version = "Unknown";

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    Timer(Duration(seconds: 3), gotoHome);
  }

  gotoHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => getRoute(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Widget getRoute() {
    if (Utility.getCustomer() == null) {
      //if not login
      return LoginScreen();
    } else {
      //if login
      //check if class is not selected
      if (Utility.getCustomer().classGrades == null) {
        return ChangeGradeScreen(
          isFirstTime: true,
        );
      } else {
        if (PreferenceUtils.getBool(AppStrings.introSliderPreference)) {
          //if intro slider seen
          return HomeScreen();
        } else {
          //if intro slider not seen
          return IntroSliderScreen();
        }
      }
    }
  }

  getPackageInfo() async {
    Utility.getPackageInfo().then((value) {
      _version = value.version;
      _notify();
    });
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body(),
    );
  }

  Widget body() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Utility.setSvgFullScreen(context, AppAssets.splashBg),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            SvgPicture.asset(AppAssets.splashLogo),
            Spacer(),
            SvgPicture.asset(AppAssets.splashLogoName),
            Spacer(),
            SafeArea(
              child: Text("App Version " + _version),
            ),
            SizedBox(
              height: kBottomNavigationBarHeight,
            ),
          ],
        )
      ],
    );
  }
}
