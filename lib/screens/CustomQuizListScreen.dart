import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/AddQuestionScreen.dart';
import 'package:fullmarks/screens/PreviewQuestionScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class CustomQuizListScreen extends StatefulWidget {
  @override
  _CustomQuizListScreenState createState() => _CustomQuizListScreenState();
}

class _CustomQuizListScreenState extends State<CustomQuizListScreen> {
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
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
          textColor: Colors.white,
        ),
        questionsList(),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
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
          child: Column(
            children: [
              Utility.button(
                context,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddQuestionScreen(
                        isEdit: false,
                      ),
                    ),
                  );
                },
                bgColor: AppColors.chartBgColor,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                gradientColor1: AppColors.buttonGradient1,
                gradientColor2: AppColors.buttonGradient2,
                text: "Add More Question",
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Submit",
                bgColor: AppColors.myProgressCorrectcolor,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget questionsList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          return questionsItemView(index);
        },
      ),
    );
  }

  Widget questionsItemView(int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16,
      ),
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Question " + (index + 1).toString(),
              style: TextStyle(
                color: AppColors.appColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Which one of the following has maximum number of atoms?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
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
                Spacer(),
                questionItemViewButton(AppAssets.eye, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewQuestionScreen(),
                    ),
                  );
                }),
                SizedBox(
                  width: 8,
                ),
                questionItemViewButton(
                  AppAssets.edit,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQuestionScreen(
                          isEdit: true,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                questionItemViewButton(AppAssets.delete, () {
                  Utility.showDeleteDialog(
                    context: context,
                    onDeletePress: () {
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget questionItemViewButton(String assetName, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 1,
              color: AppColors.appColor,
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(assetName),
      ),
    );
  }
}
