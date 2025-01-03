import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/LiveQuizResponse.dart';
import 'package:fullmarks/models/QuizLeaderBoardResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

class RankListScreen extends StatefulWidget {
  bool isRandomQuiz;
  String title;
  LiveQuizRoom room;
  IO.Socket socket;
  RankListScreen({
    @required this.isRandomQuiz,
    @required this.title,
    @required this.room,
    @required this.socket,
  });
  @override
  _RankListScreenState createState() => _RankListScreenState();
}

class _RankListScreenState extends State<RankListScreen> {
  IO.Socket socket;
  List<QuizLeaderBoardDetails> quizLeaderboard = List();
  Customer customer = Utility.getCustomer();
  String notSubmittedString = "";
  Timer _timerInternet;
  Timer _timerCheck;
  int myRank = -1;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    if (widget.isRandomQuiz) {
      AppFirebaseAnalytics.init()
          .logEvent(name: AppStrings.randomQuizRankEvent);
    } else {
      AppFirebaseAnalytics.init().logEvent(name: AppStrings.rankListEvent);
    }
    socket = widget.socket;
    socket.emit(AppStrings.submit);

    socket.on(AppStrings.notSubmitted, (data) {
      print(AppStrings.notSubmitted);
      print(data);
      if (data != null) {
        notSubmittedString = jsonEncode(data);
        _notify();
      }
    });

    socket.on(AppStrings.completed, (data) {
      print(AppStrings.completed);
      print(data);
      _getLeaderboard();
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

    _timerCheck = Timer.periodic(
        Duration(seconds: AppStrings.timerSecondsForCheck), (timer) {
      socket.emit(AppStrings.check, {
        "room": widget.room.room,
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    try {
      _timerInternet.cancel();
    } catch (e) {}
    try {
      _timerCheck.cancel();
    } catch (e) {}
    socket.emit(
      AppStrings.forceDisconnect,
      {"userObj": Utility.getCustomer()},
    );
    socket.destroy();
    super.dispose();
  }

  _getLeaderboard() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["mode"] = "quizResult";
      request["room"] = widget.room.room;
      request["roomId"] = widget.room.id.toString();
      //api call
      QuizLeaderBoardResponse response = QuizLeaderBoardResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.leaderboard, request: request),
      );

      if (response.code == 200) {
        quizLeaderboard = response.result;
        response.result.forEach((element) {
          if (element.user.id == customer.id) {
            myRank = element.rank;
          }
        });

        _timerCheck.cancel();
        _notify();
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
    return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
            (Route<dynamic> route) => false) ??
        false;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.title,
          homeassetName: AppAssets.home,
          textColor: Colors.white,
          onBackPressed: () {
            Navigator.pop(context);
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //       builder: (BuildContext context) => HomeScreen(),
            //     ),
            //     (Route<dynamic> route) => false);
          },
        ),
        ranklistView(),
      ],
    );
  }

  Widget noLeaderboardView() {
    return Utility.emptyView(
        notSubmittedString.trim().length == 0
            ? "Loading ..."
            : notSubmittedString,
        textColor: Colors.white);
  }

  Widget ranklistView() {
    return Expanded(
      child: quizLeaderboard.length == 0
          ? noLeaderboardView()
          : Container(
              margin: EdgeInsets.only(
                top: 0,
                right: 16,
                left: 16,
                bottom: 80,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(48),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(48),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Screenshot(
                        controller: screenshotController,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(48),
                              bottomRight: Radius.circular(16),
                              bottomLeft: Radius.circular(48),
                            ),
                          ),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              top: 32,
                              right: 16,
                              left: 16,
                            ),
                            itemCount: quizLeaderboard.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: AppColors.lightAppColor,
                                thickness: 1,
                              );
                            },
                            itemBuilder: (context, index) {
                              return rankItemView(index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Utility.button(
                      context,
                      onPressed: () async {
                        //delay to give ripple effect
                        await Future.delayed(
                            Duration(milliseconds: AppStrings.delay));
                        if (await Permission.storage.isGranted) {
                          shareRank();
                        } else {
                          Permission.storage.request().then((value) {
                            print(value);
                            if (value == PermissionStatus.granted) {
                              shareRank();
                            } else {
                              Utility.showToast(context,
                                  "Please grant permission to share your rank");
                            }
                          });
                        }
                      },
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      gradientColor1: AppColors.buttonGradient1,
                      gradientColor2: AppColors.buttonGradient2,
                      text: "Share",
                    ),
                  )
                ],
              ),
            ),
    );
  }

  shareRank() {
    screenshotController.capture().then((Uint8List image) {
      ImageGallerySaver.saveImage(
        image,
        isReturnImagePathOfIOS: true,
      ).then((value) {
        print(jsonEncode(value));
        if (value != null) {
          if (value["isSuccess"]) {
            Share.shareFiles(
              [value["filePath"].toString().replaceAll("file://", "")],
              text: Utility.getRankShareText(myRank),
            ).then((value) {
              print("share success");
            }).catchError((onError) {
              print(onError.toString());
            });
          }
        }
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget rankItemView(int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(
            AppAssets.rankItemBg,
            color: AppColors.lightAppColor,
          ),
        ),
        ListTile(
          leading: Utility.getUserImage(
            url: quizLeaderboard[index].user.thumbnail,
            bordercolor: AppColors.myProgressIncorrectcolor,
          ),
          title: Text(
            (quizLeaderboard[index].user.username.trim().length == 0
                    ? "User" + quizLeaderboard[index].user.id.toString()
                    : quizLeaderboard[index].user.username) +
                (quizLeaderboard[index].user.id == customer.id
                    ? " (You)"
                    : "") +
                (widget.isRandomQuiz
                    ? ""
                    : widget.room.userId == quizLeaderboard[index].user.id
                        ? " (Host)"
                        : ""),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            quizLeaderboard[index].points.toString() +
                " point" +
                (quizLeaderboard[index].points <= 1 ? "" : "s"),
            style: TextStyle(
              color: AppColors.appColor,
            ),
          ),
          trailing: Text(
            "#" + quizLeaderboard[index].rank.toString(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.appColor,
            ),
          ),
        ),
      ],
    );
  }
}
