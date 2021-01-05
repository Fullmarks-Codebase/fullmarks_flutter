import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/WaitingForHostScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class JoinQuizScreen extends StatefulWidget {
  @override
  _JoinQuizScreenState createState() => _JoinQuizScreenState();
}

class _JoinQuizScreenState extends State<JoinQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.mockTestBg),
          Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                AppAssets.bottomBarbg,
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "",
          isHome: false,
        ),
        Spacer(),
        Text(
          "Join Quiz",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            "139829",
            style: TextStyle(
              color: AppColors.appColor,
              fontSize: 30,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Utility.button(
            context,
            onPressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WaitingForHostScreen(),
                ),
              );
            },
            text: "Enter",
            bgColor: AppColors.myProgressCorrectcolor,
            isSufix: true,
            assetName: AppAssets.enter,
            isSpacer: true,
          ),
        ),
        Spacer(),
        Spacer(),
      ],
    );
  }
}
