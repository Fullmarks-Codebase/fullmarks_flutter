import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fullmarks/screens/SplashScreen.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value) {
    //initialisation of persistent storage for simple data
    PreferenceUtils.init();
    runApp(MyApp());
  });
}

/*

Home (subject) -> SubTopicScreen -> SetsScreen -> InstructionsScreen -> TestScreen -> TestResultScreen -> QuizResultScreen

NotificationListScreen -> NotificationDetailsScreen

Drawer
1. My ProgressScreen
MyProgressScreen -> MyProgressSubjectScreen

2. My Profile
MyProfileScreen

3. Change Grade
ChangeGradeScreen

4. Mock Test
MockTestScreen -> MockTestQuizScreen

5. Live Quizzes
LiveQuizScreen 
  - LeaderboardScreen
  - AddFriendScreen
  - MyFriendsScreen
  - JoinQuizScreen -> WaitingForHostScreen -> LiveQuizPlayScreen -> RankListScreen
  - CreateNewQuizScreen -> SubjectSelectionScreen
                              - CreateQuizLobbyScreen -> LiveQuizPlayScreen -> RankListScreen
                              - CreateCustomQuizScreen -> AddQuizNameScreen
  - SubjectSelectionScreen -> RandomQuizMatchScreen -> LiveQuizPlayScreen

6. Discussion
DiscussionScreen 
  - DiscussionDetailsScreen
  - AddDiscussionScreen 
  - AddCommentScreen 

7. My Buddies
MyFriendsScreen -> OtherProfileScreen

*****/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: AppColors.appColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: AppColors.background,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
