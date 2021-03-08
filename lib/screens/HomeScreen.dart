import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/GuestUserResponse.dart';
import 'package:fullmarks/models/NotificationCountResponse.dart';
import 'package:fullmarks/models/ReportsResponse.dart';
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
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/FirebaseMessagingService.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';
import 'package:uni_links/uni_links.dart';

import '../main.dart';
import 'AskingForProgressScreen.dart';
import 'DiscussionScreen.dart';
import 'JoinQuizScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  ScrollController controller;
  List<SubjectDetails> subjects = List();
  bool _isLoading = false;
  Customer customer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  ReportDetails overallReportDetails;
  GuestUserDetails guest;
  int notificationCount = 0;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.homeScreenEvent);
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
    FirebaseMessagingService().getMessage();
    controller = ScrollController();
    initDeepLink();
    _getUser();
    if (guest != null) guestLogin();
    _getSubjects();
    if (customer != null) {
      _getOverallProgress();
      _getNotificationCount();
    }
    _notify();
    super.initState();
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      print(receivedNotification.title);
      print(receivedNotification.body);
      print(receivedNotification.payload);
      // await showDialog(
      //   context: context,
      //   builder: (BuildContext context) => CupertinoAlertDialog(
      //     title: receivedNotification.title != null
      //         ? Text(receivedNotification.title)
      //         : null,
      //     content: receivedNotification.body != null
      //         ? Text(receivedNotification.body)
      //         : null,
      //     actions: <Widget>[
      //       CupertinoDialogAction(
      //         isDefaultAction: true,
      //         onPressed: () async {
      //           Navigator.of(context, rootNavigator: true).pop();
      //           await Navigator.push(
      //             context,
      //             MaterialPageRoute<void>(
      //               builder: (BuildContext context) =>
      //                   SecondPage(receivedNotification.payload),
      //             ),
      //           );
      //         },
      //         child: const Text('Ok'),
      //       )
      //     ],
      //   ),
      // );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String notificationPayload) async {
      String tempNotificationPayload = notificationPayload;
      if (tempNotificationPayload != null) {
        var tempPayload = jsonDecode(tempNotificationPayload);
        _readNotifications(tempPayload['id']);
        if (tempPayload['notifyType'].toString() ==
            AppStrings.friends.toString()) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MyFriendsScreen(),
            ),
          );
        } else if (tempPayload['notifyType'].toString() ==
            AppStrings.joinRoom.toString()) {
          String room = tempPayload['room'].toString();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => JoinQuizScreen(
                roomId: room,
              ),
            ),
          );
        }
      }
    });
  }

  _readNotifications(String id) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["id"] = id;
      //api call
      CommonResponse.fromJson(
        await ApiManager(context)
            .putCall(url: AppStrings.readNotification, request: request),
      );
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.add(null);
    super.dispose();
  }

  initDeepLink() {
    //handle deep link
    getInitialLink().then((link) {
      if (link != null && link.length != 0) {
        if (link.contains(AppStrings.joinLiveQuizDeepLinkKey)) {
          if (link.split("/").length != 0 && link.split("/").last.length != 0) {
            if (link.split("/")[link.split("/").length - 1] !=
                AppStrings.joinLiveQuizDeepLinkKey)
              AppFirebaseAnalytics.init()
                  .logEvent(name: AppStrings.joinQuizDeepLinkEvent);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JoinQuizScreen(
                  roomId: link.split("/").last,
                ),
              ),
            );
          }
        } else if (link.contains("friends")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyFriendsScreen(),
            ),
          );
        }
      }
    });
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
    guest = Utility.getGuest();
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
      if (customer == null) {
        request["guest"] = "true";
        request["guestId"] = guest.id.toString();
      } else {
        request["userId"] = customer.id.toString();
        request["id"] = customer.classGrades.id.toString();
      }
      request["calledFrom"] = "app";
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
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  _getOverallProgress() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      if (customer != null) request["userId"] = customer.id.toString();
      request["classId"] = customer.classGrades.id.toString();
      //api call
      ReportsResponse response = ReportsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.overallReport, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        overallReportDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
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
        : customer.thumbnail == ""
            ? dummyUserView(size)
            : Container(
                margin: EdgeInsets.all(16),
                child: Utility.getUserImage(
                  url: customer.thumbnail,
                  height: size,
                  width: size,
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
                                Expanded(
                                  child: Text(
                                    customer.classGrades.name,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
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
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotificationListScreen(),
                                ),
                              );
                              _getNotificationCount();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Utility.drawerItemView(
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
              Utility.drawerItemView(
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
                  _getSubjects();
                  if (customer != null) _getOverallProgress();
                },
              ),
              Utility.drawerItemView(
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
                      builder: (context) => ChangeGradeScreen(
                        isFirstTime: false,
                      ),
                    ),
                  );
                  _getUser();
                  _getSubjects();
                  if (customer != null) _getOverallProgress();
                },
              ),
              Utility.drawerItemView(
                assetName: AppAssets.drawerMockTest,
                text: "Mock Test",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  mockTestTap();
                },
                iscomingsoon: AppStrings.phase == 1,
              ),
              Utility.drawerItemView(
                assetName: AppAssets.drawerLiveQuiz,
                text: "Live Quizzes",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  liveQuizTap();
                },
                iscomingsoon: AppStrings.phase == 1,
              ),
              Utility.drawerItemView(
                assetName: AppAssets.drawerDiscussion,
                text: "Discussion",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  discussionTap();
                },
                iscomingsoon: AppStrings.phase == 1,
              ),
              Utility.drawerItemView(
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
                iscomingsoon: AppStrings.phase == 1,
              ),
              Utility.drawerItemView(
                assetName: AppAssets.drawerShareApp,
                text: "Share this App",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  shareApp();
                },
              ),
              Utility.drawerItemView(
                assetName: AppAssets.drawerRateApp,
                text: "Rate Us",
                onTap: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  rateApp();
                },
              ),
              Utility.drawerItemView(
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

  shareApp() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.shareAppEvent);
    Share.share(AppStrings.shareAppText);
  }

  rateApp() async {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.rateAppEvent);
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview().then((value) {
        print("requestReview done");
      }).catchError((onError) {
        print("onError");
        print(onError);
      });
    } else {
      inAppReview.openStoreListing().then((value) {
        print("openStoreListing done");
      }).catchError((onError) {
        print("onError");
        print(onError);
      });
    }
    // Utility.launchURL(AppStrings.playStore);
    // Platform.isAndroid ? AppStrings.playStore : AppStrings.appstore);
  }

  Future<Null> _handleRefresh() async {
    _getSubjects();
    if (customer != null) {
      _getOverallProgress();
      _getNotificationCount();
    }
    //delay to give ripple effect
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
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
                        Utility.horizontalItemView(
                          context: context,
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
                            shareApp();
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Utility.horizontalItemView(
                          context: context,
                          color: AppColors.strongCyan,
                          assetName: AppAssets.rateUs,
                          text: "",
                          buttonText: "Rate Us!",
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          onTap: () async {
                            //delay to give ripple effect
                            await Future.delayed(
                                Duration(milliseconds: AppStrings.delay));
                            rateApp();
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
        Utility.horizontalItemView(
          context: context,
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
          isComingSoon: AppStrings.phase == 1,
        ),
        Utility.horizontalItemView(
          context: context,
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
          isComingSoon: AppStrings.phase == 1,
        ),
        Utility.horizontalItemView(
          context: context,
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
          isComingSoon: AppStrings.phase == 1,
        ),
      ],
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

  guestLogin() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["imei"] = Utility.getGuest().imei;

      //api call
      GuestUserResponse response = GuestUserResponse.fromJson(
        await ApiManager(context).postCall(
          url: AppStrings.guestLogin,
          request: request,
        ),
      );

      if (response.code == 200) {
        await PreferenceUtils.setString(AppStrings.guestUserPreference,
            jsonEncode(response.result.toJson()));
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
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
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 4,
            ),
            Utility.getCustomer() != null
                ? Container(
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
                        subjects[index].completed + "% Completed",
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Utility.getCustomer() != null
                ? SizedBox(
                    height: 4,
                  )
                : Container(),
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
            child: overallReportDetails == null
                ? noProgressView()
                : overallReportDetails.correct != "" &&
                        overallReportDetails.correct != "null" &&
                        overallReportDetails.correct != null
                    ? progressView()
                    : noProgressView(),
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
          SizedBox(
            height: 8,
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
            child: Utility.pieChart(
              values: [
                double.tryParse(overallReportDetails.incorrect),
                double.tryParse(overallReportDetails.correct),
                double.tryParse(overallReportDetails.skipped)
              ],
            ),
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
                title:
                    "Incorrect: " + overallReportDetails.incorrect.toString(),
              ),
              SizedBox(
                height: 8,
              ),
              Utility.correctIncorrectView(
                color: AppColors.myProgressIncorrectcolor,
                title: "Correct: " + overallReportDetails.correct.toString(),
              ),
              SizedBox(
                height: 8,
              ),
              Utility.correctIncorrectView(
                color: AppColors.wrongBorderColor,
                title: "Skipped: " + overallReportDetails.skipped.toString(),
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
                title: "Avg. Accuracy = ${overallReportDetails.accuracy}%",
              ),
              SizedBox(
                height: 8,
              ),
              Utility.averageView(
                assetName: AppAssets.avgTime,
                title: "Avg. Time/Question = ${overallReportDetails.avgTime}",
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
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeGradeScreen(
                      isFirstTime: false,
                    ),
                  ),
                );
                _getUser();
                _getSubjects();
                if (customer != null) _getOverallProgress();
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      guest.classGrades.name,
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
                  isBadge: notificationCount != 0,
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
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfileScreen(),
                    ),
                  );
                  _getUser();
                  _getSubjects();
                  if (customer != null) _getOverallProgress();
                },
                child: Container(
                  color: Colors.transparent,
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
                ),
              )
            ],
          );
  }

  _getNotificationCount() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      //api call
      NotificationCountResponse response = NotificationCountResponse.fromJson(
        await ApiManager(context)
            .getCall(url: AppStrings.countNotification, request: request),
      );

      if (response.code == 200) {
        notificationCount = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }
}
