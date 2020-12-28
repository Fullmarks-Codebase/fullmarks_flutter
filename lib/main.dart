import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/screens/InstructionsScreen.dart';
import 'package:fullmarks/screens/IntroSliderScreen.dart';
import 'package:fullmarks/screens/SplashScreen.dart';
import 'package:fullmarks/utility/AppColors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value) {
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
    ]).then((value) {
      runApp(MyApp());
    });
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
  - SubjectSelectionScreen

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: AppColors.appColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: AppColors.background,
        ),
        // home: SplashScreen(),
        home: HomeScreen(),
      ),
    );
  }
}
