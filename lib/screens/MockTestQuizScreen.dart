import 'dart:async';
import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullmarks/models/MockQuestionReportRequest.dart';
import 'package:fullmarks/models/MockTestQuestionsResponse.dart';
import 'package:fullmarks/models/MockTestResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/ReportsResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'TestResultScreen.dart';
import 'TestScreen.dart';

class MockTestQuizScreen extends StatefulWidget {
  MockTestDetails mockTest;
  MockTestQuizScreen({
    @required this.mockTest,
  });
  @override
  _MockTestQuizScreenState createState() => _MockTestQuizScreenState();
}

class _MockTestQuizScreenState extends State<MockTestQuizScreen> {
  int currentQuestion = 0;
  PageController questionController;
  bool isPopOpen = false;
  bool _isLoading = false;
  List<QuestionDetails> questionsDetails = List();
  RewardedVideoAd rewardAd = RewardedVideoAd.instance;
  Timer _timer;
  int _start = 0;

  //for time taken
  Timer timer;
  int milliseconds;
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final Stopwatch stopwatch = Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
  int seconds = 0;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.mockTestQuizEvent);
    questionController = PageController();
    _getQuestions();
    timer = Timer.periodic(
        Duration(milliseconds: timerMillisecondsRefreshRate), callback);
    timerListeners.add(onTick);
    stopwatch.start();
    rewardAd.load(adUnitId: AppStrings.adUnitId).then((value) {
      print("Reward ad load");
      print(value);
    });
    rewardAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("Reward ad listener");
      print(event);
      if (event == RewardedVideoAdEvent.closed) {
        submitQuestions();
      }
    };
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.seconds != seconds) {
      if (mounted)
        setState(() {
          seconds = elapsed.seconds;
        });
      //individual question time taken in seconds
      questionsDetails[currentQuestion].timeTaken =
          questionsDetails[currentQuestion].timeTaken + 1;
    }
  }

  void callback(Timer timer) {
    if (milliseconds != stopwatch.elapsedMilliseconds) {
      milliseconds = stopwatch.elapsedMilliseconds;
      final int seconds = (milliseconds / 1000).truncate();
      final int minutes = (seconds / 60).truncate();
      final int hours = (minutes / 60).truncate();
      final ElapsedTime elapsedTime = ElapsedTime(
        seconds: seconds,
        minutes: minutes,
        hours: hours,
      );
      for (final listener in timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  _getQuestions() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["mockId"] = widget.mockTest.id.toString();
      //api call
      MockTestQuestionsResponse response = MockTestQuestionsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.mockQuestions, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        questionsDetails = response.result.questions;
        _start = widget.mockTest.time;
        startTimer();
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          _notify();
          //on timer complete go to play live quiz
          showRewardAd();
        } else {
          _start--;
          _notify();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            Utility.setSvgFullScreen(context, AppAssets.mockTestBg),
            body(),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return Utility.showSubmitQuizDialog(
          context: context,
          onSubmitPress: () async {
            _timer.cancel();
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
            showRewardAd();
          },
        ) ??
        false;
  }

  @override
  void dispose() {
    try {
      timer?.cancel();
      timer = null;
    } catch (e) {}
    try {
      _timer.cancel();
    } catch (e) {}
    super.dispose();
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.mockTest.name,
          isHome: false,
          textColor: Colors.white,
          onBackPressed: _onBackPressed,
        ),
        _isLoading || questionsDetails.length == 0
            ? Container()
            : timeElapsedView(),
        _isLoading || questionsDetails.length == 0
            ? Container()
            : SizedBox(
                height: 16,
              ),
        _isLoading || questionsDetails.length == 0
            ? Container()
            : Expanded(
                child: PageView(
                  controller: questionController,
                  onPageChanged: (page) {
                    questionAnimateTo(page);
                  },
                  children: List.generate(
                    questionsDetails.length,
                    (index) {
                      return questionAnswerItemView();
                    },
                  ),
                ),
              ),
        _isLoading || questionsDetails.length == 0
            ? Container()
            : previousNextView(),
        _isLoading ? Expanded(child: Utility.progress(context)) : Container(),
        !_isLoading && questionsDetails.length == 0
            ? Expanded(
                child: Utility.emptyView(
                  "No Questions",
                  textColor: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }

  Widget questionAnswerItemView() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          questionsDetails.length.toString(),
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
                      "+" + widget.mockTest.correct_marks.toString(),
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
                      widget.mockTest.incorrect_marks.toString(),
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
            questionsDetails[currentQuestion].question == ""
                ? Container()
                : questionText(),
            questionsDetails[currentQuestion].questionImage == ""
                ? Container()
                : questionImageView(),
            SizedBox(
              height: 16,
            ),
            answersView(currentQuestion),
          ],
        ),
      ),
    );
  }

  Widget answersView(int questionIndex) {
    return Column(
      children: List.generate(4, (index) {
        return textAnswerItemView(questionIndex, index);
      }),
    );
  }

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
        color: questionsDetails[questionIndex].selectedAnswer == answerIndex
            ? AppColors.myProgressIncorrectcolor
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: questionsDetails[questionIndex].selectedAnswer == answerIndex
                ? AppColors.myProgressIncorrectcolor
                : AppColors.blackColor,
          ),
        ),
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          if (questionsDetails[questionIndex].selectedAnswer == answerIndex) {
            questionsDetails[questionIndex].selectedAnswer = -1;
            _notify();
          } else {
            questionsDetails[questionIndex].selectedAnswer = answerIndex;
            _notify();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answerIndex == 0
                  ? "(A) " + questionsDetails[questionIndex].ansOne
                  : answerIndex == 1
                      ? "(B) " + questionsDetails[questionIndex].ansTwo
                      : answerIndex == 2
                          ? "(C) " + questionsDetails[questionIndex].ansThree
                          : "(D) " + questionsDetails[questionIndex].ansFour,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            (answerIndex == 0
                    ? questionsDetails[questionIndex].ansOneImage == ""
                    : answerIndex == 1
                        ? questionsDetails[questionIndex].ansTwoImage == ""
                        : answerIndex == 2
                            ? questionsDetails[questionIndex].ansThreeImage ==
                                ""
                            : questionsDetails[questionIndex].ansFourImage ==
                                "")
                ? Container()
                : SizedBox(
                    height: 8,
                  ),
            (answerIndex == 0
                    ? questionsDetails[questionIndex].ansOneImage == ""
                    : answerIndex == 1
                        ? questionsDetails[questionIndex].ansTwoImage == ""
                        : answerIndex == 2
                            ? questionsDetails[questionIndex].ansThreeImage ==
                                ""
                            : questionsDetails[questionIndex].ansFourImage ==
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
                            ? questionsDetails[questionIndex].ansOneImage
                            : answerIndex == 1
                                ? questionsDetails[questionIndex].ansTwoImage
                                : answerIndex == 2
                                    ? questionsDetails[questionIndex]
                                        .ansThreeImage
                                    : questionsDetails[questionIndex]
                                        .ansFourImage,
                        placeholder: AppAssets.imagePlaceholder,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget questionImageView() {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: Image.asset(
        AppAssets.imagePlaceholder,
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
              vertical: 12,
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
                  Utility.getHMS(_start),
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
              isPopOpen = true;
              _notify();
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
                isPopOpen ? AppAssets.arrowDown : AppAssets.grid,
                height: 45,
                width: 45,
              ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: questionsDetails.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            questionAnimateTo(index);
                            isPopOpen = false;
                            _notify();
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration:
                                questionsDetails[index].selectedAnswer != -1
                                    ? Utility.attemptedDecoration()
                                    : index == currentQuestion
                                        ? Utility.activeDecoration()
                                        : Utility.notAttemptedDecoration(),
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                color: index == currentQuestion
                                    ? AppColors.wrongBorderColor
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                      onPressed: () async {
                        //delay to give ripple effect
                        await Future.delayed(
                            Duration(milliseconds: AppStrings.delay));
                        Navigator.pop(context);
                        isPopOpen = false;
                        _notify();
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
                    height: 50,
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
                if (currentQuestion == (questionsDetails.length - 1)) {
                  Utility.showSubmitQuizDialog(
                    context: context,
                    onSubmitPress: () async {
                      //delay to give ripple effect
                      await Future.delayed(
                          Duration(milliseconds: AppStrings.delay));
                      Navigator.pop(context);
                      showRewardAd();
                    },
                  );
                } else {
                  questionAnimateTo(currentQuestion + 1);
                }
              },
              text: currentQuestion == (questionsDetails.length - 1)
                  ? "Submit"
                  : "Next",
              assetName: currentQuestion == (questionsDetails.length - 1)
                  ? AppAssets.submit
                  : AppAssets.nextArrow,
              isSufix: true,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  showRewardAd() async {
    _timer.cancel();
    rewardAd.show().then((value) {
      print("Reward ad show");
      print(value);
      if (!value) {
        submitQuestions();
      }
    }).catchError((onError) {
      print("onError");
      print(onError);
      submitQuestions();
    });
  }

  submitQuestions() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      List<MockQuestionReportRequest> questionReportsAnswersList = List();

      var request = Map<String, dynamic>();

      await Future.forEach(questionsDetails, (QuestionDetails element) {
        questionReportsAnswersList.add(
          MockQuestionReportRequest(
            mockId: widget.mockTest.id.toString(),
            userId: Utility.getCustomer().id.toString(),
            questionId: element.id.toString(),
            correctAnswer: Utility.getQuestionCorrectAnswer(element).toString(),
            timeTaken: element.timeTaken.toString(),
            userAnswer: element.selectedAnswer.toString(),
          ),
        );
      });
      request["answers"] = jsonEncode(questionReportsAnswersList);

      //api call
      ReportsResponse response = ReportsResponse.fromJson(
        await ApiManager(context).postCall(
          url: AppStrings.mockReport,
          request: request,
        ),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(context, response.message);

      if (response.code == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => TestResultScreen(
              questionsDetails: questionsDetails,
              subtopic: null,
              subject: null,
              setDetails: null,
              reportDetails:
                  Utility.getCustomer() == null ? null : response.result,
              title: widget.mockTest.name,
              isMockTest: true,
              isNormalQuiz: false,
              correctMarks: widget.mockTest.correct_marks,
              incorrectMarks: widget.mockTest.incorrect_marks,
            ),
          ),
        );
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  questionAnimateTo(int page) {
    currentQuestion = page;
    _notify();
    questionController.jumpToPage(currentQuestion);
  }

  Widget questionText() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: Text(
        questionsDetails[currentQuestion].question,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
