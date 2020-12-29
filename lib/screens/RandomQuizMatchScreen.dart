import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'LiveQuizPlayScreen.dart';

class RandomQuizMatchScreen extends StatefulWidget {
  @override
  _RandomQuizMatchScreenState createState() => _RandomQuizMatchScreenState();
}

class _RandomQuizMatchScreenState extends State<RandomQuizMatchScreen> {
  bool isMatchFound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.mockTestBg),
          Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                AppAssets.bottomBarbg,
                width: MediaQuery.of(context).size.width,
              )
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
          text: isMatchFound ? "Matched" : "Searching for Player",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
          textColor: Colors.white,
        ),
        userImageView(),
        searchingView(),
        SizedBox(
          height: 16,
        ),
        Expanded(child: SvgPicture.asset(AppAssets.fly)),
        SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            //click for ui tsting purpose
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => LiveQuizPlayScreen(
                  isRandomQuiz: true,
                ),
              ),
            );
          },
          child: Text(
            isMatchFound ? "Get Ready to Play in 5 Second.." : "",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 32,
        )
      ],
    );
  }

  Widget searchingView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: GestureDetector(
          onTap: () {
            //click only for ui purpose
            if (mounted)
              setState(() {
                isMatchFound = !isMatchFound;
              });
          },
          child: isMatchFound
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          searchingText("Amit"),
                          SizedBox(
                            height: 16,
                          ),
                          searchingText("India"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "VS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          searchingText("Adit"),
                          SizedBox(
                            height: 16,
                          ),
                          searchingText("Qatar"),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  child: searchingText("Searching..."),
                ),
        ),
      ),
    );
  }

  Widget searchingText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.myProgressIncorrectcolor,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }

  Widget userImageView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(AppAssets.randomQuizSearchBg),
            Row(
              children: [
                Expanded(
                  flex: 15,
                  child: Container(),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(AppAssets.dummyUser),
                          ),
                          border: Border.all(
                            color: AppColors.myProgressIncorrectcolor,
                            width: 3,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: SvgPicture.asset(AppAssets.maths),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isMatchFound
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(AppAssets.dummyUser),
                                ),
                                border: Border.all(
                                  color: AppColors.myProgressIncorrectcolor,
                                  width: 3,
                                ),
                              ),
                            )
                          : Container(
                              child: SvgPicture.asset(AppAssets.user),
                              height: 100,
                              width: 100,
                            )
                    ],
                  ),
                ),
                Expanded(
                  flex: 15,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
