import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/DisconnectedResponse.dart';
import 'package:fullmarks/models/LiveQuizResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/RandomQuizParticipantsResponse.dart';
import 'package:fullmarks/models/RandomQuizWelcomeResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'LiveQuizPlayScreen.dart';

class RandomQuizMatchScreen extends StatefulWidget {
  SubjectDetails subject;
  RandomQuizMatchScreen({
    @required this.subject,
  });
  @override
  _RandomQuizMatchScreenState createState() => _RandomQuizMatchScreenState();
}

class _RandomQuizMatchScreenState extends State<RandomQuizMatchScreen> {
  IO.Socket socket = IO
      .io(
        AppStrings.baseUrl + "random",
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build(),
      )
      .connect();
  Customer customer = Utility.getCustomer();
  Timer _timer;
  Timer _timerInternet;
  Timer _timerNoPlayerAvailable;
  int _start = 5;
  int _startNoPlayerAvailable = (3 * 60); //3 min
  List<QuestionDetails> questions = List();
  Customer user1;
  Customer user2;
  int room = 0;
  int roomId = 0;
  bool isDisconnectMessageShown = false;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.randomQuizMatchEvent);
    user1 = Utility.getCustomer();
    var chooseData = {
      "users": customer,
      "data": {
        "subjectId": widget.subject.id,
        "classId": customer.classGrades.id
      }
    };
    socket.emit(AppStrings.choose, chooseData);

    startTimerNoPlayerAvailable();

    socket.on(AppStrings.welcome, (data) {
      print(AppStrings.welcome);
      print(jsonEncode(data));
      RandomQuizWelcomeResponse randomQuizWelcomeResponse =
          RandomQuizWelcomeResponse.fromJson(jsonDecode(jsonEncode(data)));
      room = randomQuizWelcomeResponse.room;
      roomId = randomQuizWelcomeResponse.roomId;
      Utility.showToast(context, randomQuizWelcomeResponse.message);
      questions = randomQuizWelcomeResponse.questions;
      _notify();
      socket.emit(
          AppStrings.userDetails, {"room": randomQuizWelcomeResponse.room});
    });

    socket.on(AppStrings.allParticipants, (data) {
      print(AppStrings.allParticipants);
      print(jsonEncode(data));
      RandomQuizParticipantsResponse randomQuizParticipantsResponse =
          RandomQuizParticipantsResponse.fromJson(jsonDecode(jsonEncode(data)));
      try {
        if (user1.id == randomQuizParticipantsResponse.users[0].user.id) {
          user1 = randomQuizParticipantsResponse.users[0].user;
          user2 = randomQuizParticipantsResponse.users[1].user;
        } else {
          user1 = randomQuizParticipantsResponse.users[1].user;
          user2 = randomQuizParticipantsResponse.users[0].user;
        }
      } catch (e) {
        user2 = null;
      }

      _notify();
      if (user1 != null && user2 != null) {
        if (_timer == null) {
          startTimer();
        }
      }
    });

    socket.on(AppStrings.disconnected, (data) {
      print(AppStrings.disconnected + " match screen");
      print(data);
      DisconnectedResponse disconnectedResponse =
          DisconnectedResponse.fromJson(jsonDecode(jsonEncode(data)));
      if ((disconnectedResponse.users.userId != Utility.getCustomer().id) &&
          !isDisconnectMessageShown) {
        Utility.showToast(
          context,
          disconnectedResponse.message,
        );
        socket.emit(
          AppStrings.forceDisconnect,
        );
        if (context != null) Navigator.pop(context);
      }
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

    super.initState();
  }

  void startTimer() {
    _timerNoPlayerAvailable.cancel();
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start == 0) {
          timer.cancel();
          _notify();

          //on timer complete go to play live quiz
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => LiveQuizPlayScreen(
                isRandomQuiz: true,
                isCustomQuiz: false,
                questions: questions,
                room: LiveQuizRoom(
                  id: roomId,
                  room: room.toString(),
                  userId: Utility.getCustomer().id,
                ),
                socket: socket,
              ),
            ),
          );
        } else {
          _start--;
          _notify();
        }
      },
    );
  }

  void startTimerNoPlayerAvailable() {
    const oneSec = const Duration(seconds: 1);
    _timerNoPlayerAvailable = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_startNoPlayerAvailable == 0) {
          timer.cancel();
          _notify();

          //on timer complete
          Utility.showToast(context, "No Player Available");
          socket.emit(
            AppStrings.forceDisconnect,
          );
          Navigator.pop(context);
        } else {
          _startNoPlayerAvailable--;
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
    try {
      _timerNoPlayerAvailable.cancel();
    } catch (e) {}
    super.dispose();
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
          text: questions.length != 0 && user1 != null && user2 != null
              ? "Matched"
              : "Searching for Player",
          isHome: false,
          textColor: Colors.white,
          onBackPressed: _onBackPressed,
        ),
        userImageView(),
        searchingView(),
        SizedBox(
          height: 16,
        ),
        Expanded(child: SvgPicture.asset(AppAssets.fly)),
        SizedBox(
          height: 16,
        ),
        Text(
          questions.length != 0 && user1 != null && user2 != null
              ? "Get Ready to Play in  $_start  Second..."
              : "",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 32,
        )
      ],
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget searchingView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: questions.length != 0 && user1 != null && user2 != null
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        searchingText(user1.username.trim().length == 0
                            ? "User" + user1.id.toString()
                            : user1.username),
                        SizedBox(
                          height: 16,
                        ),
                        searchingText("India"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "VS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        searchingText(user2.username.trim().length == 0
                            ? "User" + user2.id.toString()
                            : user2.username),
                        SizedBox(
                          height: 16,
                        ),
                        searchingText("India"),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                child: searchingText("Searching..."),
              ),
      ),
    );
  }

  Widget searchingText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.myProgressIncorrectcolor,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  Widget userImageView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(AppAssets.randomQuizSearchBg),
            Row(
              children: [
                Expanded(
                  flex: 13,
                  child: Container(),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Utility.getUserImage(
                          url: user1.thumbnail,
                          height: 70,
                          width: 70,
                          borderRadius: 70,
                          borderWidth: 3,
                          bordercolor: AppColors.myProgressIncorrectcolor,
                          placeholderColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      questions.length != 0 && user1 != null && user2 != null
                          ? Utility.getUserImage(
                              url: user2.thumbnail,
                              height: 70,
                              width: 70,
                              borderRadius: 70,
                              bordercolor: AppColors.myProgressIncorrectcolor,
                              borderWidth: 3,
                              placeholderColor: Colors.white,
                            )
                          : Container(
                              height: 80,
                              width: 80,
                              child: SvgPicture.asset(AppAssets.user),
                            )
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Container(),
                ),
              ],
            ),
            Container(
              height: 50,
              width: 50,
              child: Utility.imageLoader(
                baseUrl: AppStrings.subjectImage,
                url: widget.subject.image,
                placeholder: AppAssets.subjectPlaceholder,
                fit: BoxFit.contain,
                placeholderColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
