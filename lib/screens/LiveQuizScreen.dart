import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/MyLeaderBoardResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/AddFriendScreen.dart';
import 'package:fullmarks/screens/CreateNewQuizScreen.dart';
import 'package:fullmarks/screens/JoinQuizScreen.dart';
import 'package:fullmarks/screens/LeaderboardScreen.dart';
import 'package:fullmarks/screens/MyFriendsScreen.dart';
import 'package:fullmarks/screens/SubjectSelectionScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class LiveQuizScreen extends StatefulWidget {
  @override
  _LiveQuizScreenState createState() => _LiveQuizScreenState();
}

class _LiveQuizScreenState extends State<LiveQuizScreen> {
  Customer customer;
  String points = "-";
  String games = "-";
  String rank = "-";

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.liveQuizHomeScreenEvent);
    _getLeaderboard();
    super.initState();
  }

  _getLeaderboard() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["mode"] = "solo";
      //api call
      MyLeaderBoardResponse response = MyLeaderBoardResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.leaderboard, request: request),
      );

      if (response.code == 200) {
        if (response.result != null) {
          customer = response.result;
          _notify();
          if (customer.reportMaster.length != 0) {
            points = customer.reportMaster.first.points;
            games = customer.reportMaster.first.gamePlayed.toString();
            rank = customer.reportMaster.first.rank.toString();
            _notify();
          }
        }
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
    print(MediaQuery.of(context).size.width / 1.5);
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
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
          text: "Quizzes",
          isHome: false,
        ),
        liveQuizView(),
      ],
    );
  }

  Widget liveQuizView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            children: [
              leaderboardView(),
              addFriendView(),
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinQuizScreen(),
                    ),
                  );
                  _getLeaderboard();
                },
                text: "Join a Quiz",
                assetName: AppAssets.join,
                isSufix: true,
                gradientColor1: AppColors.setsItemGradientColor1,
                gradientColor2: AppColors.setsItemGradientColor2,
                isSpacer: true,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewQuizScreen(),
                    ),
                  );
                  _getLeaderboard();
                },
                text: "Create New Quiz",
                bgColor: AppColors.strongCyan,
                assetName: AppAssets.newQuiz,
                isPrefix: true,
                isSpacer: true,
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectSelectionScreen(
                        title: "Random Quiz",
                        isRandomQuiz: true,
                      ),
                    ),
                  );
                  _getLeaderboard();
                },
                text: "Random Quiz",
                gradientColor1: AppColors.buttonGradient1,
                gradientColor2: AppColors.buttonGradient2,
                assetName: AppAssets.random,
                isSufix: true,
                isSpacer: true,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addFriendView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.subtopicItemBorderColor,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      padding: EdgeInsets.all(
        16,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 15,
            child: SvgPicture.asset(AppAssets.challenge),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 20,
            child: Column(
              children: [
                Text(
                  "Challange your Friends to a Quizzes Game",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 8,
                ),
                Utility.button(
                  context,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFriendScreen(
                          buttonStr: "Send Request",
                          title: "Add a Friend",
                          roomId: null,
                        ),
                      ),
                    );
                    _getLeaderboard();
                  },
                  assetName: AppAssets.addFriend,
                  text: "Add a Friend",
                  borderColor: AppColors.friendBorderColor,
                  isPrefix: true,
                ),
                SizedBox(
                  height: 8,
                ),
                Utility.button(
                  context,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyFriendsScreen(),
                      ),
                    );
                    _getLeaderboard();
                  },
                  assetName: AppAssets.contacts,
                  text: "My Friends",
                  borderColor: AppColors.friendBorderColor,
                  isPrefix: true,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget leaderboardView() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: 50,
            bottom: 16,
          ),
          padding: EdgeInsets.only(
            top: 58,
            right: 16,
            left: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.chartBgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                Utility.getUsername(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Spacer(),
                    SvgPicture.asset(AppAssets.coins),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      points + " Points",
                      style: TextStyle(
                        color: AppColors.myProgressIncorrectcolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    VerticalDivider(
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    SvgPicture.asset(AppAssets.game),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      games + " Games",
                      style: TextStyle(
                        color: AppColors.myProgressIncorrectcolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.trophy),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Leaderboard Rank : " + rank,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardScreen(),
                        ),
                      );
                      _getLeaderboard();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(AppAssets.rightArrow2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        getUserImageView(100)
      ],
    );
  }

  Widget getUserImageView(double size) {
    Customer customer = Utility.getCustomer();
    return customer == null
        ? dummyUserView(size)
        : customer.thumbnail == ""
            ? dummyUserView(size)
            : Utility.getUserImage(
                url: customer.thumbnail,
                bordercolor: AppColors.chartBgColor,
                height: size,
                width: size,
              );
  }

  Widget dummyUserView(double size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.chartBgColor,
          width: 2,
        ),
      ),
      height: size,
      width: size,
      child: Icon(
        Icons.person,
        color: AppColors.chartBgColor,
        size: size / 2,
      ),
    );
  }
}
