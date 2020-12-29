import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/CustomQuizListScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'AddQuestionScreen.dart';
import 'AddQuizNameScreen.dart';
import 'CreateQuizLobbyScreen.dart';

class CreateCustomQuizScreen extends StatefulWidget {
  @override
  _CreateCustomQuizScreenState createState() => _CreateCustomQuizScreenState();
}

class _CreateCustomQuizScreenState extends State<CreateCustomQuizScreen> {
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
          text: "Create Custom Quiz",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
          textColor: Colors.white,
        ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16),
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
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SvgPicture.asset(
                AppAssets.customQuizBg,
                color: AppColors.lightAppColor,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  SvgPicture.asset(AppAssets.customQuizBg2),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Utility.button(
                      context,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddQuizNameScreen(),
                          ),
                        );
                      },
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      gradientColor1: AppColors.buttonGradient1,
                      gradientColor2: AppColors.buttonGradient2,
                      text: "Add New Quiz",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "My Quiz List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        myQuizList()
      ],
    );
  }

  Widget myQuizList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          return myQuizItemView(index);
        },
      ),
    );
  }

  Widget myQuizItemView(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomQuizListScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.chartBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                SvgPicture.asset(
                  AppAssets.myQuizItemBg,
                  color: Color(0x595D8AEA),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Physical Quiz",
                        style: TextStyle(
                          color: AppColors.myProgressIncorrectcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "100 Questions",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: index == 0
                      ? Column(
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
                              text: "Add Question",
                              bgColor: AppColors.chartBgColor,
                              borderColor: AppColors.myProgressIncorrectcolor,
                              assetName: AppAssets.list,
                              isPrefix: true,
                              fontSize: 14,
                              padding: 8,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Utility.button(
                              context,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CreateQuizLobbyScreen(),
                                  ),
                                );
                              },
                              text: "Start Quiz",
                              bgColor: AppColors.strongCyan,
                              assetName: AppAssets.enterWhite,
                              isSufix: true,
                              isSpacer: true,
                              fontSize: 14,
                              padding: 8,
                            ),
                          ],
                        )
                      : Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              AppAssets.submit,
                              color: AppColors.myProgressCorrectcolor,
                            ),
                          ),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
