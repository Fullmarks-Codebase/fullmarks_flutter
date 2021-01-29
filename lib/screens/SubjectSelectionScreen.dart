import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/CreateQuizLobbyScreen.dart';
import 'package:fullmarks/screens/RandomQuizMatchScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class SubjectSelectionScreen extends StatefulWidget {
  String title;
  bool isRandomQuiz;
  SubjectSelectionScreen({
    @required this.title,
    @required this.isRandomQuiz,
  });
  @override
  _SubjectSelectionScreenState createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  List<SubjectDetails> subjects = List();
  bool _isLoading = false;
  Customer customer;

  @override
  void initState() {
    _getUser();
    _getSubjects();
    super.initState();
  }

  _getUser() {
    customer = Utility.getCustomer();
    _notify();
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  _getSubjects() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["userId"] = customer.id.toString();
      request["id"] = customer.classGrades.id.toString();
      request["calledFrom"] = "app";
      //api call
      SubjectsResponse response = SubjectsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.subjects, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        subjects = response.result;
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
          _isLoading ? Utility.progress(context) : Container(),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.title,
          isHome: false,
          textColor: Colors.white,
        ),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(64),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(64),
              bottomLeft: Radius.circular(8),
            ),
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SvgPicture.asset(
                AppAssets.newQuizSubjectBg,
                color: AppColors.lightAppColor,
              ),
              subjectView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget subjectView() {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          "Select Subject to Play",
          style: TextStyle(
            color: AppColors.appColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 32,
        ),
        GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 16.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return subjectItemView(index);
          },
        ),
      ],
    );
  }

  Widget subjectItemView(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.isRandomQuiz
                ? RandomQuizMatchScreen()
                : CreateQuizLobbyScreen(),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: Utility.imageLoader(
                baseUrl: AppStrings.subjectImage,
                url: subjects[index].image,
                placeholder: AppAssets.subjectPlaceholder,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              subjects[index].name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
