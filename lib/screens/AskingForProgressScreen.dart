import 'package:flutter/material.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'LoginScreen.dart';

class AskingForProgressScreen extends StatefulWidget {
  @override
  _AskingForProgressScreenState createState() =>
      _AskingForProgressScreenState();
}

class _AskingForProgressScreenState extends State<AskingForProgressScreen> {
  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.askingForProgressEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          body()
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        SizedBox(
          height: kToolbarHeight * 2,
        ),
        Image.asset(AppAssets.askingForProgress),
        // SvgPicture.asset(AppAssets.askingForProgress),
        SizedBox(
          height: 32,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Utility.button(
            context,
            gradientColor1: AppColors.buttonGradient1,
            gradientColor2: AppColors.buttonGradient2,
            onPressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                  (Route<dynamic> route) => false);
            },
            text: "Sign Up",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "to unlock all quizzes and track \nyour progress",
          style: TextStyle(
            color: AppColors.appColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
