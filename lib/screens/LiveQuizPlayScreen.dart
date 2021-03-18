import 'dart:async';
import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/DisconnectedResponse.dart';
import 'package:fullmarks/models/LiveQuestionReportRequest.dart';
import 'package:fullmarks/models/LiveQuizResponse.dart';
import 'package:fullmarks/models/LiveQuizUsersResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/RandomQuizParticipantsResponse.dart';
import 'package:fullmarks/models/ReportsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'HomeScreen.dart';
import 'RankListScreen.dart';

class LiveQuizPlayScreen extends StatefulWidget {
  bool isRandomQuiz;
  bool isCustomQuiz;
  List<QuestionDetails> questions;
  LiveQuizRoom room;
  IO.Socket socket;
  LiveQuizPlayScreen({
    @required this.isRandomQuiz,
    @required this.isCustomQuiz,
    @required this.questions,
    @required this.room,
    @required this.socket,
  });
  @override
  _LiveQuizPlayScreenState createState() => _LiveQuizPlayScreenState();
}

class _LiveQuizPlayScreenState extends State<LiveQuizPlayScreen> {
  int currentQuestion = 0;
  Timer _timer;
  IO.Socket socket;
  List<LiveQuizUsersDetails> participants = List();
  Customer customer = Utility.getCustomer();
  String myScore = "0";
  int perQuestionSeconds = 0;
  RewardedVideoAd rewardAd = RewardedVideoAd.instance;
  bool _isLoading = false;
  int defaultSeconds = 30;
  RandomQuizParticipantsDetails user1;
  RandomQuizParticipantsDetails user2;
  Timer _timerInternet;
  bool answerSelection = true;
  bool isSubmitReport = false;
  bool isDisconnectMessageShown = false;

  getQuestionSeconds() {
    perQuestionSeconds = widget.isRandomQuiz
        ? defaultSeconds
        : widget.isCustomQuiz
            ? widget.questions[currentQuestion].time
            : defaultSeconds;
    _notify();
  }

  @override
  void initState() {
    super.initState();
    AppFirebaseAnalytics.init().logEvent(
      name: AppStrings.liveQuizPlayEvent,
      parameters: {
        "isRandomQuiz": widget.isRandomQuiz,
        "isCustomQuiz": widget.isCustomQuiz,
      },
    );
    socket = widget.socket;
    getQuestionSeconds();
    startTimer();

    if (widget.isRandomQuiz) {
      socket.emit(AppStrings.userDetails, {"room": widget.room.room});

      //if other user disconnects then you also force quits the quiz
      socket.on(AppStrings.disconnected, (data) {
        print(AppStrings.disconnected + " play quiz ");
        print(jsonEncode(data));
        DisconnectedResponse disconnectedResponse =
            DisconnectedResponse.fromJson(jsonDecode(jsonEncode(data)));
        if ((disconnectedResponse.users.userId != Utility.getCustomer().id) &&
            !isDisconnectMessageShown) {
          isDisconnectMessageShown = true;
          _notify();
          Utility.showToast(
            context,
            disconnectedResponse.message,
          );
          socket.emit(
            AppStrings.forceDisconnect,
          );
          if (widget.isRandomQuiz) {
            showRewardAd();
          } else {
            if (context != null)
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
                (Route<dynamic> route) => false,
              );
          }
        }
      });

      socket.on(AppStrings.allParticipants, (data) {
        print(AppStrings.allParticipants);
        // print(jsonEncode(data));
        RandomQuizParticipantsResponse randomQuizParticipantsResponse =
            RandomQuizParticipantsResponse.fromJson(
                jsonDecode(jsonEncode(data)));
        try {
          if (Utility.getCustomer().id ==
              randomQuizParticipantsResponse.users[0].user.id) {
            user1 = randomQuizParticipantsResponse.users[1];
            user2 = randomQuizParticipantsResponse.users[0];
          } else {
            user1 = randomQuizParticipantsResponse.users[0];
            user2 = randomQuizParticipantsResponse.users[1];
          }
        } catch (e) {
          user1 = null;
          user2 = null;
        }

        _notify();
      });
    } else {
      //this will return all Participants
      socket.on(AppStrings.allParticipants, (data) {
        print(AppStrings.allParticipants);
        print(data);
        LiveQuizUsersResponse response =
            LiveQuizUsersResponse.fromJson(json.decode(jsonEncode(data)));
        participants = response.users;
        if (response.users.length != 0)
          myScore = participants
              .firstWhere(
                (element) => element.user.id == customer.id,
                orElse: () => null,
              )
              ?.score
              .toString();
        _notify();
      });

      socket.onError((data) {
        print("onError");
        print(data);
      });

      socket.on(AppStrings.error, (data) {
        print(AppStrings.error);
        print(data);
        Utility.showToast(context, jsonEncode(data));
      });
    }

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

