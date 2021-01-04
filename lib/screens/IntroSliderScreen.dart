import 'package:flutter/material.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:lottie/lottie.dart';

class IntroSliderScreen extends StatefulWidget {
  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  PageController controller;
  int currentPageValue = 0;
  int previousPageValue = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    controller = PageController(initialPage: currentPageValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        PageView(
          onPageChanged: (int page) {
            getChangedPageAndMoveBar(page);
          },
          controller: controller,
          physics: ClampingScrollPhysics(),
          children: [
            introItemView(
              AppColors.introColor1,
              AppAssets.intro1,
              "Practice with short quizzes on each topic and track your performance",
            ),
            introItemView(
              AppColors.introColor2,
              AppAssets.intro2,
              "Clear your doubts and discuss with friends and coaches",
            ),
            introItemView(
              AppColors.introColor3,
              AppAssets.intro3,
              "Track your performance and prepare  to get fullmarks !",
            ),
            introItemView(
              AppColors.introColor4,
              AppAssets.intro4,
              "Live challenge your friends and flaunt won badges among friends !",
            ),
          ],
        ),
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 35),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < 4; i++)
                    if (i == currentPageValue) ...[circleBar(true)] else
                      circleBar(false),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: currentPageValue == 4 - 1 ? true : false,
          child: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 16),
              child: FloatingActionButton(
                backgroundColor: AppColors.appColor,
                onPressed: () {
                  PreferenceUtils.setBool(
                      AppStrings.introSliderPreference, true);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen(),
                      ),
                      (Route<dynamic> route) => false);
                },
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(26),
                  ),
                ),
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget introItemView(Color bgColor, String assetName, String text) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: bgColor,
      alignment: Alignment.center,
      child: Column(
        children: [
          Spacer(),
          // Image.asset(assetName),
          LottieBuilder.asset(assetName),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Spacer(),
        ],
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    _notify();
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
