import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/SetsResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/SubtopicResponse.dart';
import 'package:fullmarks/screens/TestScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:lottie/lottie.dart';

class InstructionsScreen extends StatefulWidget {
  SubtopicDetails subtopic;
  SubjectDetails subject;
  SetDetails setDetails;
  InstructionsScreen({
    @required this.subtopic,
    @required this.subject,
    @required this.setDetails,
  });
  @override
  _InstructionsScreenState createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  bool _isLoading = false;
  List<QuestionDetails> questionsDetails = List();

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.instructionsEvent);
    _getQuestions();
    super.initState();
  }

  _getQuestions() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["setId"] = widget.setDetails.id.toString();
      //api call
      QuestionsResponse response = QuestionsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.questions, request: request),
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
      Utility.showToast(context, AppStrings.noInternet);
    }
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
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
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
          text: "Instruction",
        ),
        Expanded(
          child: _isLoading
              ? Utility.progress(context)
              : questionsDetails.length == 0
                  ? Utility.emptyView("No Questions")
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        backgroundAndButton(),
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              instructionView1(),
                              SizedBox(
                                height: 40,
                              ),
                              instructionView2(),
                              SizedBox(
                                height: 40,
                              ),
                              instructionView3(),
                              SizedBox(
                                height: 130,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
        ),
        SvgPicture.asset(
          AppAssets.bottomBarbg,
          width: MediaQuery.of(context).size.width,
        ),
      ],
    );
  }

  Widget instructionView3() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(
          right: 60,
        ),
        decoration: BoxDecoration(
          color: AppColors.instructionsColor3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(90),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: LottieBuilder.asset(AppAssets.instructions3),
            ),
            Spacer(),
            Expanded(
              flex: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  roundedView(AppColors.introColor4, "Skip a Question"),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "If you want",
                    style: TextStyle(
                      color: AppColors.introColor4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget instructionView2() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(
          left: 60,
        ),
        decoration: BoxDecoration(
          color: AppColors.instructionsColor2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(90),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  roundedView(AppColors.strongCyan, "No time"),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Limit",
                    style: TextStyle(
                      color: AppColors.strongCyan,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LottieBuilder.asset(AppAssets.instructions2),
              // child: Image.asset(AppAssets.instruction2),
            ),
          ],
        ),
      ),
    );
  }

  Widget instructionView1() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.instructionsColor1,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(90),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(
          right: 60,
        ),
        child: Row(
          children: [
            Expanded(
              child: LottieBuilder.asset(AppAssets.instructions1),
              // child: Image.asset(AppAssets.instruction1),
            ),
            Expanded(
              child: Row(
                children: [
                  roundedView(
                      AppColors.appColor, questionsDetails.length.toString()),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Question",
                    style: TextStyle(
                      color: AppColors.appColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget backgroundAndButton() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: SvgPicture.asset(
              AppAssets.journeyLine,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Utility.button(
            context,
            gradientColor1: AppColors.buttonGradient1,
            gradientColor2: AppColors.buttonGradient2,
            onPressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              Utility.showStartQuizDialog(
                context: context,
                onStartPress: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => TestScreen(
                        subtopic: widget.subtopic,
                        subject: widget.subject,
                        setDetails: widget.setDetails,
                        questionsDetails: questionsDetails,
                      ),
                    ),
                  );
                },
              );
            },
            text: "Start Quiz",
          ),
        )
      ],
    );
  }

  Widget roundedView(Color color, String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
