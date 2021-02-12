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
import 'package:fullmarks/utility/AppSocket.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:share/share.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'LiveQuizPlayScreen.dart';

class WaitingForHostScreen extends StatefulWidget {
  LiveQuizWelcomeResponse liveQuizWelcomeResponse;
  WaitingForHostScreen({
    @required this.liveQuizWelcomeResponse,
  });
  @override
  _WaitingForHostScreenState createState() => _WaitingForHostScreenState();
}

class _WaitingForHostScreenState extends State<WaitingForHostScreen> {
  LiveQuizUsersResponse liveQuizUsersResponse;
  IO.Socket socket = AppSocket.init();
  List<LiveQuizUsersDetails> participants = List();
  Customer customer = Utility.getCustomer();
  String waitingText = "Waiting for Host to Start the Quiz...";
  Timer _timer;
  int _start = 5;

  @override
  void initState() {
    super.initState();
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
      Utility.showToast(jsonEncode(data));
    });

    //when any user disconnects or leaves quiz
    socket.on(AppStrings.disconnected, (data) {
      print(AppStrings.disconnected);
      print(data);
      socket.emit(AppStrings.userDetails);
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
            Share.share(Utility.getLiveQuizLink(
                widget.liveQuizWelcomeResponse.room.room));
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
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              AppStrings.userImage + participants[index].user.thumbnail,
            ),
          ),
          border: Border.all(
            color: participants[index].user.id == customer.id
                ? AppColors.myProgressIncorrectcolor
                : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      title: Text(
        participants[index].user.username +
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
