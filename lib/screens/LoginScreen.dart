import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullmarks/models/FacebookResponse.dart';
import 'package:fullmarks/models/GuestUserResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/IntroSliderScreen.dart';
import 'package:fullmarks/screens/VerificationScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:imei_plugin/imei_plugin.dart';

import 'ChangeGradeScreen.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  TextEditingController _phoneNumberController = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SvgPicture.asset(
                AppAssets.topbarBg1,
                width: MediaQuery.of(context).size.width,
              ),
              body(),
            ],
          ),
          _isLoading ? Utility.progress(context) : Container(),
        ],
      ),
    );
  }

  Widget body1() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.3,
      child: Column(
        children: [
          Container(
            height: (MediaQuery.of(context).size.height / 1.3) / 2.5,
            child: SvgPicture.asset(AppAssets.loginLogo),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _phoneNumberController,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: "Enter your mobile phone",
                suffixIcon: Icon(Icons.phone_android),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    '+91 ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Utility.button(
              context,
              gradientColor1: AppColors.buttonGradient1,
              gradientColor2: AppColors.buttonGradient2,
              onPressed: () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                _verifyTap();
              },
              text: "Verify",
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Or Get started with",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Utility.button(
                    context,
                    bgColor: AppColors.fbColor,
                    onPressed: () async {
                      //delay to give ripple effect
                      await Future.delayed(
                          Duration(milliseconds: AppStrings.delay));
                      facebookSignin();
                    },
                    assetName: AppAssets.facebook,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Utility.button(
                    context,
                    bgColor: AppColors.googleColor,
                    onPressed: () async {
                      //delay to give ripple effect
                      await Future.delayed(
                          Duration(milliseconds: AppStrings.delay));
                      googleSignin();
                    },
                    assetName: AppAssets.google,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  googleSignin() {
    _googleSignIn.signIn().then((value) async {
      if (value.id == null || value.id.length == 0) {
        Utility.showToast("Invalid google id");
      } else if (value.email == null || value.email.length == 0) {
        Utility.showToast("Email not found. Cannot login without email.");
      } else {
        var request = Map<String, dynamic>();
        request["email"] = value.email;
        request["googleId"] = value.id;
        request["googleSign"] = "true";
        request["registrationToken"] = await FirebaseMessaging().getToken();
        checkin(request);
      }
    }).catchError((onError) {
      Utility.showToast(onError.toString());
    });
  }

  facebookSignin() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.logIn(['email']).then((result) {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          getFacebookData(result.accessToken.token);
          break;
        case FacebookLoginStatus.cancelledByUser:
          Utility.showToast("Login cancelled by the user.");
          break;
        case FacebookLoginStatus.error:
          print(result.errorMessage);
          Utility.showToast('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  getFacebookData(String token) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api call
      FacebookResponse response = FacebookResponse.fromJson(
        await ApiManager(context).getCall(
            url:
                'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token',
            request: null),
      );

      if (response.id.length != 0 || response.email.length != 0) {
        var request = Map<String, dynamic>();
        request["email"] = response.email;
        request["facebookId"] = response.id;
        request["facebookSign"] = "true";
        request["registrationToken"] = await FirebaseMessaging().getToken();
        checkin(request);
      } else {
        //hide progress
        _isLoading = false;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  checkin(var request) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api call
      UserResponse response = UserResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.login, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        await PreferenceUtils.setString(
            AppStrings.userPreference, jsonEncode(response.result.toJson()));
        _notify();
        if (response.result.classGrades == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => ChangeGradeScreen(
                  isFirstTime: true,
                ),
              ),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    PreferenceUtils.getBool(AppStrings.introSliderPreference)
                        ? HomeScreen()
                        : IntroSliderScreen(),
              ),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget body2() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Utility.button(
          context,
          bgColor: AppColors.strongCyan,
          onPressed: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            //default bool value in shared preference is true
            //so make it false
            guestLogin();
          },
          text: "Skip This Step",
        ),
      ),
    );
  }

  guestLogin() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["imei"] = await ImeiPlugin.getImei();

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
        if (response.result.classGrades == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => ChangeGradeScreen(
                  isFirstTime: true,
                ),
              ),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    PreferenceUtils.getBool(AppStrings.introSliderPreference)
                        ? HomeScreen()
                        : IntroSliderScreen(),
              ),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget body() {
    return Expanded(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          body1(),
          body2(),
        ],
      ),
    );
  }

  _verifyTap() {
    if (_phoneNumberController.text.trim().length == 0) {
      Utility.showToast("Please enter your mobile phone");
    } else if (_phoneNumberController.text.trim().length < 10) {
      Utility.showToast("Please enter your mobile phone with 10 digits");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => VerificationScreen(
            phoneNumber: _phoneNumberController.text.trim(),
          ),
        ),
      );
    }
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