    _timerInternet = Timer.periodic(
        Duration(seconds: AppStrings.timerSecondsForNoInternet), (timer) {
      //for no internet
      if (!socket.connected) {
        timer.cancel();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  Future<bool> _onBackPressed() {
    return Utility.quitLiveQuizDialog(
          context: context,
          onPressed: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
            socket.emit(
              AppStrings.forceDisconnect,
              {"userObj": Utility.getCustomer()},
            );
            socket.destroy();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
            _isLoading ? Utility.progress(context) : body(),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    answerSelection = true;
    _notify();
    socket.emit(AppStrings.userDetails, {"room": widget.room.room});
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (perQuestionSeconds == 0) {
          timer.cancel();

          answerSelection = false;

          //check answer is correct or not
          if (widget.questions[currentQuestion].selectedAnswer == -1) {
            Utility.showAnswerToast(
                context, "Not Attempted", AppColors.yellowColor);
            socket.emit(AppStrings.userDetails, {"room": widget.room.room});
          } else if (Utility.getQuestionCorrectAnswer(
                  widget.questions[currentQuestion]) ==
              widget.questions[currentQuestion].selectedAnswer) {
            Utility.showAnswerToast(context, "Correct", AppColors.correctColor);
            socket.emit(
              AppStrings.updateScore,
              {
                "point": 1,
                "id": Utility.getCustomer().id,
                "room": widget.room.room,
                "roomId": widget.room.id,
                (widget.isCustomQuiz ? "customQuestionId" : "questionId"):
                    widget.questions[currentQuestion].id,
              },
            );
            socket.emit(AppStrings.userDetails, {"room": widget.room.room});
          } else {
            Utility.showAnswerToast(
                context, "Incorrect", AppColors.incorrectColor);
            socket.emit(AppStrings.userDetails, {"room": widget.room.room});
          }

          //wait to do next task
          Future.delayed(
            Duration(seconds: 3),
            () {
              if ((widget.questions.length - 1) == currentQuestion) {
                //if last question then submit question
                showRewardAd();
              } else {
                //go to next question
                currentQuestion = currentQuestion + 1;
                getQuestionSeconds();
                _notify();
                //again start timer
                startTimer();
              }
            },
          );
        } else {
          perQuestionSeconds--;
          _notify();
        }
      },
    );
  }

  showRewardAd() async {
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
    if (!isSubmitReport) {
      isSubmitReport = true;
      _notify();
      //check internet connection available or not
      if (await ApiManager.checkInternet()) {
        //show progress
        _isLoading = true;
        _notify();
        //api request
        List<LiveQuestionReportRequest> questionReportsAnswersList = List();

        var request = Map<String, dynamic>();

        request["mode"] = widget.isCustomQuiz ? "custom" : "default";

        await Future.forEach(widget.questions, (QuestionDetails element) {
          questionReportsAnswersList.add(
            LiveQuestionReportRequest(
              userId: Utility.getCustomer().id.toString(),
              questionId: element.id.toString(),
              correctAnswer:
                  Utility.getQuestionCorrectAnswer(element).toString(),
              timeTaken: element.timeTaken.toString(),
              userAnswer: element.selectedAnswer.toString(),
              roomId: widget.room.id.toString(),
            ),
          );
        });
        request["answers"] = jsonEncode(questionReportsAnswersList);

        //api call
        ReportsResponse response = ReportsResponse.fromJson(
          await ApiManager(context).postCall(
            url: AppStrings.liveReport,
            request: request,
          ),
        );
        //hide progress
        _isLoading = false;
        _notify();

        Utility.showToast(
          context,
          response.message,
        );

        if (response.code == 200) {
          if (context != null)
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => RankListScreen(
                  isRandomQuiz: widget.isRandomQuiz,
                  title: widget.isRandomQuiz ? "Live Quiz Result" : "Rank List",
                  room: widget.room,
                  socket: socket,
                ),
              ),
            );
        }
      } else {
        //show message that internet is not available
        Utility.showToast(context, AppStrings.noInternet);
      }
    }
  }

