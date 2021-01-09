import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/SubtopicResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/SetsScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
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
  bool isProgress = false;
  Customer customer;
  bool _isLoading = false;
  List<SubtopicDetails> subtopics = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    customer = Utility.getCustomer();
    _getSubtopic();
    _notify();
    super.initState();
  }

  _getSubtopic() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["subjectId"] = widget.subject.id.toString();
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

  Future<Null> _handleRefresh() async {
    _getSubtopic();
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
                    Text(
                      "0% Completed",
                      style: TextStyle(
                        color: AppColors.subtopicItemBorderColor,
                      ),
                    ),
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
            child: isProgress ? progressView() : noProgressView(),
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
                  child: Utility.imageLoader(
                    baseUrl: AppStrings.subjectImage,
                    url: widget.subject.image,
                    placeholder: AppAssets.subjectPlaceholder,
                  ),
                ),
                Utility.pieChart(),
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
                color: AppColors.myProgressCorrectcolor,
                title: "Incorrect: 5",
              ),
              SizedBox(
                height: 8,
              ),
              Utility.correctIncorrectView(
                color: AppColors.myProgressIncorrectcolor,
                title: "Correct: 120",
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
                title: "Avg. Accuracy = 82%",
              ),
              SizedBox(
                height: 8,
              ),
              Utility.averageView(
                assetName: AppAssets.avgTime,
                title: "Avg. Time/Question = 1:15",
              ),
            ],
          ),
        )
      ],
    );
  }
}
