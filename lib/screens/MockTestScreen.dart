import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/MockTestQuizScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class MockTestScreen extends StatefulWidget {
  @override
  _MockTestScreenState createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                AppAssets.bottomBarbg,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Mock Test",
          isHome: false,
        ),
        mockTestList(),
      ],
    );
  }

  Widget mockTestList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return mockTestItemView(index);
        },
      ),
    );
  }

  Widget mockTestItemView(int index) {
    return GestureDetector(
      onTap: () {
        Utility.showStartQuizDialog(
          context: context,
          onStartPress: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => MockTestQuizScreen(),
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.appColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            SvgPicture.asset(
              AppAssets.mockTestItemBg,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        index == 1
                            ? "SSC Science Expert Mock Test  -2"
                            : "SSC CGL Mock Test - " + (index + 1).toString(),
                        style: TextStyle(
                          color: AppColors.myProgressIncorrectcolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text(
                              "100 Question",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SvgPicture.asset(AppAssets.whiteClock),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "2 hr 30 min",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SvgPicture.asset(
                    index == 2 ? AppAssets.whiteNext : AppAssets.cyanCheck),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
