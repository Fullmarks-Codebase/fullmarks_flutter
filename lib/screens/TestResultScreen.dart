import 'package:flutter/material.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/ReportsResponse.dart';
import 'package:fullmarks/models/SetsResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/SubtopicResponse.dart';
import 'package:fullmarks/screens/QuizResultScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'AskingForProgressScreen.dart';
import 'HomeScreen.dart';

class TestResultScreen extends StatefulWidget {
  List<QuestionDetails> questionsDetails;
  SubtopicDetails subtopic;
  SubjectDetails subject;
  SetDetails setDetails;
  ReportDetails reportDetails;
  String title;
  TestResultScreen({
    @required this.subtopic,
    @required this.setDetails,
    @required this.questionsDetails,
    @required this.subject,
    @required this.reportDetails,
    @required this.title,
  });
  @override
  _TestResultScreenState createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.testResultEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            Utility.setSvgFullScreen(context, AppAssets.commonBg),
            body(),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
            (Route<dynamic> route) => false) ??
        false;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Test Result",
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                widget.reportDetails?.correct == null ||
                        widget.reportDetails?.correct == "null"
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Utility.noUserProgressView(context),
                      )
                    : myProgressView(),
                Spacer(),
                Utility.button(
                  context,
                  gradientColor1: AppColors.buttonGradient1,
                  gradientColor2: AppColors.buttonGradient2,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));

                    if (widget.reportDetails?.correct == null ||
                        widget.reportDetails?.correct == "null") {
                      //if guest ask for login to view solution
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AskingForProgressScreen(),
                        ),
                      );
                    } else {
                      //if customer then view solution
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => QuizResultScreen(
                            questionsDetails: widget.questionsDetails,
                          ),
                        ),
                      );
                    }
                  },
                  text: "View Solution",
                ),
                SizedBox(
                  height: 16,
                ),
                Utility.button(
                  context,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
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

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget myProgressView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chartBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(8),
      child: progressView(),
    );
  }

  Widget progressView() {
    int totalMarks = 0;
    if (widget.title.length > 0) {
      int correct = int.tryParse(widget.reportDetails.correct) * 3;
      int incorrect = int.tryParse(widget.reportDetails.incorrect) * -1;
      totalMarks = correct + incorrect;
    }
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            widget.subject == null ||
                    widget.subject == null ||
                    widget.setDetails == null
                ? widget.title
                : widget.subject.name +
                    " / " +
                    widget.subtopic.name +
                    " / " +
                    widget.setDetails.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
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
                    widget.subject == null
                        ? Container()
                        : Container(
                            height: (MediaQuery.of(context).size.width / 2) / 3,
                            width: (MediaQuery.of(context).size.width / 2) / 3,
                            child: Utility.imageLoader(
                              baseUrl: AppStrings.subjectImage,
                              url: widget.subject.image,
                              placeholder: AppAssets.subjectPlaceholder,
                              fit: BoxFit.contain,
                            ),
                          ),
                    Utility.pieChart(
                      values: [
                        double.tryParse(widget.reportDetails.incorrect),
                        double.tryParse(widget.reportDetails.correct),
                        double.tryParse(widget.reportDetails.skipped),
                      ],
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
                    title: "Incorrect: " +
                        widget.reportDetails.incorrect.toString(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.correctIncorrectView(
                    color: AppColors.myProgressIncorrectcolor,
                    title:
                        "Correct: " + widget.reportDetails.correct.toString(),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.correctIncorrectView(
                    color: AppColors.wrongBorderColor,
                    title:
                        "Skipped: " + widget.reportDetails.skipped.toString(),
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
                    title: "Avg. Accuracy = " +
                        widget.reportDetails.accuracy.toString() +
                        "%",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.averageView(
                    assetName: AppAssets.avgTime,
                    title:
                        "Avg. Time/Question = " + widget.reportDetails.avgTime,
                  ),
                  widget.title.length == 0
                      ? Container()
                      : SizedBox(
                          height: 8,
                        ),
                  widget.title.length == 0
                      ? Container()
                      : Utility.averageView(
                          assetName: AppAssets.totalMarks,
                          title: "Total Marks = " +
                              totalMarks.toString() +
                              " / " +
                              (widget.questionsDetails.length * 3).toString(),
                        ),
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        widget.title.length == 0 ? timeTakenView() : Container(),
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
            text: Utility.getHMS(int.tryParse(widget.reportDetails.timeTaken)),
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
