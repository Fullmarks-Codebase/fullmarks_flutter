import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/ChangeGradeScreen.dart';
import 'package:fullmarks/screens/IntroSliderScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/otp_screen.dart';

import 'HomeScreen.dart';

class VerificationScreen extends StatefulWidget {
  String phoneNumber;
  VerificationScreen({
    @required this.phoneNumber,
  });
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _timerDuration = 60;
  StreamController _timerStream = new StreamController<int>();
  Timer _resendCodeTimer;
  bool _isLoading = false;
  bool _isOTPResend = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String otp = "";
  String _verificationId;
  int _forceResendingToken;
  Customer loggedinCustomer;

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.verificationScreenEvent);
    _activeCounter();
    _verifyPhoneNumber();
    super.initState();
  }

  @override
  dispose() {
    _timerStream.close();
    _resendCodeTimer.cancel();
    super.dispose();
  }

  _activeCounter() {
    _resendCodeTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_timerDuration - timer.tick > 0)
        _timerStream.sink.add(_timerDuration - timer.tick);
      else {
        _timerStream.sink.add(0);
        _resendCodeTimer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OtpScreen(
          otpLength: 6,
          validateOtp: validateOtp,
          routeCallback: moveToNextScreen,
          getAutoSendText: _isOTPResend ? Container() : autoResendOTPView(),
        ),
        _isLoading ? Utility.progress(context) : Container(),
      ],
    );
  }

  Widget autoResendOTPView() {
    return StreamBuilder(
      initialData: 60,
      stream: _timerStream.stream,
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        bool isEnable = snapshot.data == 0;
        return SizedBox(
          height: 30,
          child: FlatButton(
            onPressed: isEnable
                ? () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    _verifyPhoneNumber();
                  }
                : null,
            child: Text(
              "Resend OTP",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isEnable ? AppColors.appColor : AppColors.greyColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  void _verifyPhoneNumber() async {
    _isLoading = true;
    _notify();

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      Utility.showToast(context, authException.message);
      print(authException.code);
      print(authException.message);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Utility.showToast(
          context, "Please check your phone for the verification code.");
      _verificationId = verificationId;
      _forceResendingToken = forceResendingToken;
      _notify();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("codeAutoRetrievalTimeout");
      _verificationId = verificationId;
      _notify();
    };

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {};

    await _auth
        .verifyPhoneNumber(
      phoneNumber: "+91" + widget.phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: _forceResendingToken,
    )
        .then((value) {
      print("then");
    }).catchError((onError) {
      print(onError);
    });

    _isLoading = false;
    _notify();
  }

  // logic to validate otp return [null] when success else error [String]
  Future<String> validateOtp(String otp) async {
    _isLoading = true;
    _notify();
    if (await ApiManager.checkInternet()) {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: otp,
        );
        final User user = (await _auth.signInWithCredential(credential)).user;
        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);

        _isLoading = false;
        _notify();
        if (user != null) {
          print(user);
          return checkin(user.uid);
        } else {
          return "Sign in failed";
        }
      } catch (e) {
        print(e);
        _isLoading = false;
        _notify();
        return e.toString();
      }
    } else {
      _isLoading = false;
      _notify();
      return "No internet connection";
    }
  }

  Future<String> checkin(String phoneId) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["phoneNumber"] = widget.phoneNumber;
      request["phoneId"] = phoneId;
      request["phoneSign"] = "true";
      request["registrationToken"] = await FirebaseMessaging().getToken();
      //api call
      UserResponse response = UserResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.login, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        Utility.showToast(context, response.message);
        loggedinCustomer = response.result;
        await PreferenceUtils.setString(
            AppStrings.userPreference, jsonEncode(response.result.toJson()));
        _notify();
        return null;
      } else {
        return response.message;
      }
    } else {
      //show message that internet is not available
      return AppStrings.noInternet;
    }
  }

  // // logic to validate otp return [null] when success else error [String]
  // Future<String> validateOtp(String otp) async {
  //   if (await ApiManager.checkInternet()) {
  //     //cancel resend timer if validating otp
  //     _resendCodeTimer.cancel();
  //     //show progress
  // _isLoading = true;
  // _notify();
  //     //api request
  //     var request = Map<String, dynamic>();
  //     request["phoneNumber"] = widget.phoneNumber;
  //     request["otp"] = otp;
  //     //api call
  //     var apiCall = await ApiManager(context)
  //         .postCall(url: AppStrings.verify, request: request);

  //     UserResponse response = UserResponse.fromJson(apiCall);

  //     _isLoading = false;
  //     _notify();

  //     if (response.customer != null) {
  //       Utility.showToast(context,"User Logged in Successfully");
  // PreferenceUtils.setString(
  //     AppStrings.userPreference, jsonEncode(response.customer.toJson()));
  //       return null;
  //     } else {
  // CommonResponse response = CommonResponse.fromJson(apiCall);
  // //if error from verify otp then restart resend counter
  // _activeCounter();
  // return response.message;
  //     }
  //   } else {
  //     return AppStrings.noInternet;
  //   }
  // }

  // action to be performed after OTP validation is success
  void moveToNextScreen(context) {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.loginWithPhoneEvent);
    if (loggedinCustomer.classGrades == null) {
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

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
