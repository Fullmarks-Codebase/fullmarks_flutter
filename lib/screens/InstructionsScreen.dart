import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/TestScreen.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class InstructionsScreen extends StatefulWidget {
  String subtopicName;
  String subjectName;
  String setName;
  InstructionsScreen({
    @required this.subtopicName,
    @required this.subjectName,
    @required this.setName,
  });
  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
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
          text: "Instruction",
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              backgroundAndButton(),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    instructionView1(),
                    SizedBox(
                      height: 40,
                    ),
                    instructionView2(),
                    SizedBox(
                      height: 40,
                    ),
                    instructionView3(),
                    SizedBox(
                      height: 130,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SvgPicture.asset(
          AppAssets.bottomBarbg,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }

  Widget instructionView3() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(
          right: 60,
        ),
        decoration: BoxDecoration(
          color: AppColors.instructionsColor3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(90),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Image.asset(AppAssets.instruction3),
            ),
            Spacer(),
            Expanded(
              flex: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  roundedView(AppColors.introColor4, "Skip a Question"),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "If you want",
                    style: TextStyle(
                      color: AppColors.introColor4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget instructionView2() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(
          left: 60,
        ),
        decoration: BoxDecoration(
          color: AppColors.instructionsColor2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(90),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  roundedView(AppColors.strongCyan, "No time"),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Limit",
                    style: TextStyle(
                      color: AppColors.strongCyan,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Image.asset(AppAssets.instruction2),
            ),
          ],
        ),
      ),
    );
  }

  Widget instructionView1() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.instructionsColor1,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(90),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(
          right: 60,
        ),
        child: Row(
          children: [
            Expanded(
              child: Image.asset(AppAssets.instruction1),
            ),
            Expanded(
              child: Row(
                children: [
                  roundedView(AppColors.appColor, "10"),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Question",
                    style: TextStyle(
                      color: AppColors.appColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget backgroundAndButton() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              AppAssets.journeyLine,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Utility.button(
            context,
            gradientColor1: AppColors.buttonGradient1,
            gradientColor2: AppColors.buttonGradient2,
            onPressed: () {
              showStartQuizDialog();
            },
            text: "Start Quiz",
          ),
        )
      ],
    );
  }

  showStartQuizDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do you want to start Quiz?",
                style: TextStyle(
                  color: AppColors.appColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                gradientColor1: AppColors.buttonGradient1,
                gradientColor2: AppColors.buttonGradient2,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TestScreen(
                      subtopicName: widget.subtopicName,
                      subjectName: widget.subjectName,
                      setName: widget.setName,
                    ),
                  ));
                },
                text: "Start",
                assetName: AppAssets.play,
                isPrefix: true,
              ),
              SizedBox(
                height: 8,
              ),
              Utility.button(
                context,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Cancel",
                textcolor: AppColors.appColor,
                borderColor: AppColors.appColor,
              )
            ],
          ),
        );
      },
    );
  }

  Widget roundedView(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
