import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:share/share.dart';

import 'AddFriendScreen.dart';
import 'LiveQuizPlayScreen.dart';

class CreateQuizLobbyScreen extends StatefulWidget {
  @override
  _CreateQuizLobbyScreenState createState() => _CreateQuizLobbyScreenState();
}

class _CreateQuizLobbyScreenState extends State<CreateQuizLobbyScreen> {
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utility.appbar(
            context,
            text: "Create New Quiz",
            isHome: false,
            textColor: Colors.white,
          ),
          roomIdView(),
          participantsView(),
          participantsList(),
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
              left: 16,
              bottom: 80,
            ),
            child: Utility.button(
              context,
              onPressed: () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LiveQuizPlayScreen(
                      isRandomQuiz: false,
                    ),
                  ),
                );
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
                  "room id : 1020",
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
                                  roomId: "1020",
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
                      Share.share(Utility.getLiveQuizLink("1020"));
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
