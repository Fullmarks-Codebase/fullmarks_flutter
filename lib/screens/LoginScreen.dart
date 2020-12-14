import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullmarks/screens/IntroSliderScreen.dart';
import 'package:fullmarks/screens/VerificationScreen.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        SvgPicture.asset(
          AppAssets.topbarBg1,
          width: MediaQuery.of(context).size.width,
        ),
        Spacer(),
        SvgPicture.asset(AppAssets.loginLogo),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Enter your mobile phone",
              suffixIcon: Icon(Icons.phone_android),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Utility.button(
            context,
            gradientColor1: AppColors.buttonGradient1,
            gradientColor2: AppColors.buttonGradient2,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => VerificationScreen(),
              ));
            },
            text: "Verify",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text("Or Get started with"),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Utility.button(
                  context,
                  bgColor: AppColors.fbColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => VerificationScreen(),
                    ));
                  },
                  assetName: AppAssets.facebook,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Utility.button(
                  context,
                  bgColor: AppColors.googleColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => VerificationScreen(),
                    ));
                  },
                  assetName: AppAssets.google,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Utility.button(
              context,
              bgColor: AppColors.strongCyan,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => IntroSliderScreen(),
                ));
              },
              text: "Skip This Step",
            ),
          ),
        )
      ],
    );
  }
}
