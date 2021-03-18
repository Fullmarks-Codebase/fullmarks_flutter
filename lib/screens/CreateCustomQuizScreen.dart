import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CustomQuizResponse.dart';
import 'package:fullmarks/screens/CustomQuizListScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'AddQuestionScreen.dart';
import 'AddQuizNameScreen.dart';
import 'CreateQuizLobbyScreen.dart';

class CreateCustomQuizScreen extends StatefulWidget {
  @override
  _CreateCustomQuizScreenState createState() => _CreateCustomQuizScreenState();
}

class _CreateCustomQuizScreenState extends State<CreateCustomQuizScreen> {
  ScrollController controller;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  List<CustomQuizDetails> customQuizDetails = List();

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.createCustomQuizEvent);
    controller = ScrollController();
    _getQuiz();
    super.initState();
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

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
          Column(
            children: [
              Utility.appbar(
                context,
                text: "Create Custom Quiz",
                isHome: false,
                textColor: Colors.white,
              ),
              body(),
            ],
          ),
        ],
      ),
    );
  }

  _getQuiz() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      CustomQuizResponse response = CustomQuizResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.getCustomQuiz, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        customQuizDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  Future<Null> _handleRefresh() async {
    _getQuiz();
    //delay to give ripple effect
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  Widget body() {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: controller,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(48),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(48),
                  ),
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SvgPicture.asset(
                      AppAssets.customQuizBg,
                      color: AppColors.lightAppColor,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        SvgPicture.asset(AppAssets.customQuizBg2),
                        SizedBox(
                          height: 32,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Utility.button(
                            context,
                            onPressed: () async {
                              //delay to give ripple effect
                              await Future.delayed(
                                  Duration(milliseconds: AppStrings.delay));
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddQuizNameScreen(),
                                ),
                              );
                              _getQuiz();
                            },
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            gradientColor1: AppColors.buttonGradient1,
                            gradientColor2: AppColors.buttonGradient2,
                            text: "Add New Quiz",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              _isLoading ? Utility.progress(context) : myQuizList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget myQuizList() {
    return customQuizDetails.length == 0
        ? Utility.emptyView(
            "No Custom Quiz",
            textColor: Colors.white,
          )
        : Column(
            children: [
              Text(
                "My Quiz List",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                itemCount: customQuizDetails.length,
                itemBuilder: (context, index) {
                  return myQuizItemView(index);
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Utility.roundShadowButton(
                  context: context,
                  assetName: AppAssets.upArrow,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    controller.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              )
            ],
          );
  }

  Widget myQuizItemView(int index) {
    return GestureDetector(
      onTap: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomQuizListScreen(
              quiz: customQuizDetails[index],
            ),
          ),
        );
        _getQuiz();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.chartBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                SvgPicture.asset(
                  AppAssets.myQuizItemBg,
                  color: Color(0x595D8AEA),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customQuizDetails[index].name,
                        style: TextStyle(
                          color: AppColors.myProgressIncorrectcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        customQuizDetails[index].totalQuestion.toString() +
                            " Questions",
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: customQuizDetails[index].submitted == 0
                      ? Column(
                          children: [
                            Utility.button(
                              context,
                              onPressed: () async {
                                //delay to give ripple effect
                                await Future.delayed(
                                    Duration(milliseconds: AppStrings.delay));
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddQuestionScreen(
                                      isEdit: false,
                                      questionDetails: null,
                                      quizDetails: customQuizDetails[index],
                                    ),
                                  ),
                                );
                                _getQuiz();
                              },
                              text: "Add Question",
                              bgColor: AppColors.chartBgColor,
                              borderColor: AppColors.myProgressIncorrectcolor,
                              assetName: AppAssets.list,
                              isPrefix: true,
                              fontSize: 12,
                              padding: 8,
                            ),
                            customQuizDetails[index].totalQuestion == 0
                                ? Container()
                                : SizedBox(
                                    height: 4,
                                  ),
                            customQuizDetails[index].totalQuestion == 0
                                ? Container()
                                : Utility.button(
                                    context,
                                    onPressed: () async {
                                      //delay to give ripple effect
                                      await Future.delayed(Duration(
                                          milliseconds: AppStrings.delay));
                                      await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateQuizLobbyScreen(
                                            subject: null,
                                            customQuiz:
                                                customQuizDetails[index],
                                            isCustomQuiz: true,
                                          ),
                                        ),
                                      );
                                      _getQuiz();
                                    },
                                    text: "Start Quiz",
                                    bgColor: AppColors.strongCyan,
                                    assetName: AppAssets.enterWhite,
                                    isSufix: true,
                                    isSpacer: true,
                                    fontSize: 12,
                                    padding: 8,
                                  ),
                          ],
                        )
                      : Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              AppAssets.submit,
                              color: AppColors.myProgressCorrectcolor,
                            ),
                          ),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
