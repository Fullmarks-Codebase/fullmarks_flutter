import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/SubjectReportResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/SubtopicResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/SetsScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class SubTopicScreen extends StatefulWidget {
  SubjectDetails subject;
  SubTopicScreen({
    @required this.subject,
  });
  @override
  _SubTopicScreenState createState() => _SubTopicScreenState();
}

class _SubTopicScreenState extends State<SubTopicScreen> {
  Customer customer;
  bool _isLoading = false;
  List<SubtopicDetails> subtopics = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  SubjectReportDetails subjectReportDetails;

  @override
  void initState() {
    customer = Utility.getCustomer();
    _getSubtopic();
    if (customer != null) {
      AppFirebaseAnalytics.init().logEvent(name: AppStrings.subTopicEvent);
      _getSubjectProgress();
    } else {
      AppFirebaseAnalytics.init().logEvent(name: AppStrings.guestSubTopicEvent);
    }
    _notify();
    super.initState();
  }

  _getSubjectProgress() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["classId"] = customer.classGrades.id.toString();
      request["subjectId"] = widget.subject.id.toString();
      request["calledFrom"] = "app";
      //api call
      SubjectReportResponse response = SubjectReportResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.subjectReport, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        if (response.result.length > 0) {
          subjectReportDetails = response.result.first;
        }
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  _getSubtopic() async {
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
      request["subjectId"] = widget.subject.id.toString();
      request["calledFrom"] = "app";
      //api call
      SubtopicResponse response = SubtopicResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.subTopics, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        subtopics = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
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
    _getSubtopic();
    _getSubjectProgress();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.subject.name,
        ),
        Expanded(
          child: _isLoading
              ? Utility.progress(context)
              : RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _handleRefresh,
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    physics: AlwaysScrollableScrollPhysics(),
                    children: subtopics.length == 0
                        ? [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height -
                                  ((AppBar().preferredSize.height * 2) + 100),
                              child: Utility.emptyView("No Subtopics"),
                            ),
                          ]
                        : [
                            myProgressView(),
                            SizedBox(
                              height: 16,
                            ),
                            subTopicList()
                          ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget subTopicList() {
    return Column(
      children: List.generate(subtopics.length, (index) {
        return subTopicItemView(index);
      }),
    );
  }

  Widget subTopicItemView(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.subtopicItemColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.subtopicItemBorderColor,
            width: 2,
          ),
        ),
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => SetsScreen(
                subtopic: subtopics[index],
                subject: widget.subject,
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtopics[index].name,
                      style: TextStyle(
                        color: AppColors.subtopicItemBorderColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Utility.getCustomer() != null
                        ? Text(
                            subtopics[index].completed + "% Completed",
                            style: TextStyle(
                              color: AppColors.subtopicItemBorderColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.subtopicItemBorderColor,
                ),
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget myProgressView() {
    return customer == null
        ? Utility.noUserProgressView(context)
        : Container(
            decoration: BoxDecoration(
              color: AppColors.chartBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(8),
            child: subjectReportDetails == null
                ? noProgressView()
                : subjectReportDetails.correct != "" &&
                        subjectReportDetails.correct != "null" &&
                        subjectReportDetails.correct != null
                    ? progressView()
                    : noProgressView(),
          );
  }

  Widget noProgressView() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          SvgPicture.asset(AppAssets.sad),
          SizedBox(
            height: 8,
          ),
          Text(
            "No progress found",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "give a test to see progress",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget progressView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: (MediaQuery.of(context).size.width / 2),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: (MediaQuery.of(context).size.width / 2) / 3,
                  width: (MediaQuery.of(context).size.width / 2) / 3,
                  // child: SvgPicture.network(
                  //   AppStrings.subjectImage + widget.subject.image,
                  //   fit: BoxFit.contain,
                  //   placeholderBuilder: (context) {
                  //     return Image.asset(AppAssets.subjectPlaceholder);
                  //   },
                  // ),
                  child: Utility.imageLoader(
                    baseUrl: AppStrings.subjectImage,
                    url: widget.subject.image,
                    placeholder: AppAssets.subjectPlaceholder,
                  ),
                ),
                Utility.pieChart(
                  values: [
                    double.tryParse(subjectReportDetails.correct),
                    double.tryParse(subjectReportDetails.incorrect),
                    double.tryParse(subjectReportDetails.skipped),
                  ],
                ),
              ],
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Utility.correctIncorrectView(
                isCorrect: true,
                title: "Correct: " + subjectReportDetails.correct,
              ),
              SizedBox(
                height: 8,
              ),
              Utility.correctIncorrectView(
                isIncorrect: true,
                title: "Incorrect: " + subjectReportDetails.incorrect,
              ),
              SizedBox(
                height: 8,
              ),
              Utility.correctIncorrectView(
                isSkipped: true,
                title: "Skipped: " + subjectReportDetails.skipped,
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
              Utility.averageView(
                assetName: AppAssets.avgAccuracy,
                title: "Avg. Accuracy = ${subjectReportDetails.accuracy}%",
              ),
              SizedBox(
                height: 8,
              ),
              Utility.averageView(
                assetName: AppAssets.avgTime,
                title: "Avg. Time/Question = ${subjectReportDetails.avgTime}",
              ),
            ],
          ),
        )
      ],
    );
  }
}
