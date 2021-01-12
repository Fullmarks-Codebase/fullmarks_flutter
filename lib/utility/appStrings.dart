class AppStrings {
  static String baseUrl = "http://104.131.14.251:3001/";
  static String login = baseUrl + "app/customer/checkin";
  static String customer = baseUrl + "customer/getSingleCustomer";
  static String customerUpdate = baseUrl + "customer/update";
  static String subjects = baseUrl + "subjects/onlySubjects";
  static String subTopics = baseUrl + "subjects/onlyTopics";
  static String getClass = baseUrl + "class";
  static String changeClass = baseUrl + "customer/changeClass";
  static String sets = baseUrl + "subjects/topics/sets";
  static String questions = baseUrl + "questions";
  static String reports = baseUrl + "report/add";
  static String overallReport = baseUrl + "report/overall";
  static String subjectReport = baseUrl + "report/subject";
  static String setReport = baseUrl + "report/set";

  //image base url
  static String customQuestion = baseUrl + "images/user_questions/question/";
  static String customAnswers = baseUrl + "images/user_questions/answers/";
  static String userImage = baseUrl + "images/user/";
  static String classImage = baseUrl + "images/class/";
  static String subjectImage = baseUrl + "images/subjects/";
  static String questionImage = baseUrl + "images/questions/question/";
  static String answersImage = baseUrl + "images/questions/answers/";
  static String commentImage = baseUrl + "images/posts/comments/";
  static String postImage = baseUrl + "images/posts/post/";

  //constant strings
  static String noInternet = "No Internet Connection";

  //preference keys
  static String userPreference = "USER_APP_PREFERENCE";
  static String introSliderPreference = "INTRO_SLIDER_APP_PREFERENCE";
  static String skipPreference = "SKIP_APP_PREFERENCE";

  //api constants
  static int male = 0;
  static int female = 1;

  static int delay = 150;

  static String playStore =
      "https://play.google.com/store/apps/details?id=e.fullmarks.com"; //change this
  static String appstore =
      "https://apps.apple.com/in/app/apple-store/id375380948"; //change this
  static String shareAppText =
      "Check out “Fullmarks” - Learn CBSE Maths, English, Science in a very easy manner. Practice with mock tests at your own pace.\nDownload Android app - $playStore \nDownload iOS app - $appstore";
}
