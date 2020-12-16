import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/screens/SplashScreen.dart';
import 'package:fullmarks/utility/appColors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((value) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top])
        .then((value) {
      runApp(MyApp());
    });
  });
}

/*

Home (subject) -> SubTopicScreen -> SetsScreen -> InstructionsScreen -> TestScreen -> TestResultScreen -> QuizResult

NotificationListScreen -> 

Drawer
1. My Progress
MyProgress -> MyProgressSubject

2. My Profile

3. Change Grade
ChangeGrade

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
