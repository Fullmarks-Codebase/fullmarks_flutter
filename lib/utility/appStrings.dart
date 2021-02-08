import 'dart:io';

import 'package:flutter/foundation.dart';

class AppStrings {
  // static String baseUrl = "http://e-fullmarks.in/";
  static String baseUrl = "http://104.131.14.251:3001/";
  static String login = baseUrl + "app/customer/checkin";
  static String customer = baseUrl + "customer/getSingleCustomer";
  static String customerUpdate = baseUrl + "customer/update";
  static String subjects = baseUrl + "subjects/onlySubjects";
  static String subTopics = baseUrl + "subjects/onlyTopics";
  static String getClass = baseUrl + "class";
  static String changeClass = baseUrl + "customer/changeClass";
  static String changeClassGuest = baseUrl + "customer/guestClassChange";
  static String sets = baseUrl + "subjects/topics/sets";
  static String questions = baseUrl + "questions";
  static String reports = baseUrl + "report/add";
  static String overallReport = baseUrl + "report/overall";
  static String subjectReport = baseUrl + "report/subject";
  static String setReport = baseUrl + "report/set";
  static String guestLogin = baseUrl + "customer/guest";
  static String testResult = baseUrl + "report/myReport";
  static String getNotification = baseUrl + "notification/getAll";
  static String readNotification = baseUrl + "notification/read";
  static String countNotification = baseUrl + "notification/count";
  static String getCustomQuiz = baseUrl + "live/custom/getNames";
  static String addCustomQuiz = baseUrl + "live/custom/add";
  static String addCustomQuestions = baseUrl + "live/custom/questions/add";
  static String updateCustomQuestions =
      baseUrl + "live/custom/questions/update";
  static String getCustomQuestions = baseUrl + "live/custom/getQuestions";
  static String deleteCustomQuestions = baseUrl + "live/custom/questions/";
  static String shareCode = baseUrl + "live/shareCode";
  static String myFriends = baseUrl + "friends/myfriends";
  static String requestRecieved = baseUrl + "friends/requestRecieved";
  static String requestSent = baseUrl + "friends/requestSent";
  static String notFriend = baseUrl + "friends/notFriend";
  static String sentRequest = baseUrl + "friends/sentRequest";
  static String requestResponse = baseUrl + "friends/requestResponse";

  //image base url
  static String imageBaseUrl = baseUrl;
  // static String imageBaseUrl =
  //     "https://e-fullmarks.s3.us-east-2.amazonaws.com/";
  static String customQuestion =
      imageBaseUrl + "images/user_questions/question/";
  static String customAnswers = imageBaseUrl + "images/user_questions/answers/";
  static String userImage = imageBaseUrl + "images/user/";
  static String classImage = imageBaseUrl + "images/class/";
  static String subjectImage = imageBaseUrl + "images/subjects/";
  static String questionImage = imageBaseUrl + "images/questions/question/";
  static String answersImage = imageBaseUrl + "images/questions/answers/";
  static String commentImage = imageBaseUrl + "images/posts/comments/";
  static String postImage = imageBaseUrl + "images/posts/post/";

  //constant strings
  static String noInternet = "No Internet Connection";

  //preference keys
  static String userPreference = "USER_APP_PREFERENCE";
  static String introSliderPreference = "INTRO_SLIDER_APP_PREFERENCE";
  static String guestUserPreference = "GUEST_USER_APP_PREFERENCE";

  //api constants
  static int male = 0;
  static int female = 1;

  //splash effect delay
  static int delay = 150;

  static String playStore =
      "https://play.google.com/store/apps/details?id=app.fullmarks.com"; //change this
  // static String appstore =
  //     "https://apps.apple.com/in/app/apple-store/id375380948"; //change this
  static String commonShareText =
      "Hey, Checkout “Fullmarks – Learn CBSE, Math, English, Science”, download the app – $playStore \n\nIf you already have the app, click here - ";
  static String shareAppText = "$commonShareText applink://fullmarks.app";
  static String addFriendText =
      "$commonShareText applink://fullmarks.app/friends to become my friend";
  static String joinLiveQuizDeepLinkKey = "Live_Quiz";
  // "Check out “Fullmarks” - Learn CBSE Maths, English, Science in a very easy manner. Practice with mock tests at your own pace.\nDownload Android app - $playStore";
  // "Check out “Fullmarks” - Learn CBSE Maths, English, Science in a very easy manner. Practice with mock tests at your own pace.\nDownload Android app - $playStore \nDownload iOS app - $appstore";

  static int phase = kDebugMode ? 2 : 1;

  //admob
  //https://developers.google.com/admob/android/test-ads
  static String appId = Platform.isAndroid
      ? "ca-app-pub-9321524489967330~8028966399"
      : "ca-app-pub-9321524489967330~5903983043";
  static String adUnitId = Platform.isAndroid
      ? "ca-app-pub-9321524489967330/1187569339"
      : "ca-app-pub-9321524489967330/7483183246";

  //firebase analytics
  //https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_analytics/firebase_analytics/example/lib/main.dart
  static String splashScreenEvent = "splashScreen";
  static String introSliderScreenEvent = "introSliderScreen";
  static String changeGradeScreenEvent = "changeGradeScreen";
  static String loginScreenEvent = "loginScreen";
  static String loginWithFacebookEvent = "loginWithFacebook";
  static String loginWithgoogleEvent = "loginWithgoogle";
  static String loginWithPhoneEvent = "loginWithPhone";
  static String verificationScreenEvent = "verificationScreen";
  static String homeScreenEvent = "homeScreen";
  static String guestLoginEvent = "guestLogin";
  // static String  = "";
}
