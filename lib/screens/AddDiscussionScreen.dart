import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';
import 'package:fullmarks/notus/notus.dart';
import 'package:fullmarks/zefyr/zefyr.dart';

class AddDiscussionScreen extends StatefulWidget {
  bool isEdit;
  AddDiscussionScreen({
    @required this.isEdit,
  });
  @override
  _AddDiscussionScreenState createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  int selectedCategory = -1;
  FocusNode fn = FocusNode();
  List<SubjectDetails> subjects = List();
  bool _isLoading = false;
  Customer customer = Utility.getCustomer();
  final ZefyrController _controller = ZefyrController(NotusDocument());

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.addDiscussionEvent);
    _getSubjects();
    super.initState();
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
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return ZefyrScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utility.appbar(
            context,
            text: "Add Question",
            homeassetName: AppAssets.checkBlue,
            onHomePressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              if (selectedCategory == -1) {
                Utility.showToast("Please select category");
              } else if (_controller.plainTextEditingValue.text.trim().length ==
                  0) {
                Utility.showToast("Please type your question");
              } else {
                addQuestion();
              }
            },
          ),
          _isLoading
              ? Container()
              : Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    "Select Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          _isLoading ? Container() : categoryView(),
          _isLoading
              ? Container()
              : Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    color: AppColors.greyColor9,
                    padding: EdgeInsets.all(16),
                    child: ZefyrField(
                      decoration: InputDecoration(
                        hintText: "Type your question",
                        border: InputBorder.none,
                      ),
                      controller: _controller,
                      focusNode: fn,
                      autofocus: false,
                      imageDelegate: CustomImageDelegate(),
                      physics: ClampingScrollPhysics(),
                    ),
                  ),
                ),
          _isLoading ? Expanded(child: Utility.progress(context)) : Container()
        ],
      ),
    );
  }

  addQuestion() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["subjectId"] = subjects[selectedCategory].id.toString();
      request["question"] = jsonEncode(_controller.document);
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.addPosts, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        Navigator.of(context).pop();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget categoryView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Row(
          children: subjects.map((e) {
            int index = subjects.indexOf(e);
            return Utility.categoryItemView(
              title: subjects[index].name,
              selectedCategory: selectedCategory,
              onTap: (index) {
                selectedCategory = index;
                _notify();
              },
              index: index,
              isLast: (subjects.length - 1) == index,
            );
          }).toList(),
        ),
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
