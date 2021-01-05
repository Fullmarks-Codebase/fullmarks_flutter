import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/MyProgressSubjectScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class MyProgressScreen extends StatefulWidget {
  @override
  _MyProgressScreenState createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
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
          text: "My Progress",
        ),
        myProgressList(),
      ],
    );
  }

  Widget myProgressList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return myProgressItemView(index);
        },
      ),
    );
  }

  Widget myProgressItemView(int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: index == 0
                ? AppColors.subtopicItemBorderColor
                : index == 1
                    ? AppColors.strongCyan
                    : index == 2
                        ? AppColors.strongCyan
                        : AppColors.introColor3,
            width: 2,
          ),
        ),
        color: index == 0
            ? AppColors.mathsColor
            : index == 1
                ? AppColors.scienceColor
                : index == 2
                    ? AppColors.ssColor
                    : AppColors.enColor,
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MyProgressSubjectScreen(
              title: index == 0
                  ? "Math"
                  : index == 1
                      ? "Science"
                      : index == 2
                          ? "Social Science"
                          : "English",
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      index == 0
                          ? AppAssets.math
                          : index == 1
                              ? AppAssets.sci
                              : index == 2
                                  ? AppAssets.ss
                                  : AppAssets.en,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      index == 0
                          ? "Math"
                          : index == 1
                              ? "Science"
                              : index == 2
                                  ? "Social Science"
                                  : "English",
                      style: TextStyle(
                        color: index == 0
                            ? AppColors.subtopicItemBorderColor
                            : index == 1
                                ? AppColors.strongCyan
                                : index == 2
                                    ? AppColors.strongCyan
                                    : AppColors.introColor3,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.width / 4.5),
                width: (MediaQuery.of(context).size.width / 4.5),
                child: Utility.pieChart(
                  values: index == 0
                      ? [75, 25]
                      : index == 1
                          ? [25, 75]
                          : index == 2
                              ? [50, 50]
                              : [10, 90],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
