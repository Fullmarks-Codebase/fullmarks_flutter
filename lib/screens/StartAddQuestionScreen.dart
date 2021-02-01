import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'AddQuestionScreen.dart';

class StartAddQuestionScreen extends StatefulWidget {
  @override
  _StartAddQuestionScreenState createState() => _StartAddQuestionScreenState();
}

class _StartAddQuestionScreenState extends State<StartAddQuestionScreen> {
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
          text: "Quiz Name",
          isHome: false,
          textColor: Colors.white,
        ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(48),
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(48),
            ),
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SvgPicture.asset(
                AppAssets.customQuizBg,
                color: AppColors.lightAppColor,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  SvgPicture.asset(AppAssets.customQuizBg2),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Utility.button(
                      context,
                      onPressed: () async {
                        //delay to give ripple effect
                        await Future.delayed(
                            Duration(milliseconds: AppStrings.delay));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuestionScreen(
                              isEdit: false,
                              questionDetails: null,
                              quizDetails: null,
                            ),
                          ),
                        );
                      },
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      gradientColor1: AppColors.buttonGradient1,
                      gradientColor2: AppColors.buttonGradient2,
                      text: "Start Add Your Question",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
