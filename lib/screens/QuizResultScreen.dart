import 'package:flutter/material.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class QuizResultScreen extends StatefulWidget {
  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

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
          text: "Quiz Result",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
        ),
        resultList(),
      ],
    );
  }

  Widget resultList() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: List.generate(3, (index) {
              return index == 2
                  ? Container(
                      child: Utility.roundShadowButton(
                        context: context,
                        assetName: AppAssets.upArrow,
                        onPressed: () {
                          controller.animateTo(
                            0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    )
                  : resultItemView(index);
            }),
          ),
        ),
      ),
    );
  }

  Widget resultItemView(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.black38,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: index == 0 ? AppColors.strongCyan : AppColors.wrongBorderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            (index + 1).toString() +
                ". Which one of the following has maximum number of atoms?",
            style: TextStyle(
              color: AppColors.appColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            children: List.generate(4, (answerIndex) {
              return textAnswerItemView(index, answerIndex);
            }),
          )
        ],
      ),
    );
  }

  Widget textAnswerItemView(int questionIndex, int answerIndex) {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      alignment: Alignment.center,
      decoration: answerIndex == 1
          ? Utility.resultAnswerDecoration(AppColors.strongCyan)
          : questionIndex == 1 && answerIndex == 0
              ? Utility.resultAnswerDecoration(AppColors.wrongBorderColor)
              : Utility.defaultAnswerDecoration(),
      child: Text(
        answerIndex == 0
            ? "(A) 18 g of H2O"
            : answerIndex == 1
                ? "(B) 21 g of H2O"
                : answerIndex == 2
                    ? "(C) 19 g of H2O"
                    : "(D) 90 g of H2O",
        style: TextStyle(
          color: answerIndex == 1
              ? Colors.white
              : questionIndex == 1 && answerIndex == 0
                  ? Colors.white
                  : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