  @override
  void dispose() {
    try {
      _timer.cancel();
    } catch (e) {}
    try {
      _timerInternet.cancel();
    } catch (e) {}
    super.dispose();
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget body() {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              participantsView(),
              SizedBox(
                width: 4,
              ),
              timerView(),
              SizedBox(
                width: 4,
              ),
              scoreView(),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          questionAnswerItemView(),
        ],
      ),
    );
  }

  Widget questionAnswerItemView() {
    return Expanded(
      child: SingleChildScrollView(
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
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 16,
                ),
                child: Text(
                  "Question " +
                      (currentQuestion + 1).toString() +
                      " / " +
                      widget.questions.length.toString(),
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              widget.questions[currentQuestion].question == ""
                  ? Container()
                  : questionText(),
              widget.questions[currentQuestion].questionImage == ""
                  ? Container()
                  : questionImageView(),
              Container(
                padding: EdgeInsets.all(16),
                child: Divider(
                  thickness: 2,
                ),
              ),
              answersView()
            ],
          ),
        ),
      ),
    );
  }

  Widget questionText() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: widget.isCustomQuiz
          ? Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Math.tex(
                  widget.questions[currentQuestion].question,
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : Text(
              widget.questions[currentQuestion].question,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget answersView() {
    return Column(
      children: List.generate(4, (index) {
        return textAnswerItemView(index);
      }),
    );
  }

  Color getAnswerColor(int answerIndex, bool isborderColor) {
    if (answerSelection) {
      if (widget.questions[currentQuestion].selectedAnswer == answerIndex) {
        return AppColors.myProgressIncorrectcolor;
      } else {
        return isborderColor ? AppColors.blackColor : Colors.white;
      }
    } else {
      if ((answerIndex ==
          Utility.getQuestionCorrectAnswer(
              widget.questions[currentQuestion]))) {
        // show green to correct answer of question
        return AppColors.strongCyan;
      } else {
        //if you are here
        //then it means that your answer is wrong
        if (widget.questions[currentQuestion].selectedAnswer == answerIndex) {
          //show user selected current answer as red
          return AppColors.wrongBorderColor;
        } else {
          //default
          return isborderColor ? AppColors.blackColor : Colors.white;
        }
      }
    }
  }

  Color getAnswerTextColor(int answerIndex) {
    if (answerSelection) {
      return AppColors.blackColor;
    } else {
      if ((answerIndex ==
          Utility.getQuestionCorrectAnswer(
              widget.questions[currentQuestion]))) {
        // show green to correct answer of question
        return Colors.white;
      } else {
        //if you are here
        //then it means that your answer is wrong
        if (widget.questions[currentQuestion].selectedAnswer == answerIndex) {
          //show user selected current answer as red
          return Colors.white;
        } else {
          //default
          return AppColors.blackColor;
        }
      }
    }
  }

  Widget textAnswerItemView(int answerIndex) {
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
        color: getAnswerColor(answerIndex, false),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: getAnswerColor(answerIndex, true),
          ),
        ),
        onPressed: answerSelection
            ? () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                widget.questions[currentQuestion].selectedAnswer = answerIndex;
                _notify();
              }
            : () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isCustomQuiz
                ? Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Math.tex(
                        answerIndex == 0
                            ? "(A) \\ " +
                                widget.questions[currentQuestion].ansOne
                            : answerIndex == 1
                                ? "(B) \\ " +
                                    widget.questions[currentQuestion].ansTwo
                                : answerIndex == 2
                                    ? "(C) \\ " +
                                        widget
                                            .questions[currentQuestion].ansThree
                                    : "(D) \\ " +
                                        widget
                                            .questions[currentQuestion].ansFour,
                        textStyle: TextStyle(
                          color: getAnswerTextColor(answerIndex),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : Text(
                    answerIndex == 0
                        ? "(A) " + widget.questions[currentQuestion].ansOne
                        : answerIndex == 1
                            ? "(B) " + widget.questions[currentQuestion].ansTwo
                            : answerIndex == 2
                                ? "(C) " +
                                    widget.questions[currentQuestion].ansThree
                                : "(D) " +
                                    widget.questions[currentQuestion].ansFour,
                    style: TextStyle(
                      color: getAnswerTextColor(answerIndex),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
            (answerIndex == 0
                    ? widget.questions[currentQuestion].ansOneImage == ""
                    : answerIndex == 1
                        ? widget.questions[currentQuestion].ansTwoImage == ""
                        : answerIndex == 2
                            ? widget.questions[currentQuestion].ansThreeImage ==
                                ""
                            : widget.questions[currentQuestion].ansFourImage ==
                                "")
                ? Container()
                : SizedBox(
                    height: 8,
                  ),
            (answerIndex == 0
                    ? widget.questions[currentQuestion].ansOneImage == ""
                    : answerIndex == 1
                        ? widget.questions[currentQuestion].ansTwoImage == ""
                        : answerIndex == 2
                            ? widget.questions[currentQuestion].ansThreeImage ==
                                ""
                            : widget.questions[currentQuestion].ansFourImage ==
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
                        baseUrl: widget.isCustomQuiz
                            ? AppStrings.customAnswers
                            : AppStrings.answersImage,
                        url: answerIndex == 0
                            ? widget.questions[currentQuestion].ansOneImage
                            : answerIndex == 1
                                ? widget.questions[currentQuestion].ansTwoImage
                                : answerIndex == 2
                                    ? widget.questions[currentQuestion]
                                        .ansThreeImage
                                    : widget.questions[currentQuestion]
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

  Widget questionImageView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Utility.imageLoader(
          baseUrl: widget.isCustomQuiz
              ? AppStrings.customQuestion
              : AppStrings.questionImage,
          url: widget.questions[currentQuestion].questionImage,
          placeholder: AppAssets.imagePlaceholder,
        ),
      ),
    );
  }

  Widget scoreView() {
    return Expanded(
      flex: 20,
      child: widget.isRandomQuiz ? user1View() : myScoreView(),
    );
  }

  Widget user1View() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user1?.user?.username?.trim()?.length == 0
                      ? "User" + user1.user.id.toString()
                      : user1 == null
                          ? "-"
                          : user1.user.username,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  user1 == null ? "0" : user1.points.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Utility.getUserImage(
            url: user1 == null ? "" : user1.user.thumbnail,
            height: 40,
            width: 40,
            bordercolor: AppColors.myProgressIncorrectcolor,
            placeholderColor: Colors.white,
          )
        ],
      ),
    );
  }

  Widget myScoreView() {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "My Score : " + myScore,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.appColor,
          ),
        ),
      ),
    );
  }

  Widget timerView() {
    return Expanded(
      flex: 13,
      child: Container(
        alignment: Alignment.center,
        child: Container(
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
                perQuestionSeconds.toString(),
                style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget user2View() {
    return Container(
      child: Row(
        children: [
          Utility.getUserImage(
            url: user2 == null ? "" : user2.user.thumbnail,
            bordercolor: AppColors.myProgressIncorrectcolor,
            height: 40,
            width: 40,
            placeholderColor: Colors.white,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user2?.user?.username?.trim()?.length == 0
                      ? "User" + user2.user.id.toString()
                      : user2 == null
                          ? "-"
                          : user2.user.username,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  user2 == null ? "0" : user2.points.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget participantsCountView() {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          showParticipantsDialog();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 12,
                width: 12,
                child: SvgPicture.asset(
                  AppAssets.participants,
                  color: AppColors.appColor,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                "Participants (" + participants.length.toString() + ")",
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.appColor,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.appColor,
                size: 12,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget participantsView() {
    return Expanded(
      flex: 20,
      child: widget.isRandomQuiz ? user2View() : participantsCountView(),
    );
  }

  showParticipantsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Participants (" + participants.length.toString() + ")",
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: AppColors.greyColor4,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: participants.length,
                      itemBuilder: (context, index) {
                        return participantsItemView(index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget participantsItemView(int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Utility.getUserImage(
        url: participants[index].user.thumbnail,
      ),
      title: Text(
        (participants[index].user.username.trim().length == 0
                ? "User" + participants[index].user.id.toString()
                : participants[index].user.username) +
            (participants[index].user.id == customer.id ? " (You)" : ""),
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Container(
        margin: EdgeInsets.only(
          right: 4,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
              offset: Offset(1, 0),
            ),
          ],
        ),
        child: Text(
          "Score : " + participants[index].score.toString(),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.appColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
