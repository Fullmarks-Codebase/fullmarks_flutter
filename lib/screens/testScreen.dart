import 'package:flutter/material.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/SetsResponse.dart';
import 'package:fullmarks/screens/TestResultScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class TestScreen extends StatefulWidget {
  String subtopicName;
  String subjectName;
  SetDetails setDetails;
  List<QuestionDetails> questionsDetails;
  TestScreen({
    @required this.subtopicName,
    @required this.subjectName,
    @required this.setDetails,
    @required this.questionsDetails,
  });
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int currentQuestion = 0;
  ScrollController questionsNumberController;
  PageController questionController;

  @override
  void initState() {
    questionsNumberController = ScrollController();
    questionController = PageController();
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
          text: widget.subjectName +
              " / " +
              widget.subtopicName +
              " / " +
              widget.setDetails.name,
          isHome: false,
        ),
        timeElapsedView(),
        questionNumberView(),
        Expanded(
          child: PageView(
            controller: questionController,
            onPageChanged: (page) {
              questionAnimateTo(page);
            },
            children: List.generate(
              widget.questionsDetails.length,
              (index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      widget.questionsDetails[index].question == ""
                          ? Container()
                          : questionText(index),
                      widget.questionsDetails[index].questionImage == ""
                          ? Container()
                          : questionImageView(index),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      answersView(index)
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        previousNextView(),
      ],
    );
  }

  Widget answersView(int questionIndex) {
    return Column(
      children: List.generate(4, (index) {
        return textAnswerItemView(questionIndex, index);
      }),
    );
  }

  // Widget imageAnswerItemView(int questionIndex, int answerIndex) {
  //   return GestureDetector(
  //     onTap: () {
  //       widget.questionsDetails[questionIndex].selectedAnswer = answerIndex;
  //       _notify();
  //     },
  //     child: Container(
  //       margin: EdgeInsets.only(
  //         bottom: 16,
  //         left: 16,
  //         right: 16,
  //       ),
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           color: widget.questionsDetails[questionIndex].selectedAnswer ==
  //                   answerIndex
  //               ? AppColors.myProgressIncorrectcolor
  //               : Colors.transparent,
  //           width: 2,
  //         ),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       alignment: Alignment.center,
  //       child: Stack(
  //         children: [
  //           Image.asset(
  //             answerIndex == 0
  //                 ? AppAssets.answerImage1
  //                 : answerIndex == 1
  //                     ? AppAssets.answerImage2
  //                     : answerIndex == 2
  //                         ? AppAssets.answerImage3
  //                         : AppAssets.answerImage4,
  //           ),
  //           Container(
  //             padding: EdgeInsets.symmetric(
  //               horizontal: 10,
  //               vertical: 8,
  //             ),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               shape: BoxShape.circle,
  //               boxShadow: [
  //                 BoxShadow(
  //                   offset: Offset(0, 1),
  //                   blurRadius: 1,
  //                   color: Colors.black38,
  //                 ),
  //               ],
  //             ),
  //             child: Text(
  //               answerIndex == 0
  //                   ? "(A)"
  //                   : answerIndex == 1
  //                       ? "(B)"
  //                       : answerIndex == 2
  //                           ? "(C)"
  //                           : "(D)",
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget textAnswerItemView(int questionIndex, int answerIndex) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: FlatButton(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        color:
            widget.questionsDetails[questionIndex].selectedAnswer == answerIndex
                ? AppColors.myProgressIncorrectcolor
                : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: widget.questionsDetails[questionIndex].selectedAnswer ==
                    answerIndex
                ? AppColors.myProgressIncorrectcolor
                : AppColors.blackColor,
          ),
        ),
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          widget.questionsDetails[questionIndex].selectedAnswer = answerIndex;
          _notify();
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(
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
                          ? widget.questionsDetails[questionIndex]
                                  .ansTwoImage ==
                              ""
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
                          ? widget.questionsDetails[questionIndex]
                                  .ansTwoImage ==
                              ""
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
                              ? widget
                                  .questionsDetails[questionIndex].ansOneImage
                              : answerIndex == 1
                                  ? widget.questionsDetails[questionIndex]
                                      .ansTwoImage
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
        ),
      ),
    );
  }

  Widget questionImageView(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
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

  Widget previousNextView() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: Utility.bottomDecoration(),
      child: Row(
        children: [
          Expanded(
            child: currentQuestion == 0
                ? Container()
                : Utility.button(
                    context,
                    gradientColor1: AppColors.buttonGradient1,
                    gradientColor2: AppColors.buttonGradient2,
                    onPressed: () async {
                      //delay to give ripple effect
                      await Future.delayed(
                          Duration(milliseconds: AppStrings.delay));
                      questionAnimateTo(currentQuestion - 1);
                    },
                    text: "Prev",
                    assetName: AppAssets.previousArrow,
                    isPrefix: true,
                  ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Utility.button(
              context,
              gradientColor1: AppColors.buttonGradient1,
              gradientColor2: AppColors.buttonGradient2,
              onPressed: () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                if (currentQuestion == (widget.questionsDetails.length - 1)) {
                  Utility.showSubmitQuizDialog(
                    context: context,
                    onSubmitPress: () async {
                      //delay to give ripple effect
                      await Future.delayed(
                          Duration(milliseconds: AppStrings.delay));
                      Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => TestResultScreen(
                            title: widget.subjectName +
                                " / " +
                                widget.subtopicName +
                                " / " +
                                widget.setDetails.name,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  );
                } else {
                  questionAnimateTo(currentQuestion + 1);
                }
              },
              text: currentQuestion == (widget.questionsDetails.length - 1)
                  ? "Submit"
                  : "Next",
              assetName: currentQuestion == (widget.questionsDetails.length - 1)
                  ? AppAssets.submit
                  : AppAssets.nextArrow,
              isSufix: true,
            ),
          ),
        ],
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  questionAnimateTo(int page) {
    currentQuestion = page;
    _notify();

    questionsNumberController.animateTo(
      (currentQuestion * 25).toDouble(),
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );

    questionController.jumpToPage(currentQuestion);
  }

  Widget questionText(int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Text(
        (currentQuestion + 1).toString() +
            ". " +
            widget.questionsDetails[index].question,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget questionNumberView() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      controller: questionsNumberController,
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          left: 8,
          bottom: 16,
        ),
        child: Row(
          children: List.generate(widget.questionsDetails.length, (index) {
            return questionNumberItemView(index);
          }),
        ),
      ),
    );
  }

  Widget questionNumberItemView(int index) {
    return FlatButton(
      minWidth: 50,
      color: currentQuestion == index
          ? AppColors.appColor
          : index == 3 || index == 5
              ? AppColors.strongCyan
              : Colors.white,
      shape: CircleBorder(
        side: BorderSide(
          color: currentQuestion == index
              ? AppColors.appColor
              : index == 3 || index == 5
                  ? AppColors.strongCyan
                  : Colors.black,
        ),
      ),
      onPressed: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        questionAnimateTo(index);
      },
      child: Text(
        (index + 1).toString(),
        style: TextStyle(
          color: currentQuestion == index
              ? Colors.white
              : index == 3 || index == 5
                  ? Colors.white
                  : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget timeElapsedView() {
    return Text.rich(
      TextSpan(
        text: "Time Elapsed : ",
        children: [
          TextSpan(
            text: "10:33",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
