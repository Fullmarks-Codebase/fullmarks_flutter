import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/utiity.dart';

import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "Unknown";

  @override
  void initState() {
    super.initState();
    getPackageInfo();
    Timer(Duration(seconds: 3), gotoHome);
  }

  gotoHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  getPackageInfo() {
    Utility.getPackageInfo().then((value) {
      if (mounted)
        setState(() {
          version = value.version;
        });
    });
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
              child: Text("App Version " + version),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        )
      ],
    );
  }
}
