import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Customer customer;

  @override
  void initState() {
    customer = Customer.fromJson(
        jsonDecode(PreferenceUtils.getString(AppStrings.userPreference)));
    _notify();
    super.initState();
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
          Utility.setSvgFullScreen(context, AppAssets.profileBg),
          body(),
          Column(
            children: [
              Utility.appbar(
                context,
                text: "",
                onBackPressed: () {
                  Navigator.pop(context);
                },
                isHome: false,
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget profileDetails() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Profile Detail",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.pencil),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.drawerMyProfile),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                customer.username == "" ? "-" : customer.username,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.email),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                customer.email == "" ? "-" : customer.email,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.gender),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                customer.gender == "" ? "-" : customer.gender,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.birthday),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                customer.dob == "" ? "-" : customer.dob,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget accountDetailsView() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              SvgPicture.asset(AppAssets.mobile),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  customer.phoneNumber,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.pencil),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        Utility.profileTopView(
          context,
          assetName: AppAssets.profileTopBg,
        ),
        Container(
          padding: MediaQuery.of(context).padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              userImage(),
              SizedBox(
                height: 8,
              ),
              nameClassView(),
              Utility.leaderBoardView(),
              accountDetailsView(),
              profileDetails()
            ],
          ),
        ),
      ],
    );
  }

  Widget nameClassView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          customer.username == "" ? "-" : customer.username,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.class1,
              color: Colors.white,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Class Four',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: null,
            )
          ],
        ),
      ],
    );
  }

  dummyUserView(double size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.appColor,
          width: 2,
        ),
      ),
      height: size,
      width: size,
      child: Icon(
        Icons.person,
        color: AppColors.appColor,
        size: size / 1.5,
      ),
    );
  }

  Widget userImage() {
    return Container(
      height: (MediaQuery.of(context).size.height / 3.5) / 2,
      width: (MediaQuery.of(context).size.width / 3.5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          customer == null
              ? dummyUserView((MediaQuery.of(context).size.height / 3.5) / 2)
              : customer.userProfileImage == ""
                  ? dummyUserView(
                      (MediaQuery.of(context).size.height / 3.5) / 2)
                  : Container(
                      height: (MediaQuery.of(context).size.height / 3.5) / 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.appColor,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: AssetImage(AppAssets.dummyUser),
                        ),
                      ),
                    ),
          Positioned(
            right: 10,
            child: Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.myProgressIncorrectcolor,
                  width: 2,
                ),
              ),
              child: SvgPicture.asset(
                AppAssets.pencil,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
