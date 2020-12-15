import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey();
  // int touchedIndex;
  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      drawer: drawer(),
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          body()
        ],
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: Container(
        child: Stack(
          children: [
            Utility.setSvgFullScreen(context, AppAssets.drawerBg),
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(16),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.appColor,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: AssetImage(AppAssets.dummyUser),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amitstcetet',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppAssets.class1),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      'Class Four',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(AppAssets.notification),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                drawerItemView(
                  assetName: AppAssets.drawerMyProgress,
                  text: "My Progress",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerMyProfile,
                  text: "My Profile",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerChangeGrade,
                  text: "Change Grade",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerMockTest,
                  text: "Mock Test",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerLiveQuiz,
                  text: "Live Quizzes",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerDiscussion,
                  text: "Discussion",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerMyBuddies,
                  text: "My Buddies",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerShareApp,
                  text: "Share this App",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerRateApp,
                  text: "Rate Us",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                drawerItemView(
                  assetName: AppAssets.drawerLogout,
                  text: "Logout",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItemView({
    @required String assetName,
    @required String text,
    @required Function onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            SvgPicture.asset(assetName),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        toolbarView(),
        Expanded(
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                myProgressView(),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Practice Subject",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                subjectView(),
                SizedBox(
                  height: 16,
                ),
                horizontalView(),
                SizedBox(
                  height: 16,
                ),
                horizontalItemView(
                  color: AppColors.appColor,
                  assetName: AppAssets.shareApp,
                  text: "Share this App to your friends",
                  buttonText: "Share this App",
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
                SizedBox(
                  height: 16,
                ),
                horizontalItemView(
                  color: AppColors.strongCyan,
                  assetName: AppAssets.rateUs,
                  text: "",
                  buttonText: "Rate Us!",
                  margin: EdgeInsets.symmetric(horizontal: 16),
                ),
                Container(
                  child: Utility.roundShadowButton(
                    context: context,
                    assetName: AppAssets.upArrow,
                    onPressed: () {
                      controller.animateTo(
                        0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget horizontalView() {
    return CarouselSlider(
      options: CarouselOptions(
        initialPage: 0,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        height: 150.0,
        viewportFraction: 0.85,
      ),
      items: [
        horizontalItemView(
          color: AppColors.introColor4,
          assetName: AppAssets.liveQuiz,
          text: "Play Live Quiz with friends and other students",
          buttonText: "Live Quiz",
        ),
        horizontalItemView(
          color: AppColors.mockTestColor,
          assetName: AppAssets.mockTest,
          text: "Full mock tests and see All India Performance",
          buttonText: "Mock Test",
        ),
        horizontalItemView(
          color: AppColors.discussionForumColor,
          assetName: AppAssets.discussionForum,
          text: "Get answers to any question by asking our live community",
          buttonText: "Discussion forum",
        ),
      ],
    );
  }

  Widget horizontalItemView({
    @required Color color,
    @required String assetName,
    @required String text,
    @required String buttonText,
    EdgeInsets margin,
  }) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset(assetName),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              children: [
                text.trim().length == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                          (index) => SvgPicture.asset(AppAssets.star),
                        ),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                SizedBox(
                  height: 8,
                ),
                Utility.button(
                  context,
                  onPressed: () {},
                  text: buttonText,
                  gradientColor1: Color(0xff76B5FF),
                  gradientColor2: Color(0xff4499FF),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget subjectView() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: getsubjects().length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 16.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return subjectItemView(index);
      },
    );
  }

  Widget subjectItemView(int index) {
    return Column(
      children: [
        Expanded(
          child: SvgPicture.asset(
            getsubjects()[index].assetName,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          getsubjects()[index].title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FittedBox(
            child: Text(
              getsubjects()[index].subtitle,
              style: TextStyle(
                color: AppColors.appColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Subject> getsubjects() {
    return [
      Subject(
        AppAssets.maths,
        "Mathmatics",
        "7% Completed",
      ),
      Subject(
        AppAssets.physics,
        "Physics",
        "100% Completed",
      ),
      Subject(
        AppAssets.chemistry,
        "Chemistry",
        "20% Completed",
      ),
      Subject(
        AppAssets.biology,
        "Biology",
        "20% Completed",
      ),
      Subject(
        AppAssets.english,
        "English",
        "20% Completed",
      ),
    ];
  }

  Widget myProgressView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chartBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: (MediaQuery.of(context).size.width / 2),
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                    // click on pie
                    // setState(() {
                    //   if (pieTouchResponse.touchInput is FlLongPressEnd ||
                    //       pieTouchResponse.touchInput is FlPanEnd) {
                    //     touchedIndex = -1;
                    //   } else {
                    //     touchedIndex = pieTouchResponse.touchedSectionIndex;
                    //   }
                    // });
                  }),
                  startDegreeOffset: 0,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 10,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                correctIncorrectView(
                  color: AppColors.myProgressCorrectcolor,
                  title: "Incorrect: 5",
                ),
                SizedBox(
                  height: 8,
                ),
                correctIncorrectView(
                  color: AppColors.myProgressIncorrectcolor,
                  title: "Correct: 120",
                ),
                SizedBox(
                  height: 8,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white.withOpacity(0.5),
                ),
                SizedBox(
                  height: 8,
                ),
                averageView(
                  assetName: AppAssets.avgAccuracy,
                  title: "Avg. Accuracy = 82%",
                ),
                SizedBox(
                  height: 8,
                ),
                averageView(
                  assetName: AppAssets.avgTime,
                  title: "Avg. Time/Question = 1:15",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget toolbarView() {
    return Row(
      children: [
        Utility.roundShadowButton(
          context: context,
          assetName: AppAssets.drawer,
          onPressed: () {
            scafoldKey.currentState.openDrawer();
          },
        ),
        Spacer(),
        Row(
          children: [
            Text(
              'Amitstcetet',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.appColor,
                  width: 2,
                ),
                image: DecorationImage(
                  image: AssetImage(AppAssets.dummyUser),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget averageView({
    @required String assetName,
    @required String title,
  }) {
    return Row(
      children: [
        SvgPicture.asset(assetName),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget correctIncorrectView({
    @required Color color,
    @required String title,
  }) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        // final isTouched = i == touchedIndex;
        // final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.myProgressCorrectcolor,
              value: 75,
              showTitle: false,
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.myProgressIncorrectcolor,
              value: 25,
              showTitle: false,
            );
          default:
            return null;
        }
      },
    );
  }
}

class Subject {
  String assetName;
  String title;
  String subtitle;

  Subject(String assetName, String title, String subtitle) {
    this.assetName = assetName;
    this.title = title;
    this.subtitle = subtitle;
  }
}
