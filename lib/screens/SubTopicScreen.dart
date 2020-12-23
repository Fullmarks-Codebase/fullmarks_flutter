import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/SetsScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class SubTopicScreen extends StatefulWidget {
  String subjectName;
  SubTopicScreen({
    @required this.subjectName,
  });
  @override
  _SubTopicScreenState createState() => _SubTopicScreenState();
}

class _SubTopicScreenState extends State<SubTopicScreen> {
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
          text: widget.subjectName,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                myProgressView(),
                SizedBox(
                  height: 16,
                ),
                subTopicList()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget subTopicList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(10, (index) {
          return subTopicItemView(index + 1);
        }),
      ),
    );
  }

  Widget subTopicItemView(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => SetsScreen(
            subtopicName: "Subtopic " + index.toString(),
            subjectName: widget.subjectName,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.subtopicItemColor,
          border: Border.all(
            color: AppColors.subtopicItemBorderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subtopic " + index.toString(),
                    style: TextStyle(
                      color: AppColors.subtopicItemBorderColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    (index * 10).toString() + "% Completed",
                    style: TextStyle(
                      color: AppColors.subtopicItemBorderColor,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.subtopicItemBorderColor,
              ),
              onPressed: null,
            ),
          ],
        ),
      ),
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
        margin: EdgeInsets.symmetric(horizontal: 16),
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
    return Row(
      children: [
        Expanded(
          child: Container(
            height: (MediaQuery.of(context).size.width / 2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(AppAssets.calculatorWhite),
                Utility.pieChart(),
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
    );
  }
}
