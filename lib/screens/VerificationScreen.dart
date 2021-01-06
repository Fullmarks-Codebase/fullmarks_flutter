import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/IntroSliderScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  String phoneNumber;
  VerificationScreen({
    @required this.phoneNumber,
  });
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _timerDuration = 30;
  StreamController _timerStream = new StreamController<int>();
  Timer _resendCodeTimer;
  bool _isLoading = false;
  bool _isOTPResend = false;

  @override
  void initState() {
    _activeCounter();
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
        //when counter is zero resend otp
        _resendOtp();
      }
    });
  }

  _resendOtp() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      _isOTPResend = true;
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["phoneNumber"] = widget.phoneNumber;
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.login, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
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
      initialData: 30,
      stream: _timerStream.stream,
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        return SizedBox(
          width: 300,
          height: 30,
          child: Text(
            "Auto Resending in " + snapshot.data.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.appColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  // logic to validate otp return [null] when success else error [String]
  Future<String> validateOtp(String otp) async {
    if (await ApiManager.checkInternet()) {
      //cancel resend timer if validating otp
      _resendCodeTimer.cancel();
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["phoneNumber"] = widget.phoneNumber;
      request["otp"] = otp;
      //api call
      var apiCall = await ApiManager(context)
          .postCall(url: AppStrings.verify, request: request);

      UserResponse response = UserResponse.fromJson(apiCall);

      _isLoading = false;
      _notify();

      if (response.customer != null) {
        Utility.showToast("User Logged in Successfully");
        PreferenceUtils.setString(
            AppStrings.userPreference, jsonEncode(response.customer.toJson()));
        return null;
      } else {
        CommonResponse response = CommonResponse.fromJson(apiCall);
        //if error from verify otp then restart resend counter
        _activeCounter();
        return response.message;
      }
    } else {
      return AppStrings.noInternet;
    }
  }

  // action to be performed after OTP validation is success
  void moveToNextScreen(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => IntroSliderScreen(),
        ),
        (Route<dynamic> route) => false);
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
