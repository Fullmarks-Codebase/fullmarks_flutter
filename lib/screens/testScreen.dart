import 'dart:async';
import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fullmarks/models/QuestionReportRequest.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/ReportsResponse.dart';
import 'package:fullmarks/models/SetsResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/SubtopicResponse.dart';
import 'package:fullmarks/screens/TestResultScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class TestScreen extends StatefulWidget {
  SubtopicDetails subtopic;
  SubjectDetails subject;
  SetDetails setDetails;
  List<QuestionDetails> questionsDetails;
  TestScreen({
    @required this.subtopic,
    @required this.subject,
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
  //for time taken
  Timer timer;
  int milliseconds;
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final Stopwatch stopwatch = Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
  int seconds = 0;
  bool _isLoading = false;

  RewardedVideoAd rewardAd = RewardedVideoAd.instance;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.testEvent);
    questionsNumberController = ScrollController();
    questionController = PageController();
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
      widget.questionsDetails[currentQuestion].timeTaken =
          widget.questionsDetails[currentQuestion].timeTaken + 1;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          children: [
            Utility.setSvgFullScreen(context, AppAssets.commonBg),
            body(),
            _isLoading ? Utility.progress(context) : Container()
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return Utility.showSubmitQuizDialog(
          context: context,
          onSubmitPress: () async {
            stopwatch.stop();
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
            showRewardAd();
          },
        ) ??
        false;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(context,
            text: widget.subject.name +
                " / " +
                widget.subtopic.name +
                " / " +
                widget.setDetails.name,
            isHome: false, onBackPressed: () {
          Utility.showSubmitQuizDialog(
            context: context,
            onSubmitPress: () async {
              stopwatch.stop();
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              Navigator.pop(context);
              showRewardAd();
            },
          );
        }),
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
            ),
            (answerIndex == 0
                    ? widget.questionsDetails[questionIndex].ansOneImage == ""
                    : answerIndex == 1
                        ? widget.questionsDetails[questionIndex].ansTwoImage ==
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
                        ? widget.questionsDetails[questionIndex].ansTwoImage ==
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
                      stopwatch.stop();
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

  showRewardAd() async {
    stopwatch.stop();
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
      List<QuestionReportAnswers> questionReportsAnswersList = List();

      var request = Map<String, dynamic>();

      if (Utility.getCustomer() == null) {
        request["guest"] = "true";
        request["id"] = Utility.getGuest().id.toString();
      } else {
        await Future.forEach(widget.questionsDetails,
            (QuestionDetails element) {
          questionReportsAnswersList.add(
            QuestionReportAnswers(
              userId: Utility.getCustomer().id.toString(),
              questionId: element.id.toString(),
              correctAnswer:
                  Utility.getQuestionCorrectAnswer(element).toString(),
              timeTaken: element.timeTaken.toString(),
              userAnswer: element.selectedAnswer.toString(),
            ),
          );
        });
        request["answers"] = jsonEncode(questionReportsAnswersList);
      }

      //api call
      ReportsResponse response = ReportsResponse.fromJson(
        await ApiManager(context).postCall(
          url: AppStrings.reports,
          request: request,
        ),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(context, response.message);

      if (response.code == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => TestResultScreen(
              questionsDetails: widget.questionsDetails,
              subtopic: widget.subtopic,
              subject: widget.subject,
              setDetails: widget.setDetails,
              reportDetails:
                  Utility.getCustomer() == null ? null : response.result,
              title: "",
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
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
          : widget.questionsDetails[index].selectedAnswer == -1
              ? Colors.white
              : AppColors.strongCyan,
      shape: CircleBorder(
        side: BorderSide(
          color: currentQuestion == index
              ? AppColors.appColor
              : widget.questionsDetails[index].selectedAnswer == -1
                  ? Colors.black
                  : AppColors.strongCyan,
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
              : widget.questionsDetails[index].selectedAnswer == -1
                  ? Colors.black
                  : Colors.white,
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
            text: Utility.getHMS(seconds),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ElapsedTime {
  final int seconds;
  final int minutes;
  final int hours;

  ElapsedTime({
    this.seconds,
    this.minutes,
    this.hours,
  });
}
