import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class PreviewQuestionScreen extends StatefulWidget {
  @override
  _PreviewQuestionScreenState createState() => _PreviewQuestionScreenState();
}

class _PreviewQuestionScreenState extends State<PreviewQuestionScreen> {
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
          text: "Preview",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
          textColor: Colors.white,
        ),
        timerView(),
        questionAnswerItemView(),
      ],
    );
  }

  Widget questionAnswerItemView() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          right: 16,
          left: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                right: 16,
                left: 16,
                top: 16,
              ),
              child: Text(
                "Question 1",
                style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Divider(
                thickness: 2,
              ),
            ),
            questionImageView(),
            questionText(),
            SizedBox(
              height: 16,
            ),
            answersView()
          ],
        ),
      ),
    );
  }

  Widget answersView() {
    return Column(
      children: List.generate(4, (index) {
        return textAnswerItemView(index);
      }),
    );
  }

  Widget textAnswerItemView(int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      alignment: Alignment.center,
      decoration: Utility.defaultAnswerDecoration(),
      child: Text(
        index == 0
            ? "(A) 123"
            : index == 1
                ? "(B) 456"
                : index == 2
                    ? "(C) 789"
                    : "(D) 0",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget questionImageView() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      child: Image.asset(
        AppAssets.dummyQuestionImage,
      ),
    );
  }

  Widget questionText() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: Text(
        "Which one of the following has maximum number of atoms?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget timerView() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.myProgressIncorrectcolor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.whiteClock,
              color: AppColors.appColor,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "30",
              style: TextStyle(
                color: AppColors.appColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
