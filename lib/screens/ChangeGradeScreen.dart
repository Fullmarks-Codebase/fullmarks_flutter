import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/ClassResponse.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/GuestUserResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/models/UsersResponse.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';

class ChangeGradeScreen extends StatefulWidget {
  bool isFirstTime;
  ChangeGradeScreen({
    @required this.isFirstTime,
  });
  @override
  _ChangeGradeScreenState createState() => _ChangeGradeScreenState();
}

class _ChangeGradeScreenState extends State<ChangeGradeScreen> {
  List<ClassDetails> gradesList = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  Customer customer;
  GuestUserDetails guest;

  @override
  void initState() {
    getCustomerGuest();
    _getClass();
    super.initState();
  }

  getCustomerGuest() {
    customer = Utility.getCustomer();
    guest = Utility.getGuest();
    _notify();
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
          isBack: customer == null
              ? guest.classGrades != null
              : customer.classGrades != null,
          isHome: customer == null
              ? guest.classGrades != null
              : customer.classGrades != null,
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
        if (customer == null) {
          _changeGradeGuest(gradesList[index].id.toString());
        } else {
          _changeGradeCustomer(gradesList[index].id.toString());
        }
        _notify();
      },
      child: Container(
        decoration: BoxDecoration(
          color: (customer == null
                      ? guest.classGrades?.id
                      : customer.classGrades?.id) ==
                  gradesList[index].id
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

  _changeGradeGuest(String classId) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["id"] = guest.id.toString();
      request["classId"] = classId;
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .putCall(url: AppStrings.changeClassGuest, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        _getGuest();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _changeGradeCustomer(String classId) async {
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
        _getCustomer();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _getGuest() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["imei"] = guest.imei;

      //api call
      GuestUserResponse response = GuestUserResponse.fromJson(
        await ApiManager(context).postCall(
          url: AppStrings.guestLogin,
          request: request,
        ),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        await PreferenceUtils.setString(AppStrings.guestUserPreference,
            jsonEncode(response.result.toJson()));
        guest = response.result;
        _notify();
        if (widget.isFirstTime) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(),
              ),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _getCustomer() async {
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
          if (widget.isFirstTime) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
                (Route<dynamic> route) => false);
          }
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }
}
