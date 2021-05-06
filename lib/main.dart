import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fullmarks/screens/SplashScreen.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final InitializationSettings initializationSettings = InitializationSettings(
  android: AndroidInitializationSettings('app_icon'),
  iOS: IOSInitializationSettings(
    onDidReceiveLocalNotification:
        (int id, String title, String body, String payload) async {
      didReceiveLocalNotificationSubject.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
  ),
);

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
  await FirebaseAdMob.instance.initialize(appId: AppStrings.appId);
  await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
        selectNotificationSubject.add(payload);
      }
    },
  );

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

Flutter version - 1.22.4

Home (subject) -> SubTopicScreen -> SetsScreen -> InstructionsScreen -> TestScreen -> TestResultScreen -> QuizResultScreen (done)

NotificationListScreen -> NotificationDetailsScreen  (done)

Drawer
1. My ProgressScreen (done)
MyProgressScreen -> MyProgressSubjectScreen

2. My Profile (done)
MyProfileScreen

3. Change Grade (done)
ChangeGradeScreen

4. Mock Test
MockTestScreen -> MockTestQuizScreen

5. Live Quizzes (done) 
LiveQuizScreen 
  - LeaderboardScreen
  - AddFriendScreen
  - MyFriendsScreen
  - JoinQuizScreen -> WaitingForHostScreen -> LiveQuizPlayScreen -> RankListScreen
  - CreateNewQuizScreen -> SubjectSelectionScreen
                              - CreateQuizLobbyScreen -> LiveQuizPlayScreen -> RankListScreen
                              - CreateCustomQuizScreen -> AddQuizNameScreen -> StartAddQuestionScreen -> AddQuestionScreen -> AddEditCustomQuizQuestionOptionScreen
  - SubjectSelectionScreen -> RandomQuizMatchScreen -> LiveQuizPlayScreen -> RankListScreen

6. Discussion
DiscussionScreen 
  - DiscussionDetailsScreen
  - AddDiscussionScreen 
  - AddCommentScreen 

7. My Buddies (done)
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
          shortcuts:
              Map<LogicalKeySet, Intent>.from(WidgetsApp.defaultShortcuts)
                ..addAll(<LogicalKeySet, Intent>{
                  LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                      const FakeFocusIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowRight):
                      const FakeFocusIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowDown):
                      const FakeFocusIntent(),
                  LogicalKeySet(LogicalKeyboardKey.arrowUp):
                      const FakeFocusIntent(),
                }),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: AppColors.appColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: AppColors.background,
          ),
          home: SplashScreen(),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: AppFirebaseAnalytics.init()),
          ],
        ),
      ),
    );
  }
}

// Create a Focus Intent that does nothing
class FakeFocusIntent extends Intent {
  const FakeFocusIntent();
}
