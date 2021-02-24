import 'package:flutter/material.dart';
import 'package:fullmarks/models/SubjectReportResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/MyProgressSubjectScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class MyProgressScreen extends StatefulWidget {
  @override
  _MyProgressScreenState createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  bool _isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Customer customer;
  List<SubjectReportDetails> subjectReportDetails = List();

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.myProgressEvent);
    customer = Utility.getCustomer();
    _getSubjectProgress();
    super.initState();
  }

  Future<Null> _handleRefresh() async {
    _getSubjectProgress();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
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
          subjectReportDetails = response.result;
        }
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
          text: "My Progress",
        ),
        myProgressList(),
      ],
    );
  }

  Widget myProgressList() {
    return Expanded(
      child: _isLoading
          ? Utility.progress(context)
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: subjectReportDetails.length == 0
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
                      itemCount: subjectReportDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return myProgressItemView(index);
                      },
                    ),
            ),
    );
  }

  Widget myProgressItemView(int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppColors.subtopicItemBorderColor,
            width: 2,
          ),
        ),
        color: AppColors.mathsColor,
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MyProgressSubjectScreen(
                subject: subjectReportDetails[index].subject,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.width / 2) / 3,
                      width: (MediaQuery.of(context).size.width / 2) / 3,
                      // child: SvgPicture.network(
                      //   AppStrings.subjectImage +
                      //       subjectReportDetails[index].subject.image,
                      //   fit: BoxFit.contain,
                      //   placeholderBuilder: (context) {
                      //     return Image.asset(AppAssets.subjectPlaceholder);
                      //   },
                      // ),
                      child: Utility.imageLoader(
                        baseUrl: AppStrings.subjectImage,
                        url: subjectReportDetails[index].subject.image,
                        placeholder: AppAssets.subjectPlaceholder,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Text(
                        subjectReportDetails[index].subject.name,
                        style: TextStyle(
                          color: AppColors.subtopicItemBorderColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.width / 4.5),
                width: (MediaQuery.of(context).size.width / 4.5),
                child: Utility.pieChart(
                  values: [
                    double.tryParse(subjectReportDetails[index].incorrect),
                    double.tryParse(subjectReportDetails[index].correct),
                    double.tryParse(subjectReportDetails[index].skipped)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
