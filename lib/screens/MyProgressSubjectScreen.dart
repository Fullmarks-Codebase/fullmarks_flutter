import 'package:flutter/material.dart';
import 'package:fullmarks/models/SetReportResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class MyProgressSubjectScreen extends StatefulWidget {
  SubjectDetails subject;
  MyProgressSubjectScreen({
    @required this.subject,
  });
  @override
  _MyProgressSubjectScreenState createState() =>
      _MyProgressSubjectScreenState();
}

class _MyProgressSubjectScreenState extends State<MyProgressSubjectScreen> {
  bool _isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Customer customer;
  List<SetReportDetails> setReportDetails = List();

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.myProgressSubjectEvent);
    customer = Utility.getCustomer();
    _getSetProgress();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    _getSetProgress();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  _getSetProgress() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["classId"] = customer.classGrades.id.toString();
      request["subjectId"] = widget.subject.id.toString();
      //api call
      SetReportResponse response = SetReportResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.setReport, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        setReportDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
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

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.subject.name,
        ),
        myProgressSubjectList(),
      ],
    );
  }

  Widget myProgressSubjectList() {
    return Expanded(
      child: _isLoading
          ? Utility.progress(context)
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: setReportDetails.length == 0
                  ? ListView(
                      padding: EdgeInsets.all(16),
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              ((AppBar().preferredSize.height * 2) + 100),
                          child: Utility.emptyView("No Report"),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      itemCount: setReportDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return myProgressSubjectItemView(index);
                      },
                    ),
            ),
    );
  }

  Widget myProgressSubjectItemView(int index) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.subtopicItemBorderColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    setReportDetails[index].subject.name,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    setReportDetails[index].setDetails.name,
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              width: 0.5,
            ),
            Expanded(
              flex: 30,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                          child: Utility.pieChart(
                            values: [
                              double.tryParse(
                                  setReportDetails[index].incorrect),
                              double.tryParse(setReportDetails[index].correct),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Utility.correctIncorrectView(
                              color: AppColors.myProgressCorrectcolor,
                              title: "Incorrect: " +
                                  setReportDetails[index].incorrect,
                              fontSize: 14,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Utility.correctIncorrectView(
                              color: AppColors.myProgressIncorrectcolor,
                              title:
                                  "Correct: " + setReportDetails[index].correct,
                              fontSize: 14,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.averageView(
                    assetName: AppAssets.avgAccuracy,
                    title:
                        "Avg. Accuracy = ${setReportDetails[index].accuracy}%",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Utility.averageView(
                    assetName: AppAssets.avgTime,
                    title: "Avg. Time/Question = " +
                        setReportDetails[index].avgTime,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
