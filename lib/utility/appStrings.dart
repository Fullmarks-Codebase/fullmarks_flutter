import 'dart:io';

class AppStrings {
  // static String baseUrl = "http://e-fullmarks.in/";
  static String baseUrl = "http://104.131.14.251:3001/";
  //customer (user)
  static String login = baseUrl + "app/customer/checkin";
  static String customer = baseUrl + "customer/getSingleCustomer";
  static String customerUpdate = baseUrl + "customer/update";
  static String changeClass = baseUrl + "customer/changeClass";
  //guest
  static String guestLogin = baseUrl + "customer/guest";
  static String changeClassGuest = baseUrl + "customer/guestClassChange";
  //common
  static String subjects = baseUrl + "subjects/onlySubjects";
  static String subTopics = baseUrl + "subjects/onlyTopics";
  static String getClass = baseUrl + "class";
  static String sets = baseUrl + "subjects/topics/sets";
  static String questions = baseUrl + "questions";
  //report
  static String reports = baseUrl + "report/add";
  static String overallReport = baseUrl + "report/overall";
  static String subjectReport = baseUrl + "report/subject";
  static String setReport = baseUrl + "report/set";
  static String testResult = baseUrl + "report/myReport";
  //notification
  static String getNotification = baseUrl + "notification/getAll";
  static String readNotification = baseUrl + "notification/read";
  static String countNotification = baseUrl + "notification/count";
  //live quiz
  static String getCustomQuiz = baseUrl + "live/custom/getNames";
  static String addCustomQuiz = baseUrl + "live/custom/add";
  static String addCustomQuestions = baseUrl + "live/custom/questions/add";
  static String updateCustomQuestions =
      baseUrl + "live/custom/questions/update";
  static String getCustomQuestions = baseUrl + "live/custom/getQuestions";
  static String deleteCustomQuestions = baseUrl + "live/custom/questions/";
  static String shareCode = baseUrl + "live/shareCode";
  static String liveQuizBySubject = baseUrl + "live/bySubject";
  static String liveQuizCustom = baseUrl + "live/custom/getQuestions/random";
  static String liveReport = baseUrl + "live/report";
  static String leaderboard = baseUrl + "live/leaderboard";
  static String deleteImage = baseUrl + "live/custom/deleteImage";
  //friends
  static String myFriends = baseUrl + "friends/myfriends";
  static String requestRecieved = baseUrl + "friends/requestRecieved";
  static String requestSent = baseUrl + "friends/requestSent";
  static String notFriend = baseUrl + "friends/notFriend";
  static String sentRequest = baseUrl + "friends/sentRequest";
  static String requestResponse = baseUrl + "friends/requestResponse";
  //posts
  static String addPosts = baseUrl + "posts/add";
  static String getPosts = baseUrl + "posts";
  static String deletePosts = baseUrl + "posts/delete/";
  static String updatePosts = baseUrl + "posts/update";
  static String likePosts = baseUrl + "posts/like";
  static String dislikePosts = baseUrl + "posts/dislike";
  static String mySavedPosts = baseUrl + "posts/mySaved";
  static String savePosts = baseUrl + "posts/save";
  static String removeSavePosts = baseUrl + "posts/removeSave";
  static String myPosts = baseUrl + "posts/myPost";
  static String deletePostsImage = baseUrl + "posts/deleteImage";
  //posts comments
  static String getPostsComments = baseUrl + "posts/comments";
  static String addPostsComments = baseUrl + "posts/comments/add";
  static String updatePostsComments = baseUrl + "posts/comments/update";
  static String deletePostsComments = baseUrl + "posts/comments/delete/";
  static String likePostsComments = baseUrl + "posts/comments/like";
  static String dislikePostsComments = baseUrl + "posts/comments/dislike";
  static String deletePostsCommentsImage =
      baseUrl + "posts/comments/deleteImage";

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
  static String postImage = imageBaseUrl + "images/posts/post/";
  static String commentImage = imageBaseUrl + "images/posts/comments/";

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
  static String shareAppText = "$commonShareText https://fullmarks.app";
  static String addFriendText =
      "$commonShareText https://fullmarks.app/friends to become my friend";
  static String joinLiveQuizDeepLinkKey = "Live_Quiz";
  // "Check out “Fullmarks” - Learn CBSE Maths, English, Science in a very easy manner. Practice with mock tests at your own pace.\nDownload Android app - $playStore";
  // "Check out “Fullmarks” - Learn CBSE Maths, English, Science in a very easy manner. Practice with mock tests at your own pace.\nDownload Android app - $playStore \nDownload iOS app - $appstore";

  // static int phase = 1;
  static int phase = 2;

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
  static String addCommentEvent = "addCommentScreen";
  static String addDiscussionEvent = "addDiscussionScreen";
  static String addEditCustomQuizQuestionOptionEvent =
      "addEditCustomQuizQuestionOptionScreen";
  static String addFriendEvent = "addFriendScreen";
  static String addQuestionEvent = "addQuestionScreen";
  static String addQuizNameEvent = "addQuizNameScreen";
  static String askingForProgressEvent = "askingForProgressScreen";
  static String createCustomQuizEvent = "createCustomQuizScreen";
  static String createNewQuizEvent = "createNewQuizScreen";
  static String createQuizLobbyEvent = "createQuizLobbyScreen";
  static String customQuizListEvent = "customQuizListScreen";
  static String discussionDetailsEvent = "discussionDetailsScreen";
  static String discussionEvent = "discussionScreen";
  static String joinQuizDeepLinkEvent = "joinQuizDeepLink";
  static String shareAppEvent = "shareApp";
  static String rateAppEvent = "rateApp";
  static String instructionsEvent = "instructionsScreen";
  static String joinQuizEvent = "joinQuizScreen";
  static String leaderboardEvent = "leaderboardScreen";
  static String liveQuizPlayEvent = "liveQuizPlayScreen";
  static String mockTestQuizEvent = "mockTestQuizScreen";
  static String mockTestEvent = "mockTestScreen";
  static String myFriendsEvent = "myFriendsScreen";
  static String myProfileEvent = "myProfileScreen";
  static String myProgressEvent = "myProgressScreen";
  static String myProgressSubjectEvent = "myProgressSubjectScreen";
  static String notificationDetailsEvent = "notificationDetailsScreen";
  static String notificationListEvent = "notificationListScreen";
  static String otherProfileEvent = "otherProfileScreen";
  static String quizResultEvent = "quizResultScreen";
  static String randomQuizMatchEvent = "randomQuizMatchScreen";
  static String setsEvent = "setsScreen";
  static String subjectSelectionEvent = "subjectSelectionScreen";
  static String subTopicEvent = "subTopicScreen";
  static String testResultEvent = "testResultScreen";
  static String testEvent = "testScreen";
  static String waitingForHostEvent = "waitingForHostScreen";

  //socket events
  //live quuiz
  static String room = "room";
  static String welcome = "welcome";
  static String sessionFull = "session_full";
  static String join = "join";
  static String getReady = "GetReady";
  static String allParticipants = "allParticipants";
  static String userDetails = "userDetails";
  static String startQuiz = "start_quiz";
  static String error = "Error";
  static String disconnected = "disconnected";
  static String forceDisconnect = "forceDisconnect";
  static String updateScore = "updateScore";
  static String submit = "submit";
  static String notSubmitted = "notSubmitted";
  static String completed = "completed";
  //random quiz
  static String choose = "choose";

  //no internet socket check
  static int timerSecondsForNoInternet = 7;

  //notification type
  static int friends = 2;
}
