import 'package:flutter/material.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class QuizResultScreen extends StatefulWidget {
  List<QuestionDetails> questionsDetails;
  QuizResultScreen({
    @required this.questionsDetails,
  });
  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  ScrollController controller;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.quizResultEvent);
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
            children: List.generate(widget.questionsDetails.length, (index) {
              return Column(
                children: [
                  resultItemView(index),
                  index == (widget.questionsDetails.length - 1)
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Utility.roundShadowButton(
                            context: context,
                            assetName: AppAssets.upArrow,
                            onPressed: () async {
                              //delay to give ripple effect
                              await Future.delayed(
                                  Duration(milliseconds: AppStrings.delay));
                              controller.animateTo(
                                0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              );
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
          color: widget.questionsDetails[index].selectedAnswer == -1
              ? AppColors.yellowColor
              : widget.questionsDetails[index].selectedAnswer ==
                      Utility.getQuestionCorrectAnswer(
                          widget.questionsDetails[index])
                  ? AppColors.strongCyan
                  : AppColors.wrongBorderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (index + 1).toString() +
                ". " +
                widget.questionsDetails[index].question,
            style: TextStyle(
              color: AppColors.appColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          widget.questionsDetails[index].questionImage == ""
              ? Container()
              : questionImageView(index),
          Column(
            children: List.generate(4, (answerIndex) {
              return textAnswerItemView(index, answerIndex);
            }),
          )
        ],
      ),
    );
  }

  Widget questionImageView(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      height: 200,
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Utility.imageLoader(
          baseUrl: AppStrings.questionImage,
          url: widget.questionsDetails[index].questionImage,
          placeholder: AppAssets.imagePlaceholder,
        ),
      ),
    );
  }

  BoxDecoration getAnswerDecoration(int questionIndex, int answerIndex) {
    if ((answerIndex ==
        Utility.getQuestionCorrectAnswer(
            widget.questionsDetails[questionIndex]))) {
      // show green to correct answer of question
      return Utility.resultAnswerDecoration(AppColors.strongCyan);
    } else {
      //if you are here
      //then it means that your answer is wrong
      if (widget.questionsDetails[questionIndex].selectedAnswer ==
          answerIndex) {
        //show user selected current answer as red
        return Utility.resultAnswerDecoration(AppColors.wrongBorderColor);
      } else {
        //default
        return Utility.defaultAnswerDecoration();
      }
    }
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
      decoration: getAnswerDecoration(questionIndex, answerIndex),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answerIndex == 0
                ? "(A) " + widget.questionsDetails[questionIndex].ansOne
                : answerIndex == 1
                    ? "(B) " + widget.questionsDetails[questionIndex].ansTwo
                    : answerIndex == 2
                        ? "(C) " +
                            widget.questionsDetails[questionIndex].ansThree
                        : "(D) " +
                            widget.questionsDetails[questionIndex].ansFour,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          (answerIndex == 0
                  ? widget.questionsDetails[questionIndex].ansOneImage == ""
                  : answerIndex == 1
                      ? widget.questionsDetails[questionIndex].ansTwoImage == ""
                      : answerIndex == 2
                          ? widget.questionsDetails[questionIndex]
                                  .ansThreeImage ==
                              ""
                          : widget.questionsDetails[questionIndex]
                                  .ansFourImage ==
                              "")
              ? Container()
              : SizedBox(
                  height: 8,
                ),
          (answerIndex == 0
                  ? widget.questionsDetails[questionIndex].ansOneImage == ""
                  : answerIndex == 1
                      ? widget.questionsDetails[questionIndex].ansTwoImage == ""
                      : answerIndex == 2
                          ? widget.questionsDetails[questionIndex]
                                  .ansThreeImage ==
                              ""
                          : widget.questionsDetails[questionIndex]
                                  .ansFourImage ==
                              "")
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Utility.imageLoader(
                      baseUrl: AppStrings.answersImage,
                      url: answerIndex == 0
                          ? widget.questionsDetails[questionIndex].ansOneImage
                          : answerIndex == 1
                              ? widget
                                  .questionsDetails[questionIndex].ansTwoImage
                              : answerIndex == 2
                                  ? widget.questionsDetails[questionIndex]
                                      .ansThreeImage
                                  : widget.questionsDetails[questionIndex]
                                      .ansFourImage,
                      placeholder: AppAssets.imagePlaceholder,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
