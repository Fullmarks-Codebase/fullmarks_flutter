import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/main.dart';
import 'package:fullmarks/models/LiveQuizWelcomeResponse.dart';
import 'package:fullmarks/screens/WaitingForHostScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JoinQuizScreen extends StatefulWidget {
  String roomId;
  JoinQuizScreen({
    this.roomId = "",
  });
  @override
  _JoinQuizScreenState createState() => _JoinQuizScreenState();
}

class _JoinQuizScreenState extends State<JoinQuizScreen> {
  TextEditingController roomIdController = TextEditingController();
  IO.Socket socket = IO
      .io(
        AppStrings.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build(),
      )
      .connect();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.joinQuizEvent);
    selectNotificationSubject.add(null);
    roomIdController.text = widget.roomId;
    //this will get room and questions
    socket.on(AppStrings.welcome, (data) {
      print(AppStrings.welcome);
      print(data);
      //hide progress
      _isLoading = false;
      _notify();
      LiveQuizWelcomeResponse response =
          LiveQuizWelcomeResponse.fromJson(json.decode(jsonEncode(data)));
      Utility.showToast(context, response.message);
      print(jsonEncode(response.questions[0].customQuestion));
      if (context != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingForHostScreen(
              liveQuizWelcomeResponse: response,
              socket: socket,
              seconds: int.tryParse(response.room.timeLimit),
            ),
          ),
        );
      }
    });

    socket.on(AppStrings.sessionFull, (data) {
      print(AppStrings.sessionFull);
      print(data);
      //hide progress
      _isLoading = false;
      _notify();
      Utility.showToast(context, jsonEncode(data));
    });

    //this shows error from socket
    socket.onError((data) {
      print("onError");
      print(data);
      //hide progress
      _isLoading = false;
      _notify();
    });

    // this is manual error
    socket.on(AppStrings.error, (data) {
      print(AppStrings.error);
      print(data);
      //hide progress
      _isLoading = false;
      _notify();
      Utility.showToast(context, jsonEncode(data));
    });
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _isLoading ? Utility.progress(context) : Container()
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "",
          isHome: false,
        ),
        Spacer(),
        _isLoading
            ? Container()
            : Text(
                "Join Quiz",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
        _isLoading
            ? Container()
            : Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  controller: roomIdController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter Room Id",
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
        _isLoading
            ? Container()
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Utility.button(
                  context,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    if (roomIdController.text.trim().length == 0) {
                      // showGeneralDialog(
                      //   barrierLabel: "Barrier",
                      //   barrierDismissible: true,
                      //   barrierColor: Colors.black.withOpacity(0.5),
                      //   transitionDuration: Duration(milliseconds: 700),
                      //   context: context,
                      //   pageBuilder: (_, __, ___) {
                      //     return Align(
                      //       alignment: Alignment.center,
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         width: MediaQuery.of(context).size.width / 2,
                      //         height: 50,
                      //         child: SizedBox.expand(
                      //           child: Material(
                      //             color: Colors.transparent,
                      //             child: Container(
                      //               alignment: Alignment.center,
                      //               child: Text(
                      //                 "Room id is required",
                      //                 style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         margin: EdgeInsets.only(
                      //             bottom: 50, left: 12, right: 12),
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(40),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      //   transitionBuilder: (_, anim, __, child) {
                      //     return SlideTransition(
                      //       position:
                      //           Tween(begin: Offset(0, 1), end: Offset(0, 0))
                      //               .animate(anim),
                      //       child: child,
                      //     );
                      //   },
                      // );
                      Utility.showToast(context, "Room id is required");
                    } else {
                      //show progress
                      _isLoading = true;
                      _notify();

                      //this "room" emit will create room
                      // this will listen to "welcome" event and go to WaitingForHostScreen screen
                      socket.emit(AppStrings.room, {
                        "room": roomIdController.text.trim(),
                        "id": Utility.getCustomer().id,
                        "userObj": Utility.getCustomer(),
                      });
                    }
                  },
                  text: "Enter",
                  bgColor: AppColors.myProgressCorrectcolor,
                  isSufix: true,
                  assetName: AppAssets.enter,
                  isSpacer: true,
                ),
              ),
        Spacer(),
        Spacer(),
      ],
    );
  }
}
