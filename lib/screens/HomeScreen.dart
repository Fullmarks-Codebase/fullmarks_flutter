import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/ChangeGradeScreen.dart';
import 'package:fullmarks/screens/LiveQuizScreen.dart';
import 'package:fullmarks/screens/LoginScreen.dart';
import 'package:fullmarks/screens/MockTestScreen.dart';
import 'package:fullmarks/screens/MyFriendsScreen.dart';
import 'package:fullmarks/screens/MyProfileScreen.dart';
import 'package:fullmarks/screens/MyProgressScreen.dart';
import 'package:fullmarks/screens/NotificationListScreen.dart';
import 'package:fullmarks/screens/SubTopicScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'AskingForProgressScreen.dart';
import 'DiscussionScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  ScrollController controller;
  bool isProgress = true;
  List<Subject> subjects = Utility.getsubjects();
  Customer customer;

  @override
  void initState() {
    controller = ScrollController();
    customer = Utility.getCustomer();
    _notify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      drawer: customer == null ? null : drawer(),
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          body()
        ],
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.drawerBg),
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Utility.getUserImageView(80),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Utility.getUsername(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(AppAssets.class1),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Class Four',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(AppAssets.notification),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                NotificationListScreen(),
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              drawerItemView(
                assetName: AppAssets.drawerMyProgress,
                text: "My Progress",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProgressScreen(),
                    ),
                  );
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerMyProfile,
                text: "My Profile",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfileScreen(),
                    ),
                  );
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerChangeGrade,
                text: "Change Grade",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeGradeScreen(),
                    ),
                  );
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerMockTest,
                text: "Mock Test",
                onTap: () {
                  Navigator.pop(context);
                  mockTestTap();
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerLiveQuiz,
                text: "Live Quizzes",
                onTap: () {
                  Navigator.pop(context);
                  liveQuizTap();
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerDiscussion,
                text: "Discussion",
                onTap: () {
                  Navigator.pop(context);
                  discussionTap();
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerMyBuddies,
                text: "My Buddies",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFriendsScreen(),
                    ),
                  );
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerShareApp,
                text: "Share this App",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerRateApp,
                text: "Rate Us",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerLogout,
                text: "Logout",
                onTap: () {
                  Navigator.pop(context);
                  //remove user preference
                  PreferenceUtils.remove(AppStrings.userPreference);
                  //remove intro slider seen preference
                  PreferenceUtils.remove(AppStrings.introSliderPreference);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget drawerItemView({
    @required String assetName,
    @required String text,
    @required Function onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 55,
              child: SvgPicture.asset(
                assetName,
                height: 15,
                width: 15,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        toolbarView(),
        Expanded(
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                myProgressView(),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Practice Subject",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                subjectView(),
                SizedBox(
                  height: 16,
                ),
                horizontalView(),
                SizedBox(
                  height: 16,
                ),
                horizontalItemView(
                  color: AppColors.appColor,
                  assetName: AppAssets.shareApp,
                  text: "Share this App to your friends",
                  buttonText: "Share this App",
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {},
                ),
                SizedBox(
                  height: 16,
                ),
                horizontalItemView(
                  color: AppColors.strongCyan,
                  assetName: AppAssets.rateUs,
                  text: "",
                  buttonText: "Rate Us!",
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  onTap: () {},
                ),
                Utility.roundShadowButton(
                  context: context,
                  assetName: AppAssets.upArrow,
                  onPressed: () {
                    controller.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  discussionTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            customer == null ? AskingForProgressScreen() : DiscussionScreen(),
      ),
    );
  }

  liveQuizTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            customer == null ? AskingForProgressScreen() : LiveQuizScreen(),
      ),
    );
  }

  mockTestTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            customer == null ? AskingForProgressScreen() : MockTestScreen(),
      ),
    );
  }

  Widget horizontalView() {
    return CarouselSlider(
      options: CarouselOptions(
        initialPage: 0,
        enableInfiniteScroll: false,
        height: 150.0,
        viewportFraction: 0.85,
      ),
      items: [
        horizontalItemView(
          color: AppColors.introColor4,
          assetName: AppAssets.liveQuiz,
          text: "Play Live Quiz with friends and other students",
          buttonText: "Live Quiz",
          margin: EdgeInsets.only(
            right: 8,
          ),
          onTap: () {
            liveQuizTap();
          },
        ),
        horizontalItemView(
          color: AppColors.mockTestColor,
          assetName: AppAssets.mockTest,
          text: "Full mock tests and see All India Performance",
          buttonText: "Mock Test",
          margin: EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          onTap: () {
            mockTestTap();
          },
        ),
        horizontalItemView(
          color: AppColors.discussionForumColor,
          assetName: AppAssets.discussionForum,
          text: "Get answers to any question by asking our live community",
          buttonText: "Discussion forum",
          margin: EdgeInsets.only(
            left: 8,
          ),
          onTap: () {
            discussionTap();
          },
        ),
      ],
    );
  }

  Widget horizontalItemView({
    @required Color color,
    @required String assetName,
    @required String text,
    @required String buttonText,
    EdgeInsets margin,
    @required Function onTap,
  }) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SvgPicture.asset(assetName),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                text.trim().length == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                          (index) => SvgPicture.asset(AppAssets.star),
                        ),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                SizedBox(
                  height: 8,
                ),
                Utility.button(
                  context,
                  onPressed: onTap,
                  text: buttonText,
                  gradientColor1: Color(0xff76B5FF),
                  gradientColor2: Color(0xff4499FF),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  fontSize: 14,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget subjectView() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 16.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return subjectItemView(index);
      },
    );
  }

  Widget subjectItemView(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubTopicScreen(
              subjectName: subjects[index].title,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: SvgPicture.asset(
                subjects[index].assetName,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              subjects[index].title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FittedBox(
                child: Text(
                  subjects[index].subtitle,
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget myProgressView() {
    return customer == null
        ? Utility.noUserProgressView(context)
        : GestureDetector(
            onTap: () {
              isProgress = !isProgress;
              _notify();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.chartBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: isProgress ? progressView() : noProgressView(),
            ),
          );
  }

  Widget noProgressView() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SvgPicture.asset(AppAssets.sad),
          SizedBox(
            height: 8,
          ),
          Text(
            "No progress found",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "give a test to see progress",
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

  Widget progressView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: (MediaQuery.of(context).size.width / 2),
            child: Utility.pieChart(),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Progress",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Utility.correctIncorrectView(
                color: AppColors.myProgressCorrectcolor,
                title: "Incorrect: 5",
              ),
              SizedBox(
                height: 8,
              ),
              Utility.correctIncorrectView(
                color: AppColors.myProgressIncorrectcolor,
                title: "Correct: 120",
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                thickness: 1,
                color: Colors.white.withOpacity(0.5),
              ),
              SizedBox(
                height: 8,
              ),
              Utility.averageView(
                assetName: AppAssets.avgAccuracy,
                title: "Avg. Accuracy = 82%",
              ),
              SizedBox(
                height: 8,
              ),
              Utility.averageView(
                assetName: AppAssets.avgTime,
                title: "Avg. Time/Question = 1:15",
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget toolbarView() {
    return customer == null
        ? SafeArea(
            bottom: false,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Class - Seven',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    onPressed: null,
                  )
                ],
              ),
            ),
          )
        : Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Utility.roundShadowButton(
                context: context,
                assetName: AppAssets.drawer,
                onPressed: () {
                  scafoldKey.currentState.openDrawer();
                },
              ),
              Spacer(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  top: 16,
                ),
                child: Row(
                  children: [
                    Text(
                      Utility.getUsername(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Utility.getUserImageView(50),
                  ],
                ),
              )
            ],
          );
  }
}
