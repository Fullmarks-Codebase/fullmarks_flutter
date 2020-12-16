import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/QuizResult.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

import 'HomeScreen.dart';

class TestResultScreen extends StatefulWidget {
  String title;
  TestResultScreen({
    @required this.title,
  });
  @override
  _TestResultScreenState createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  bool isProgress = true;

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
          text: "Test Result",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isBack: false,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                myProgressView(),
                Spacer(),
                Utility.button(
                  context,
                  gradientColor1: AppColors.buttonGradient1,
                  gradientColor2: AppColors.buttonGradient2,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => QuizResult(),
                      ),
                    );
                  },
                  text: "View Solution",
                ),
                SizedBox(
                  height: 16,
                ),
                Utility.button(
                  context,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen(),
                        ),
                        (Route<dynamic> route) => false);
                  },
                  text: "Back to Home",
                  textcolor: AppColors.appColor,
                  borderColor: AppColors.appColor,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget myProgressView() {
    return GestureDetector(
      onTap: () {
        if (mounted)
          setState(() {
            isProgress = !isProgress;
          });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.chartBgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(8),
        child: isProgress ? progressView() : noProgressView(),
      ),
    );
  }

  Widget noProgressView() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SvgPicture.asset(AppAssets.sad),
          SizedBox(
            height: 8,
          ),
          Text(
            "No progress found",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "give a test to see progress",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget progressView() {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: (MediaQuery.of(context).size.width / 2),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(AppAssets.calculatorWhite),
                    PieChart(
                      PieChartData(
                        pieTouchData:
                            PieTouchData(touchCallback: (pieTouchResponse) {
                          // click on pie
                          // setState(() {
                          //   if (pieTouchResponse.touchInput is FlLongPressEnd ||
                          //       pieTouchResponse.touchInput is FlPanEnd) {
                          //     touchedIndex = -1;
                          //   } else {
                          //     touchedIndex = pieTouchResponse.touchedSectionIndex;
                          //   }
                          // });
                        }),
                        startDegreeOffset: 0,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 10,
                        sections: Utility.showingSections(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Progress",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Utility.correctIncorrectView(
                    color: AppColors.myProgressCorrectcolor,
                    title: "Incorrect: 5",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.correctIncorrectView(
                    color: AppColors.myProgressIncorrectcolor,
                    title: "Correct: 120",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.averageView(
                    assetName: AppAssets.avgAccuracy,
                    title: "Avg. Accuracy = 82%",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.averageView(
                    assetName: AppAssets.avgTime,
                    title: "Avg. Time/Question = 1:15",
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        timeTakenView(),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget timeTakenView() {
    return Text.rich(
      TextSpan(
        text: "Time Taken : ",
        style: TextStyle(
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: "10:33",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
