import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/models/UsersResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:image_picker/image_picker.dart';

import 'ChangeGradeScreen.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Customer customer;
  bool _isLoading = false;
  File _image;
  final _picker = ImagePicker();
  // TextEditingController _usernameController = TextEditingController();
  // TextEditingController _usernameController = TextEditingController();
  // TextEditingController _usernameController = TextEditingController();
  // TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    customer = Utility.getCustomer();
    _notify();
    _getUser();
    super.initState();
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
                customer.gender == AppStrings.male
                    ? "Male"
                    : customer.gender == AppStrings.female
                        ? "Female"
                        : "-",
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
              // Utility.leaderBoardView(),
              accountDetailsView(),
              profileDetails()
            ],
          ),
        ),
        _isLoading ? Utility.progress(context) : Container(),
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
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeGradeScreen(),
              ),
            );
            _getUser();
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
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
                  customer.classGrades.name,
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
          ),
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
                        image: _image == null
                            ? DecorationImage(
                                image: NetworkImage(AppStrings.userImage +
                                    customer.userProfileImage),
                              )
                            : Image.file(_image),
                      ),
                    ),
          Positioned(
            right: 10,
            child: GestureDetector(
              onTap: () {
                _onProfilePicTap();
              },
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
          ),
        ],
      ),
    );
  }

  _onProfilePicTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Select Profile Picture"),
          message: Text("Select from"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
              child: Text("Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        );
      },
    );
  }

  _getImage(ImageSource source) async {
    _picker.getImage(source: source).then((value) {
      if (value != null) {
        _image = File(value.path);
      } else {
        print('No image selected.');
      }
      _notify();
    }).catchError((onError) {
      print(onError);
    });
  }
}
