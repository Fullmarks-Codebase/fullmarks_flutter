import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'CreateQuizLobbyScreen.dart';

class ListQuizChooseTimeScreen extends StatefulWidget {
  bool isRandomQuiz;
  SubjectDetails subject;
  ListQuizChooseTimeScreen({
    @required this.isRandomQuiz,
    @required this.subject,
  });
  @override
  _ListQuizChooseTimeScreenState createState() =>
      _ListQuizChooseTimeScreenState();
}

class _ListQuizChooseTimeScreenState extends State<ListQuizChooseTimeScreen> {
  String seconds = "0";

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.setTimeScreenEvent);
    super.initState();
  }

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
          text: "Choose Time",
          isHome: false,
          textColor: Colors.white,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("10", 0),
              SizedBox(
                width: 16,
              ),
              timeItemView("40", 1),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("15", 2),
              SizedBox(
                width: 16,
              ),
              timeItemView("45", 3),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("20", 4),
              SizedBox(
                width: 16,
              ),
              timeItemView("50", 5),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("25", 6),
              SizedBox(
                width: 16,
              ),
              timeItemView("60", 7),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("30", 6),
              SizedBox(
                width: 16,
              ),
              timeItemView("90", 7),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("35", 6),
              SizedBox(
                width: 16,
              ),
              timeItemView("120", 7),
            ],
          ),
        ),
        SizedBox(
          height: 16,
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
              if (seconds == "0") {
                Utility.showToast(context, "Please select seconds");
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateQuizLobbyScreen(
                      subject: widget.subject,
                      customQuiz: null,
                      isCustomQuiz: false,
                      seconds: int.tryParse(seconds),
                    ),
                  ),
                );
              }
            },
            text: "Done",
            bgColor: AppColors.myProgressCorrectcolor,
          ),
        ),
      ],
    );
  }

  Widget timeItemView(String time, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          seconds = time;
          _notify();
        },
        child: Container(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: seconds == time
                  ? AppColors.myProgressIncorrectcolor
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.whiteClock,
                  color: AppColors.appColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  time + " Sec",
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
