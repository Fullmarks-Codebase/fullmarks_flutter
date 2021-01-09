import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/ChangeGradeScreen.dart';
import 'package:fullmarks/screens/LiveQuizScreen.dart';
import 'package:fullmarks/screens/MockTestScreen.dart';
import 'package:fullmarks/screens/MyFriendsScreen.dart';
import 'package:fullmarks/screens/MyProfileScreen.dart';
import 'package:fullmarks/screens/MyProgressScreen.dart';
import 'package:fullmarks/screens/NotificationListScreen.dart';
import 'package:fullmarks/screens/SubTopicScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/FirebaseMessagingService.dart';
import 'package:fullmarks/utility/Utiity.dart';

import '../main.dart';
import 'AskingForProgressScreen.dart';
import 'DiscussionScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  ScrollController controller;
  bool isProgress = false;
  List<SubjectDetails> subjects = List();
  bool _isLoading = false;
  Customer customer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _requestPermissions();
    FirebaseMessagingService().getMessage();
    controller = ScrollController();
    _getUser();
    _getSubjects();
    _notify();
    super.initState();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  _getUser() {
    customer = Utility.getCustomer();
    _notify();
  }

  _getSubjects() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      SubjectsResponse response = SubjectsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.subjects, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        subjects = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      drawer: customer == null ? null : drawer(),
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          body(),
        ],
      ),
    );
  }

  Widget getUserImageView(double size) {
    Customer customer = Utility.getCustomer();
    return customer == null
        ? dummyUserView(size)
        : customer.userProfileImage == ""
            ? dummyUserView(size)
            : Container(
                margin: EdgeInsets.all(16),
                height: size,
                width: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.appColor,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                        AppStrings.userImage + customer.userProfileImage),
                  ),
                ),
              );
  }

  Widget dummyUserView(double size) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.appColor,
          width: 2,
        ),
      ),
      height: size,
      width: size,
      child: Icon(
        Icons.person,
        color: AppColors.appColor,
        size: size / 2,
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
                      getUserImageView(80),
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
                                  customer.classGrades.name,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      ClipOval(
                        child: Material(
                          color: Colors.white, // button color
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: SvgPicture.asset(AppAssets.notification),
                            ),
                            onTap: () async {
                              //delay to give ripple effect
                              await Future.delayed(
                                  Duration(milliseconds: AppStrings.delay));
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    NotificationListScreen(),
                              ));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              drawerItemView(
                assetName: AppAssets.drawerMyProgress,
                text: "My Progress",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
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
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfileScreen(),
                    ),
                  );
                  _getUser();
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerChangeGrade,
                text: "Change Grade",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeGradeScreen(),
                    ),
                  );
                  _getUser();
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerMockTest,
                text: "Mock Test",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  mockTestTap();
                },
                iscomingsoon: true,
              ),
              drawerItemView(
                assetName: AppAssets.drawerLiveQuiz,
                text: "Live Quizzes",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  liveQuizTap();
                },
                iscomingsoon: true,
              ),
              drawerItemView(
                assetName: AppAssets.drawerDiscussion,
                text: "Discussion",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  discussionTap();
                },
                iscomingsoon: true,
              ),
              drawerItemView(
                assetName: AppAssets.drawerMyBuddies,
                text: "My Buddies",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFriendsScreen(),
                    ),
                  );
                },
                iscomingsoon: true,
              ),
              drawerItemView(
                assetName: AppAssets.drawerShareApp,
                text: "Share this App",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerRateApp,
                text: "Rate Us",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                },
              ),
              drawerItemView(
                assetName: AppAssets.drawerLogout,
                text: "Logout",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  ApiManager(context).logout();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _getSubjects();
    //delay to give ripple effect
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  Widget drawerItemView({
    @required String assetName,
    @required String text,
    @required Function onTap,
    bool iscomingsoon = false,
  }) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: iscomingsoon ? () {} : onTap,
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
            Spacer(),
            iscomingsoon
                ? Image.asset(
                    AppAssets.comingSoon,
                    height: 30,
                    width: 90,
                  )
                : Container(),
            SizedBox(
              width: 4,
            )
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
          child: _isLoading
              ? Utility.progress(context)
              : RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: controller,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 4,
                        ),
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
                          isPng: true,
                          text: "Share this App to your friends",
                          buttonText: "Share this App",
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          onTap: () async {
                            //delay to give ripple effect
                            await Future.delayed(
                                Duration(milliseconds: AppStrings.delay));
                          },
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
                          onTap: () async {
                            //delay to give ripple effect
                            await Future.delayed(
                                Duration(milliseconds: AppStrings.delay));
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Utility.roundShadowButton(
                            context: context,
                            assetName: AppAssets.upArrow,
                            onPressed: () async {
                              //delay to give ripple effect
                              await Future.delayed(
                                  Duration(milliseconds: AppStrings.delay));
                              controller.animateTo(
                                0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                          ),
                        )
                      ],
                    ),
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
        height: 150,
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
          onTap: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            liveQuizTap();
          },
          isComingSoon: true,
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
          onTap: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            mockTestTap();
          },
          isComingSoon: true,
        ),
        horizontalItemView(
          color: AppColors.discussionForumColor,
          assetName: AppAssets.discussionForum,
          text: "Get answers to any question by asking our live community",
          buttonText: "Discussion forum",
          margin: EdgeInsets.only(
            left: 8,
          ),
          onTap: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            discussionTap();
          },
          isComingSoon: true,
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
    bool isPng = false,
    bool isComingSoon = false,
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
            child: isPng ? Image.asset(assetName) : SvgPicture.asset(assetName),
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
                  height: 16,
                ),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Utility.button(
                      context,
                      onPressed: onTap,
                      text: buttonText,
                      gradientColor1: Color(0xFF76B5FF),
                      gradientColor2: Color(0xFF4499FF),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      fontSize: 14,
                      height: 40,
                    ),
                    isComingSoon
                        ? Image.asset(
                            AppAssets.comingSoon,
                            height: 20,
                            width: 80,
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget subjectView() {
    return subjects.length == 0
        ? Utility.emptyView("No Subjects")
        : GridView.builder(
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
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubTopicScreen(
              subject: subjects[index],
            ),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Expanded(
              child: Utility.imageLoader(
                baseUrl: AppStrings.subjectImage,
                url: subjects[index].image,
                placeholder: AppAssets.subjectPlaceholder,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              subjects[index].name,
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
                  "0% Completed",
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4,
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
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Utility.noUserProgressView(context),
          )
        : Container(
            decoration: BoxDecoration(
              color: AppColors.chartBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: isProgress ? progressView() : noProgressView(),
          );
  }

  Widget noProgressView() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
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
                  fontSize: 20,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 8,
              ),
              Container(
                padding: EdgeInsets.only(top: 16),
                child: Utility.roundShadowButton(
                  context: context,
                  assetName: AppAssets.drawer,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    scafoldKey.currentState.openDrawer();
                  },
                ),
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
                    getUserImageView(50),
                  ],
                ),
              )
            ],
          );
  }
}
