import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/MockTestResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/ReportsResponse.dart';
import 'package:fullmarks/screens/MockTestQuizScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'TestResultScreen.dart';

class MockTestScreen extends StatefulWidget {
  @override
  _MockTestScreenState createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  List<MockTestDetails> mocktests = List();

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.mockTestEvent);
    _getMocktest();
    super.initState();
  }

  _getMocktest() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      MockTestResponse response = MockTestResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.mock, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        mocktests = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Future<Null> _handleRefresh() async {
    _getMocktest();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

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
      child: _isLoading
          ? Utility.progress(context)
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: mocktests.length == 0
                  ? ListView(
                      padding: EdgeInsets.all(16),
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              ((AppBar().preferredSize.height * 2) + 100),
                          child: Utility.emptyView("No Mock Test"),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16),
                      itemCount: mocktests.length,
                      itemBuilder: (BuildContext context, int index) {
                        return mockTestItemView(index);
                      },
                    ),
            ),
    );
  }

  getTestResult(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["mockId"] = mocktests[index].id.toString();
      //api call
      ReportsResponse response = ReportsResponse.fromJson(
        await ApiManager(context).postCall(
          url: AppStrings.mockMyReport,
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
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => TestResultScreen(
              questionsDetails: questionsDetails,
              subtopic: null,
              subject: null,
              setDetails: null,
              reportDetails:
                  Utility.getCustomer() == null ? null : response.result,
              title: mocktests[index].name,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Utility.showToast(response.message);
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget mockTestItemView(int index) {
    return GestureDetector(
      onTap: () {
        if (mocktests[index].submitted == 1) {
          getTestResult(index);
        } else {
          if (mocktests[index].questionCount == 0) {
            Utility.showToast("No questions in this mock test");
          } else if (mocktests[index].time <= 0) {
            Utility.showToast("Invalid time for this mock test");
          } else {
            Utility.showStartQuizDialog(
              context: context,
              onStartPress: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MockTestQuizScreen(
                      mockTest: mocktests[index],
                    ),
                  ),
                );
              },
            );
          }
        }
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
                        mocktests[index].name,
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
                              mocktests[index].questionCount.toString() +
                                  " Question",
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
                              Utility.getHMS(mocktests[index].time),
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
                SvgPicture.asset(mocktests[index].submitted == 0
                    ? AppAssets.whiteNext
                    : AppAssets.cyanCheck),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
