import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/LiveQuizReadyResponse.dart';
import 'package:fullmarks/models/LiveQuizUsersResponse.dart';
import 'package:fullmarks/models/LiveQuizWelcomeResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:share/share.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'HomeScreen.dart';
import 'LiveQuizPlayScreen.dart';

class WaitingForHostScreen extends StatefulWidget {
  LiveQuizWelcomeResponse liveQuizWelcomeResponse;
  IO.Socket socket;
  int seconds;
  WaitingForHostScreen({
    @required this.liveQuizWelcomeResponse,
    @required this.socket,
    @required this.seconds,
  });
  @override
  _WaitingForHostScreenState createState() => _WaitingForHostScreenState();
}

class _WaitingForHostScreenState extends State<WaitingForHostScreen> {
  LiveQuizUsersResponse liveQuizUsersResponse;
  List<LiveQuizUsersDetails> participants = List();
  Customer customer = Utility.getCustomer();
  String waitingText = "Waiting for Host to Start the Quiz...";
  Timer _timer;
  Timer _timerInternet;
  int _start = 5;
  IO.Socket socket;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.waitingForHostEvent);
    super.initState();
    socket = widget.socket;
    //when this is emited then get all participants
    socket.emit(AppStrings.userDetails);

    //when any participants joins
    socket.on(AppStrings.join, (data) {
      print(AppStrings.join);
      print(data);
      socket.emit(AppStrings.userDetails);
    });

    //this will start quiz when host press start quiz button
    socket.on(AppStrings.getReady, (data) {
      print(AppStrings.getReady);
      print(data);
      LiveQuizReadyResponse response =
          LiveQuizReadyResponse.fromJson(json.decode(jsonEncode(data)));
      if (_timer == null) {
        startTimer(response.message);
      }
    });

    //this will return all Participants
    socket.on(AppStrings.allParticipants, (data) {
      // print(AppStrings.allParticipants);
      // print(data);
      LiveQuizUsersResponse response =
          LiveQuizUsersResponse.fromJson(json.decode(jsonEncode(data)));
      if (response?.users?.length != 0) {
        participants = response.users;
        _notify();
      }
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

    //when any user disconnects or leaves quiz
    socket.on(AppStrings.disconnected, (data) {
      print(AppStrings.disconnected);
      print(data);
      socket.emit(AppStrings.userDetails);
    });

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

  void startTimer(String message) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start == 0) {
          timer.cancel();
          _notify();
          List<QuestionDetails> questions = List();
          bool isCustomQuiz = false;
          await Future.forEach(widget.liveQuizWelcomeResponse.questions,
              (LiveQuizWelcomeDetails element) {
            if (element.fixQuestion != null) {
              questions.add(element.fixQuestion);
              isCustomQuiz = false;
              _notify();
            } else {
              questions.add(element.customQuestion);
              isCustomQuiz = true;
              _notify();
            }
          });
          //on timer complete go to play live quiz
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => LiveQuizPlayScreen(
                isRandomQuiz: false,
                questions: questions,
                room: widget.liveQuizWelcomeResponse.room,
                isCustomQuiz: isCustomQuiz,
                socket: socket,
                seconds: widget.seconds,
              ),
            ),
          );
        } else {
          waitingText = message + " " + _start.toString();
          _start--;
          _notify();
        }
      },
    );
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
            body(),
          ],
        ),
      ),
    );
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
            Navigator.pop(context);
            return true;
          },
        ) ??
        false;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Join Quiz",
          textColor: Colors.white,
          homeassetName: AppAssets.share,
          onHomePressed: () {
            Share.share(
              Utility.getLiveQuizLink(
                widget.liveQuizWelcomeResponse.room.room,
                widget.liveQuizWelcomeResponse.questions[0].fixQuestion != null
                    ? widget.liveQuizWelcomeResponse.questions[0].fixQuestion
                        .classGrades.name
                    : widget.liveQuizWelcomeResponse.questions[0].customQuestion
                        .customMaster.classDetails.name,
                widget.liveQuizWelcomeResponse.questions[0].fixQuestion != null
                    ? widget.liveQuizWelcomeResponse.questions[0].fixQuestion
                        .subject.name
                    : null,
              ),
            );
          },
          onBackPressed: _onBackPressed,
        ),
        waitingView(),
        participantsView(),
        participantsList(),
      ],
    );
  }

  Widget participantsView() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.participants,
            color: Colors.white,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            "Participants (" + participants.length.toString() + ")",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget participantsList() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(
          bottom: 16,
        ),
        itemCount: participants.length,
        itemBuilder: (BuildContext context, int index) {
          return participantsItemView(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  Widget participantsItemView(int index) {
    return ListTile(
      leading: Utility.getUserImage(
        url: participants[index].user.thumbnail,
        bordercolor: participants[index].user.id == customer.id
            ? AppColors.myProgressIncorrectcolor
            : AppColors.whiteColor,
        borderWidth: 3,
        placeholderColor: Colors.white,
      ),
      title: Text(
        (participants[index].user.username.trim().length == 0
                ? "User" + participants[index].user.id.toString()
                : participants[index].user.username) +
            (participants[index].user.id == customer.id ? " (You)" : ""),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget waitingView() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.myProgressIncorrectcolor,
          width: 5,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(4),
          topLeft: Radius.circular(4),
        ),
      ),
      child: Text(
        waitingText,
        style: TextStyle(
          color: AppColors.appColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
