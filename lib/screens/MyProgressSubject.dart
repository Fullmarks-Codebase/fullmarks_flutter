import 'package:flutter/material.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class MyProgressSubject extends StatefulWidget {
  String title;
  MyProgressSubject({
    @required this.title,
  });
  @override
  _MyProgressSubjectState createState() => _MyProgressSubjectState();
}

class _MyProgressSubjectState extends State<MyProgressSubject> {
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
          text: widget.title,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        myProgressSubjectList(),
      ],
    );
  }

  Widget myProgressSubjectList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return myProgressSubjectItemView(index);
        },
      ),
    );
  }

  Widget myProgressSubjectItemView(int index) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.subtopicItemBorderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Algebra",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Set " + (index + 1).toString(),
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              width: 0.5,
            ),
            Expanded(
              flex: 30,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                          child: Utility.pieChart(),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Utility.correctIncorrectView(
                              color: AppColors.myProgressCorrectcolor,
                              title: "Incorrect: 5",
                              fontSize: 16,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Utility.correctIncorrectView(
                              color: AppColors.myProgressIncorrectcolor,
                              title: "Correct: 120",
                              fontSize: 16,
                            ),
                          ],
                        )
                      ],
                    ),
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
      ),
    );
  }
}
