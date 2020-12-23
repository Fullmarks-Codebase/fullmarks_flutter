import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'TestResultScreen.dart';

class MockTestQuizScreen extends StatefulWidget {
  @override
  _MockTestQuizScreenState createState() => _MockTestQuizScreenState();
}

class _MockTestQuizScreenState extends State<MockTestQuizScreen> {
  int currentQuestion = 0;
  int totalQuestion = 10;
  PageController questionController;
  int selectedAnswer = -1;
  bool isPopOpen = false;

  @override
  void initState() {
    questionController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.mockTestBg),
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
          text: "SSC CGL Mock Test -1",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
          textColor: Colors.white,
        ),
        timeElapsedView(),
        SizedBox(
          height: 16,
        ),
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
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 16,
                      left: 16,
                      bottom: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            right: 16,
                            left: 16,
                            top: 16,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Question " +
                                      (currentQuestion + 1).toString() +
                                      " / " +
                                      totalQuestion.toString(),
                                  style: TextStyle(
                                    color: AppColors.appColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "+3.0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "-1.0",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        questionText(),
                        currentQuestion % 2 == 0
                            ? questionImageView()
                            : Container(),
                        SizedBox(
                          height: 16,
                        ),
                        answersView()
                      ],
                    ),
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
        if (mounted)
          setState(() {
            selectedAnswer = index;
          });
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
        if (mounted)
          setState(() {
            selectedAnswer = index;
          });
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
            ? Utility.selectedAnswerDecoration(color: AppColors.strongCyan)
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
            color: selectedAnswer == index ? Colors.white : Colors.black,
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

  Widget timeElapsedView() {
    return Row(
      children: [
        Expanded(
          child: Container(),
        ),
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.myProgressIncorrectcolor,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.whiteClock,
                  color: AppColors.appColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "1 hr 55 min 45 sec",
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (mounted)
                setState(() {
                  isPopOpen = true;
                });
              showQuestionNumberDialog();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.myProgressIncorrectcolor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 3,
              ),
              child: SvgPicture.asset(
                  isPopOpen ? AppAssets.arrowDown : AppAssets.grid),
            ),
          ),
        ),
      ],
    );
  }

  showQuestionNumberDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          contentPadding: EdgeInsets.all(16),
          content: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stack(
                //   alignment: Alignment.topRight,
                //   overflow: Overflow.visible,
                //   children: [
                // Positioned(
                //   top: -25,
                //   right: -25,
                //   child: GestureDetector(
                //     onTap: () {
                //       print("asdfasdf");
                //       Navigator.pop(context);
                //     },
                //     child: Container(
                //       decoration: BoxDecoration(
                //         color: AppColors.greyColor3,
                //         shape: BoxShape.circle,
                //       ),
                //       child: Icon(
                //         FontAwesomeIcons.solidTimesCircle,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Utility.correctIncorrectView(
                      color: AppColors.wrongBorderColor,
                      title: "Active",
                      textColor: Colors.black,
                      fontSize: 14,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Utility.correctIncorrectView(
                      color: AppColors.strongCyan,
                      title: "Attempted",
                      textColor: Colors.black,
                      fontSize: 14,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Utility.correctIncorrectView(
                      color: AppColors.greyColor2,
                      title: "Not Attempted",
                      textColor: Colors.black,
                      fontSize: 14,
                    ),
                  ],
                ),
                // ],
                // ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor4,
                      border: Border.all(
                        color: AppColors.greyColor3,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: (MediaQuery.of(context).size.height),
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: 100,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: index == 0
                              ? attemptedDecoration()
                              : index == 1
                                  ? activeDecoration()
                                  : notAttemptedDecoration(),
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: index == 1
                                  ? AppColors.wrongBorderColor
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (mounted)
                          setState(() {
                            isPopOpen = false;
                          });
                      },
                      child: Text("Close"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  BoxDecoration attemptedDecoration() {
    return BoxDecoration(
      color: AppColors.strongCyan,
      borderRadius: BorderRadius.circular(8),
    );
  }

  BoxDecoration activeDecoration() {
    return BoxDecoration(
      color: AppColors.greyColor4,
      border: Border.all(
        color: AppColors.wrongBorderColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  BoxDecoration notAttemptedDecoration() {
    return BoxDecoration(
      color: AppColors.greyColor2,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget previousNextView() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 0),
            blurRadius: 5,
            color: Colors.black12,
          ),
        ],
      ),
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
                            title: "SSC CGL Mock Test -1",
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

  questionAnimateTo(int page) {
    if (mounted)
      setState(() {
        currentQuestion = page;
      });

    questionController.jumpToPage(currentQuestion);
  }

  Widget questionText() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: Text(
        "Which one of the following has maximum number of atoms?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
