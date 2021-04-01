import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/GuestUserResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/ReportsResponse.dart';
import 'package:fullmarks/models/SetReportResponse.dart';
import 'package:fullmarks/models/SetsResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/SubtopicResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/InstructionsScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'AskingForProgressScreen.dart';
import 'TestResultScreen.dart';

class SetsScreen extends StatefulWidget {
  SubtopicDetails subtopic;
  SubjectDetails subject;
  SetsScreen({
    @required this.subtopic,
    @required this.subject,
  });
  @override
  _SetsScreenState createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  Customer customer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  List<SetDetails> setsList = List();
  List<SetReportDetails> setReportDetails;
  GuestUserDetails guest;

  @override
  void initState() {
    customer = Utility.getCustomer();
    guest = Utility.getGuest();
    if (customer != null) {
      AppFirebaseAnalytics.init().logEvent(name: AppStrings.setsEvent);
    }
    if (guest != null) {
      AppFirebaseAnalytics.init().logEvent(name: AppStrings.guestSetsEvent);
    }
    _getSets();
    _notify();
    super.initState();
  }

  _getSets() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      if (customer != null) {
        request["userId"] = customer.id.toString();
      }
      request["calledFrom"] = "app";
      request["topicId"] = widget.subtopic.id.toString();
      //api call
      SetsResponse response = SetsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.sets, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        setsList = response.result;
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

  Future<Null> _handleRefresh() async {
    _getSets();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.subtopic.name,
        ),
        Expanded(
          child: _isLoading
              ? Utility.progress(context)
              : RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _handleRefresh,
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    children: setsList.length == 0
                        ? [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height -
                                  ((AppBar().preferredSize.height * 2) + 100),
                              child: Utility.emptyView("No Sets"),
                            ),
                          ]
                        : List.generate(setsList.length, (index) {
                            return setsItemView(index);
                          }),
                  ),
                ),
        ),
      ],
    );
  }

  Widget setsItemView(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.setsItemGradientColor1,
            AppColors.setsItemGradientColor2
          ],
          stops: [0.25, 0.75],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          if (setsList[index].submitted) {
            //if quiz is submitted then view result
            getTestResult(setsList[index]);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => customer == null
                    ? guest.played >= 2 //its guest
                        ? AskingForProgressScreen() //if two quiz played
                        : InstructionsScreen(
                            subtopic: widget.subtopic,
                            subject: widget.subject,
                            setDetails: setsList[index],
                          )
                    : InstructionsScreen(
                        subtopic: widget.subtopic,
                        subject: widget.subject,
                        setDetails: setsList[index],
                      ),
              ),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  setsList[index].name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(setsList[index].submitted
                    ? AppAssets.check
                    : AppAssets.uncheck),
                onPressed: null,
              )
            ],
          ),
        ),
      ),
    );
  }

  getTestResult(SetDetails setDetails) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["setId"] = setDetails.id.toString();
      //api call
      ReportsResponse response = ReportsResponse.fromJson(
        await ApiManager(context).postCall(
          url: AppStrings.testResult,
          request: request,
        ),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        List<QuestionDetails> questionsDetails = List();
        await Future.forEach(response.result.reportDetail,
            (ReportDetail element) {
          element.question.selectedAnswer = int.tryParse(element.userAnswer);
          questionsDetails.add(element.question);
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => TestResultScreen(
              questionsDetails: questionsDetails,
              subtopic: widget.subtopic,
              subject: widget.subject,
              setDetails: setDetails,
              reportDetails:
                  Utility.getCustomer() == null ? null : response.result,
              title: "",
              isMockTest: false,
              isNormalQuiz: true,
              correctMarks: 0,
              incorrectMarks: 0,
            ),
          ),
        );
      } else {
        Utility.showToast(context, response.message);
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }
}
