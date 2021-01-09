class AppStrings {
  static String baseUrl = "http://104.131.14.251:3001/";
  static String login = baseUrl + "app/customer/checkin";
  static String customer = baseUrl + "customer/getSingleCustomer";
  static String subjects = baseUrl + "subjects/onlySubjects";
  static String subTopics = baseUrl + "subjects/onlyTopics";
  static String getClass = baseUrl + "class";
  static String changeClass = baseUrl + "customer/changeClass";
  static String sets = baseUrl + "subjects/topics/sets";
  static String questions = baseUrl + "questions";
  static String reports = baseUrl + "report/add";

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
  static String comingSoon = "Coming Soon...";

  //preference keys
  static String userPreference = "USER_APP_PREFERENCE";
  static String introSliderPreference = "INTRO_SLIDER_APP_PREFERENCE";
  static String skipPreference = "SKIP_APP_PREFERENCE";

  //api constants
  static int male = 0;
  static int female = 1;

  static int delay = 150;
}
