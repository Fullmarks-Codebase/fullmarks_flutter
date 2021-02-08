import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/CustomQuestionResponse.dart';
import 'package:fullmarks/models/CustomQuizResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/screens/AddQuestionScreen.dart';
import 'package:fullmarks/screens/PreviewQuestionScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class CustomQuizListScreen extends StatefulWidget {
  CustomQuizDetails quiz;
  CustomQuizListScreen({
    @required this.quiz,
  });
  @override
  _CustomQuizListScreenState createState() => _CustomQuizListScreenState();
}

class _CustomQuizListScreenState extends State<CustomQuizListScreen> {
  ScrollController controller;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  List<QuestionDetails> questionsDetails = List();

  @override
  void initState() {
    controller = ScrollController();
    _getQuestions();
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
          body(),
        ],
      ),
    );
  }

  _getQuestions() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["customMasterId"] = widget.quiz.id.toString();
      //api call
      CustomQuestionResponse response = CustomQuestionResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.getCustomQuestions, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        questionsDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Future<Null> _handleRefresh() async {
    _getQuestions();
    //delay to give ripple effect
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.quiz.name,
          isHome: false,
          textColor: Colors.white,
        ),
        questionsList(),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
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
          child: Column(
            children: [
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddQuestionScreen(
                        isEdit: false,
                        questionDetails: null,
                        quizDetails: widget.quiz,
                      ),
                    ),
                  );
                },
                bgColor: AppColors.chartBgColor,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                gradientColor1: AppColors.buttonGradient1,
                gradientColor2: AppColors.buttonGradient2,
                text: "Add More Question",
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                },
                text: "Submit",
                bgColor: AppColors.myProgressCorrectcolor,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget questionsList() {
    return Expanded(
      child: _isLoading
          ? Utility.progress(context)
          : questionsDetails.length == 0
              ? ListView(
                  padding: EdgeInsets.all(16),
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          ((AppBar().preferredSize.height * 2) + 100),
                      child: Utility.emptyView(
                        "No Questions",
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                )
              : RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: questionsDetails.length,
                    itemBuilder: (context, index) {
                      return questionsItemView(index);
                    },
                  ),
                ),
    );
  }

  Widget questionImageView(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      height: 200,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Utility.imageLoader(
          baseUrl: AppStrings.customQuestion,
          url: questionsDetails[index].questionImage,
          placeholder: AppAssets.imagePlaceholder,
        ),
      ),
    );
  }

  Widget questionsItemView(int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16,
      ),
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Question " + (index + 1).toString(),
              style: TextStyle(
                color: AppColors.appColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Divider(),
          SizedBox(
            height: 8,
          ),
          questionsDetails[index].question.length != 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    questionsDetails[index].question,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : questionsDetails[index].questionImage.length != 0
                  ? questionImageView(index)
                  : Container(),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 16,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.myProgressIncorrectcolor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.whiteClock,
                        color: AppColors.appColor,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        questionsDetails[index].time.toString() + " Sec",
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                questionItemViewButton(AppAssets.eye, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreviewQuestionScreen(
                        questionDetails: questionsDetails[index],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: 8,
                ),
                questionItemViewButton(
                  AppAssets.edit,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQuestionScreen(
                          isEdit: true,
                          questionDetails: questionsDetails[index],
                          quizDetails: null,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 8,
                ),
                questionItemViewButton(AppAssets.delete, () {
                  Utility.showDeleteDialog(
                    context: context,
                    onDeletePress: () async {
                      //delay to give ripple effect
                      await Future.delayed(
                          Duration(milliseconds: AppStrings.delay));
                      Navigator.pop(context);
                      _deleteQuestion(index);
                    },
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }

  _deleteQuestion(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context).deleteCall(
          url: AppStrings.deleteCustomQuestions +
              questionsDetails[index].id.toString(),
        ),
      );

      Utility.showToast(response.message);

      if (response.code == 200) {
        _getQuestions();
      } else {
        //hide progress
        _isLoading = false;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget questionItemViewButton(String assetName, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 1,
              color: AppColors.appColor,
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(assetName),
      ),
    );
  }
}
