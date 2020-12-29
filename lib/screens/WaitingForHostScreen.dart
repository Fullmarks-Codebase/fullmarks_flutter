import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'LiveQuizPlayScreen.dart';

class WaitingForHostScreen extends StatefulWidget {
  @override
  _WaitingForHostScreenState createState() => _WaitingForHostScreenState();
}

class _WaitingForHostScreenState extends State<WaitingForHostScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), gotoHome);
  }

  gotoHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => LiveQuizPlayScreen(
          isRandomQuiz: false,
        ),
      ),
    );
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
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Join Quiz",
          textColor: Colors.white,
          onBackPressed: () {
            Navigator.pop(context);
          },
          homeassetName: AppAssets.share,
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
            "Participants (15)",
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
        itemCount: 15,
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
            image: AssetImage(AppAssets.dummyUser),
          ),
          border: Border.all(
            color: index == 0
                ? AppColors.myProgressIncorrectcolor
                : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      title: Text(
        'User Name' + (index == 0 ? " (You)" : ""),
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
        "Waiting for Host to Start the Quiz...",
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
