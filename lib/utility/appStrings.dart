import 'dart:io';

class AppStrings {
  static String baseUrl = "http://e-fullmarks.in/";
  // static String baseUrl = "http://104.131.14.251:3001/";
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
  //mock test
  static String mock = baseUrl + "mock";
  static String mockQuestions = baseUrl + "mockQuestions/byMockId";
  static String mockReport = baseUrl + "mock/report";
  static String mockMyReport = baseUrl + "mock/myReport";

  //image base url
  static String imageBaseUrl =
      "https://e-fullmarks.s3.us-east-2.amazonaws.com/";
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
  static String deepLinkURL = "https://fullmarks.app";
  static String heyAppNameStr =
      "Hey, Checkout “Fullmarks – Learn CBSE, Math, English, Science”, download the app – $playStore";
  static String alreadyApp = "If you already have the app, click here - ";
  static String commonShareText = heyAppNameStr + "\n\n" + alreadyApp;
  static String shareAppText = "$commonShareText $deepLinkURL";
  static String addFriendText =
      "$commonShareText $deepLinkURL/friends to become my friend";
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
  static String introSliderScreenEvent = "intro_slider_screen";
  static String changeGradeScreenEvent = "choose_grade_screen";
  static String loginScreenEvent = "login_screen";
  static String loginWithFacebookEvent = "loginWithFacebook";
  static String loginWithgoogleEvent = "loginWithgoogle";
  static String loginWithPhoneEvent = "loginWithPhone";
  static String verificationScreenEvent = "otp_screen";
  static String homeScreenEvent = "main_home_screen";
  static String guestHomeScreenEvent = "guest_home_screen";
  static String guestLoginEvent = "guestLogin";
  static String addCommentEvent = "addCommentScreen";
  static String addDiscussionEvent = "disscusion_forum_add_question_screen";
  static String editDiscussionEvent = "disscusion_forum_edit_question_screen";
  static String addEditCustomQuizQuestionOptionEvent =
      "live_quizzes_custom_add_option_screen";
  static String addFriendEvent = "add_friend_screen";
  static String addQuestionEvent = "live_quizzes_custom_add_question_screen";
  static String addQuizNameEvent = "live_quizzes_custom_add_quiz_name_screen";
  static String askingForProgressEvent = "askingForProgressScreen";
  static String createCustomQuizEvent =
      "live_quizzes_create_custom_quiz_screen";
  static String createNewQuizEvent = "live_quizzes_create_new_quiz_screen";
  static String createQuizLobbyEvent = "live_quizzes_start_quiz_screen";
  static String customQuizListEvent = "live_quizzes_custom_quiz_home_screen";
  static String discussionDetailsEvent =
      "disscusion_forum_view_all_comments_screen";
  static String discussionEvent = "disscusion_forum_home_screen";
  static String joinQuizDeepLinkEvent = "joinQuizDeepLink";
  static String shareAppEvent = "shareApp";
  static String rateAppEvent = "rateApp";
  static String instructionsEvent = "quizzes_instruction_screen";
  static String guestInstructionsEvent = "guest_instruction_screen";
  static String joinQuizEvent = "live_quizzes_join_quiz_screen";
  static String leaderboardEvent = "live_quizzes_leaderboard_rank_screen";
  static String liveQuizHomeScreenEvent = "live_quizzes_home_screen";
  static String liveQuizPlayEvent = "live_quizzes_quiz_screen";
  static String mockTestQuizEvent = "mock_test_screen";
  static String mockTestEvent = "mock_test_choose_mock_test_screen";
  static String myFriendsEvent = "my_friend_screen";
  static String myProfileEvent = "my_profile_screen";
  static String myProgressEvent = "myProgressScreen";
  static String myProgressSubjectEvent = "myProgressSubjectScreen";
  static String notificationDetailsEvent = "view_notification_screen";
  static String notificationListEvent = "notification_home_screen";
  static String otherProfileEvent = "disscusion_forum_view_profile_screen";
  static String quizResultEvent = "quizzes_quiz_solution_screen";
  static String randomQuizMatchEvent =
      "live_quizzes_random_searching_player_screen";
  static String setsEvent = "quizzes_choose_set_screen";
  static String guestSetsEvent = "guest_choose_set_screen";
  static String subjectSelectionEvent = "live_quizzes_choose_by_subject_screen";
  static String setTimeScreenEvent = "live_quizzes_set_time_limit_screen";
  static String subTopicEvent = "quizzes_choose_subtopic_screen";
  static String guestSubTopicEvent = "guest_choose_subtopic_screen";
  static String testResultEvent = "quizzes_quiz_summary_screen";
  static String guestTestResultEvent = "guest_quiz_summary_screen";
  static String mockTestResultEvent = "mock_test_summary_screen";
  static String testEvent = "quizzes_quiz_screen";
  static String guestTestEvent = "guest_quiz_screen";
  static String waitingForHostEvent = "waitingForHostScreen";
  static String mockResultEvent = "mock_test_solution_screen";
  static String rankListEvent = "live_quizzes_rank_list_screen";
  static String randomQuizEvent = "live_quizzes_random_quiz_screen";
  static String randomQuizRankEvent = "live_quizzes_random_rank_list_screen";
  static String randomQuizChooseSubjectEvent =
      "live_quizzes_random_choose_subject_screen";
  static String cusomQuizSetTimeEvent =
      "live_quizzes_custom_time_limit_question_screen";
  static String startAddQuestionEvent =
      "live_quizzes_custom_start_add_question_screen";

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
  static String check = "check";
  static String notSubmitted = "notSubmitted";
  static String completed = "completed";
  //random quiz
  static String choose = "choose";

  //no internet socket check
  static int timerSecondsForNoInternet = 7;

  //socket check for submitted or not submittes answers
  static int timerSecondsForCheck = 3;

  //notification type
  static int friends = 2;
  static int joinRoom = 1;
}
