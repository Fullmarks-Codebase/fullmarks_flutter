import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/SetTimeLimitScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
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
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Utility.appbar(
              context,
              text: "Add Question",
              onBackPressed: () {
                Navigator.pop(context);
              },
              isHome: false,
              textColor: Colors.white,
            ),
            timerView(),
          ],
        ),
        addImageView(),
        addQuestionView(),
      ],
    );
  }

  Widget addQuestionView() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.appColor,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.appColor,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: "Type the Question...",
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              optionView(AppColors.myProgressCorrectcolor),
              SizedBox(
                width: 16,
              ),
              optionView(AppColors.subtopicItemBorderColor),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              optionView(AppColors.strongCyan),
              SizedBox(
                width: 16,
              ),
              optionView(AppColors.introColor4),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Utility.button(
            context,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddQuestionScreen(),
                ),
              );
            },
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            gradientColor1: AppColors.buttonGradient1,
            gradientColor2: AppColors.buttonGradient2,
            text: "Add",
          )
        ],
      ),
    );
  }

  Widget addImageView() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greyColor12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SvgPicture.asset(AppAssets.addImage),
    );
  }

  Widget timerView() {
    return SafeArea(
      bottom: false,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetTimeLimitScreen(),
            ),
          );
        },
        child: Container(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(
              bottom: 16,
              right: 16,
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
                  "30 Sec",
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontSize: 16,
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

  Widget optionView(Color bgColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            SvgPicture.asset(AppAssets.add),
            SizedBox(
              height: 16,
            ),
            Text(
              "Add Option",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
