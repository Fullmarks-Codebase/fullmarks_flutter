import 'package:flutter/material.dart';
import 'package:fullmarks/screens/TestResultScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class TestScreen extends StatefulWidget {
  String subtopicName;
  String subjectName;
  String setName;
  TestScreen({
    @required this.subtopicName,
    @required this.subjectName,
    @required this.setName,
  });
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int currentQuestion = 0;
  int totalQuestion = 15;
  int selectedAnswer = -1;
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
              widget.setName,
          onBackPressed: () {
            Navigator.pop(context);
          },
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
              totalQuestion,
              (index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      questionText(),
                      currentQuestion % 2 == 0
                          ? questionImageView()
                          : Container(),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      answersView()
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

  Widget answersView() {
    return Column(
      children: List.generate(4, (index) {
        return (currentQuestion - 1) % 4 == 0
            ? imageAnswerItemView(index)
            : textAnswerItemView(index);
      }),
    );
  }

  Widget imageAnswerItemView(int index) {
    return GestureDetector(
      onTap: () {
        selectedAnswer = index;
        _notify();
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedAnswer == index
                ? AppColors.myProgressIncorrectcolor
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Image.asset(
              index == 0
                  ? AppAssets.answerImage1
                  : index == 1
                      ? AppAssets.answerImage2
                      : index == 2
                          ? AppAssets.answerImage3
                          : AppAssets.answerImage4,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1,
                    color: Colors.black38,
                  ),
                ],
              ),
              child: Text(
                index == 0
                    ? "(A)"
                    : index == 1
                        ? "(B)"
                        : index == 2
                            ? "(C)"
                            : "(D)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textAnswerItemView(int index) {
    return GestureDetector(
      onTap: () {
        selectedAnswer = index;
        _notify();
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        alignment: Alignment.center,
        decoration: selectedAnswer == index
            ? Utility.selectedAnswerDecoration()
            : Utility.defaultAnswerDecoration(),
        child: Text(
          index == 0
              ? "(A) 18 g of H2O"
              : index == 1
                  ? "(B) 21 g of H2O"
                  : index == 2
                      ? "(C) 19 g of H2O"
                      : "(D) 90 g of H2O",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget questionImageView() {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: Image.asset(
        AppAssets.dummyQuestionImage,
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
                    onPressed: () {
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
              onPressed: () {
                if (currentQuestion == (totalQuestion - 1)) {
                  Utility.showSubmitQuizDialog(
                    context: context,
                    onSubmitPress: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) => TestResultScreen(
                            title: widget.subjectName +
                                " / " +
                                widget.subtopicName +
                                " / " +
                                widget.setName,
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
              text: currentQuestion == (totalQuestion - 1) ? "Submit" : "Next",
              assetName: currentQuestion == (totalQuestion - 1)
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

  Widget questionText() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Text(
        (currentQuestion + 1).toString() +
            ". Which one of the following has maximum number of atoms?",
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
          children: List.generate(totalQuestion, (index) {
            return questionNumberItemView(index);
          }),
        ),
      ),
    );
  }

  Widget questionNumberItemView(int index) {
    return GestureDetector(
      onTap: () {
        questionAnimateTo(index);
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 8,
        ),
        padding: EdgeInsets.all(
          (index + 1).toString().length >= 2 ? 8 : 12,
        ),
        decoration: currentQuestion == index
            ? Utility.getCurrentDecoration()
            : index == 3 || index == 5
                ? Utility.getSubmitedDecoration()
                : Utility.defaultDecoration(),
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
