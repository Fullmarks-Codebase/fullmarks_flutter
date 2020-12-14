import 'package:flutter/material.dart';
import 'package:fullmarks/screens/IntroSliderScreen.dart';
import 'package:fullmarks/widgets/otp_screen.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return OtpScreen(
      otpLength: 6,
      validateOtp: validateOtp,
      routeCallback: moveToNextScreen,
    );
  }

  // logic to validate otp return [null] when success else error [String]
  Future<String> validateOtp(String otp) async {
    await Future.delayed(Duration(milliseconds: 2000));
    if (otp == "123456") {
      return null;
    } else {
      return "The entered Otp is wrong";
    }
  }

  // action to be performed after OTP validation is success
  void moveToNextScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntroSliderScreen(),
      ),
    );
  }
}
