import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/ClassResponse.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/models/UsersResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';

class ChangeGradeScreen extends StatefulWidget {
  @override
  _ChangeGradeScreenState createState() => _ChangeGradeScreenState();
}

class _ChangeGradeScreenState extends State<ChangeGradeScreen> {
  List<ClassDetails> gradesList = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  Customer customer;

  @override
  void initState() {
    customer = Utility.getCustomer();
    _getClass();
    _notify();
    super.initState();
  }

  _getClass() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      ClassResponse response = ClassResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.getClass, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        gradesList = response.result;
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

  Future<Null> _handleRefresh() async {
    _getClass();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Choose Grade",
        ),
        gradeList(),
      ],
    );
  }

  Widget gradeList() {
    return Expanded(
      child: _isLoading
          ? Utility.progress(context)
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: gradesList.length == 0
                  ? ListView(
                      padding: EdgeInsets.all(16),
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              ((AppBar().preferredSize.height * 2) + 100),
                          child: Utility.emptyView("No Grades"),
                        ),
                      ],
                    )
                  : GridView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      itemCount: gradesList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return gradeItemView(index);
                      },
                    ),
            ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget gradeItemView(int index) {
    return GestureDetector(
      onTap: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        _changeGrade(gradesList[index].id.toString());
        _notify();
      },
      child: Container(
        decoration: BoxDecoration(
          color: customer.classGrades.id == gradesList[index].id
              ? AppColors.strongCyan
              : AppColors.appColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2.5,
              child: SvgPicture.asset(
                AppAssets.grageItemBg,
                width: MediaQuery.of(context).size.width / 2.5,
                fit: BoxFit.fill,
                color: Color(0x1affffff),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2.5,
              child: SvgPicture.network(
                AppStrings.classImage + gradesList[index].classImage,
                fit: BoxFit.contain,
                placeholderBuilder: (context) {
                  return Image.asset(AppAssets.subjectPlaceholder);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _changeGrade(String classId) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["customerId"] = customer.id.toString();
      request["classId"] = classId;
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.changeClass, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        _getUser();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _getUser() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["customerId"] = customer.id.toString();
      //api call
      UsersResponse response = UsersResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.customer, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        if (response.result.length > 0) {
          Customer tempCustomer = response.result.first;
          tempCustomer.token = customer.token;
          await PreferenceUtils.setString(
              AppStrings.userPreference, jsonEncode(tempCustomer.toJson()));
          customer = Utility.getCustomer();
          _notify();
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }
}
