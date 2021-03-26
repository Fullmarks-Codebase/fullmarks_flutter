import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CustomQuizResponse.dart';
import 'package:fullmarks/models/LiveQuizReadyResponse.dart';
import 'package:fullmarks/models/LiveQuizResponse.dart';
import 'package:fullmarks/models/LiveQuizUsersResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:share/share.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'AddFriendScreen.dart';
import 'HomeScreen.dart';
import 'LiveQuizPlayScreen.dart';

class CreateQuizLobbyScreen extends StatefulWidget {
  SubjectDetails subject;
  CustomQuizDetails customQuiz;
  bool isCustomQuiz;
  int seconds;
  CreateQuizLobbyScreen({
    @required this.subject,
    @required this.customQuiz,
    @required this.isCustomQuiz,
    @required this.seconds,
  });
  @override
  _CreateQuizLobbyScreenState createState() => _CreateQuizLobbyScreenState();
}

class _CreateQuizLobbyScreenState extends State<CreateQuizLobbyScreen> {
  bool _isLoading = false;
  LiveQuizDetails liveQuizDetail;
  IO.Socket socket = IO
      .io(
        AppStrings.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build(),
      )
      .connect();
  Customer customer = Utility.getCustomer();
  List<LiveQuizUsersDetails> participants = [
    LiveQuizUsersDetails(
      id: 0,
      score: 0,
      socketId: "",
      submitted: false,
      user: Utility.getCustomer(),
    )
  ];
  String waitingText = "";
  Timer _timer;
  int _start = 5;
  Timer _timerInternet;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.createQuizLobbyEvent);
    getQuestionsAndRoom();
    socket.on(AppStrings.allParticipants, (data) {
      print(AppStrings.allParticipants);
      print(data);
      LiveQuizUsersResponse response =
          LiveQuizUsersResponse.fromJson(json.decode(jsonEncode(data)));
      if (response.users.length != 0) {
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
      //hide progress
      _isLoading = false;
      _notify();
      Utility.showToast(context, jsonEncode(data));
    });

    socket.on(AppStrings.join, (data) {
      print(AppStrings.join);
      print(data);
      socket.emit(AppStrings.userDetails);
    });

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
    super.initState();
  }

  getQuestionsAndRoom() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      if (widget.subject != null) {
        request["subjectId"] = widget.subject.id.toString();
      } else {
        request["customMasterId"] = widget.customQuiz.id.toString();
      }
      request["timeLimit"] = widget.seconds.toString();

      //api call
      LiveQuizResponse response = LiveQuizResponse.fromJson(
        await ApiManager(context).postCall(
            url: widget.subject == null
                ? AppStrings.liveQuizCustom
                : AppStrings.liveQuizBySubject,
            request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        liveQuizDetail = response.result;
        _notify();
        //join room after creating quiz
        socket.emit(AppStrings.room, {
          "room": liveQuizDetail.room.room,
          "id": Utility.getCustomer().id,
          "userObj": Utility.getCustomer(),
        });
        print("room join");
        socket.emit(AppStrings.userDetails);
      } else {
        Utility.showToast(context, response.message);
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
            body(),
            _isLoading ? Utility.progress(context) : Container(),
          ],
        ),
      ),
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

  Widget body() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utility.appbar(
            context,
            text: "Create New Quiz",
            isHome: false,
            textColor: Colors.white,
            onBackPressed: _onBackPressed,
          ),
          liveQuizDetail == null ? Container() : roomIdView(),
          liveQuizDetail == null ? Container() : participantsView(),
          liveQuizDetail == null ? Container() : participantsList(),
          liveQuizDetail == null
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    right: 16,
                    left: 16,
                    bottom: 80,
                  ),
                  child: _timer != null
                      ? waitingView()
                      : Utility.button(
                          context,
                          onPressed: () async {
                            //delay to give ripple effect
                            await Future.delayed(
                                Duration(milliseconds: AppStrings.delay));

                            if (participants.length == 1) {
                              Utility.showToast(context,
                                  "Quiz cannot start with 1 participants");
                            } else {
                              //if more than 1 participants then start quiz
                              socket.emit(AppStrings.startQuiz);

                              socket.on(AppStrings.getReady, (data) {
                                print(AppStrings.getReady);
                                print(data);
                                LiveQuizReadyResponse response =
                                    LiveQuizReadyResponse.fromJson(
                                        json.decode(jsonEncode(data)));
                                if (_timer == null) {
                                  startTimer(response.message);
                                }
                              });
                            }
                          },
                          text: "Start Play",
                          bgColor: AppColors.strongCyan,
                          assetName: AppAssets.enter,
                          isSufix: true,
                          isSpacer: true,
                        ),
                ),
        ],
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

  void startTimer(String message) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          _notify();
          //on timer complete go to play live quiz
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => LiveQuizPlayScreen(
                isRandomQuiz: false,
                questions: liveQuizDetail.questions,
                room: liveQuizDetail.room,
                isCustomQuiz: widget.isCustomQuiz,
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

  Widget participantsView() {
    return Container(
      margin: EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 16,
      ),
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
            "Participants",
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

  Widget roomIdView() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hey, You are created a room ",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  "room id : " + liveQuizDetail.room.room,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              // GestureDetector(
              //   child: Container(
              //     padding: EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //           offset: Offset(0, 1),
              //           blurRadius: 1,
              //           color: AppColors.appColor,
              //         ),
              //       ],
              //       shape: BoxShape.circle,
              //     ),
              //     child: SvgPicture.asset(AppAssets.share),
              //   ),
              //   onTap: () {},
              // ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: Utility.button(
                      //     context,
                      //     onPressed: () async {
                      //       //delay to give ripple effect
                      //       await Future.delayed(
                      //           Duration(milliseconds: AppStrings.delay));
                      //       Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AddFriendScreen(
                      //       buttonStr: "Share",
                      //       isShare: true,
                      //       title: "Contact",
                      //     ),
                      //   ),
                      // );
                      //     },
                      //     assetName: AppAssets.contact,
                      //     bgColor: AppColors.chartBgColor,
                      //     text: "Contact",
                      //     isPrefix: true,
                      //     isSpacer: true,
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 8,
                      // ),
                      Expanded(
                        child: Utility.button(
                          context,
                          onPressed: () async {
                            //delay to give ripple effect
                            await Future.delayed(
                                Duration(milliseconds: AppStrings.delay));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddFriendScreen(
                                  buttonStr: "Share",
                                  title: "My Friends",
                                  roomId: liveQuizDetail.room.room,
                                ),
                              ),
                            );
                          },
                          assetName: AppAssets.contacts,
                          bgColor: AppColors.chartBgColor,
                          text: "My Friends",
                          isPrefix: true,
                          isSpacer: true,
                          height: 50,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 1,
                            color: AppColors.appColor,
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(AppAssets.share),
                    ),
                    onTap: () {
                      Share.share(
                          Utility.getLiveQuizLink(liveQuizDetail.room.room));
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
