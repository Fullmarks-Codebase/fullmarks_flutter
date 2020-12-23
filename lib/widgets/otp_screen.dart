library otp_screen;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  final Future<String> Function(String) validateOtp;
  final void Function(BuildContext) routeCallback;
  Color topColor;
  Color bottomColor;
  bool _isGradientApplied;
  final Color titleColor;
  final Color themeColor;
  final Color keyboardBackgroundColor;

  /// default [otpLength] is 4
  final int otpLength;

  OtpScreen({
    Key key,
    this.otpLength = 4,
    @required this.validateOtp,
    @required this.routeCallback,
    this.themeColor = Colors.black,
    this.titleColor = Colors.black,
    this.keyboardBackgroundColor,
  }) : super(key: key) {
    this._isGradientApplied = false;
  }

  OtpScreen.withGradientBackground({
    Key key,
    this.otpLength = 4,
    @required this.validateOtp,
    @required this.routeCallback,
    this.themeColor = Colors.white,
    this.titleColor = Colors.white,
    @required this.topColor,
    @required this.bottomColor,
    this.keyboardBackgroundColor,
  }) : super(key: key) {
    this._isGradientApplied = true;
  }

  @override
  _OtpScreenState createState() => new _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  Size _screenSize;
  int _currentDigit;
  List<int> otpValues;
  bool showLoadingButton = false;

  @override
  void initState() {
    otpValues = List<int>.filled(widget.otpLength, null, growable: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: widget._isGradientApplied
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.topColor, widget.bottomColor],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  stops: [0, 1],
                  tileMode: TileMode.clamp,
                ),
              )
            : BoxDecoration(color: Colors.white),
        width: _screenSize.width,
        child: _getInputPart,
      ),
    );
  }

  /// Return subTitle label
  get _getSubtitleText {
    return new Text(
      "Enter a verification code we sent to you",
      textAlign: TextAlign.center,
      style: new TextStyle(
          fontSize: 18.0,
          color: widget.titleColor,
          fontWeight: FontWeight.w600),
    );
  }

  get _getAutoSendText {
    return new Text(
      "Auto Resending in 30",
      textAlign: TextAlign.center,
      style:
          new TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w600),
    );
  }

  /// Return "OTP" input fields
  get _getInputField {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: getOtpTextWidgetList(),
    );
  }

  /// Returns otp fields of length [widget.otpLength]
  List<Widget> getOtpTextWidgetList() {
    List<Widget> optList = List();
    for (int i = 0; i < widget.otpLength; i++) {
      optList.add(_otpTextField(otpValues[i]));
    }
    return optList;
  }

  /// Returns Otp screen views
  get _getInputPart {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SvgPicture.asset(
              AppAssets.topbarBg1,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 16,
            ),
            SvgPicture.asset(
              AppAssets.otpImage,
              height: MediaQuery.of(context).size.height / 4,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _getSubtitleText,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: _getAutoSendText,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _getInputField,
            ),
            Spacer(),
            showLoadingButton
                ? Center(
                    child: Utility.progress(context),
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            _getOtpKeyboard
          ],
        ),
        Utility.roundShadowButton(
          context: context,
          assetName: AppAssets.backArrow,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  /// Returns "Otp" keyboard
  get _getOtpKeyboard {
    return Container(
        color: widget.keyboardBackgroundColor,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "1",
                    onPressed: () {
                      _setCurrentDigit(1);
                    }),
                _otpKeyboardInputButton(
                    label: "2",
                    onPressed: () {
                      _setCurrentDigit(2);
                    }),
                _otpKeyboardInputButton(
                    label: "3",
                    onPressed: () {
                      _setCurrentDigit(3);
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "4",
                    onPressed: () {
                      _setCurrentDigit(4);
                    }),
                _otpKeyboardInputButton(
                    label: "5",
                    onPressed: () {
                      _setCurrentDigit(5);
                    }),
                _otpKeyboardInputButton(
                    label: "6",
                    onPressed: () {
                      _setCurrentDigit(6);
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: "7",
                    onPressed: () {
                      _setCurrentDigit(7);
                    }),
                _otpKeyboardInputButton(
                    label: "8",
                    onPressed: () {
                      _setCurrentDigit(8);
                    }),
                _otpKeyboardInputButton(
                    label: "9",
                    onPressed: () {
                      _setCurrentDigit(9);
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new SizedBox(
                  width: 80.0,
                ),
                _otpKeyboardInputButton(
                    label: "0",
                    onPressed: () {
                      _setCurrentDigit(0);
                    }),
                _otpKeyboardActionButton(
                    label: new Icon(
                      Icons.backspace,
                      color: widget.themeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        for (int i = widget.otpLength - 1; i >= 0; i--) {
                          if (otpValues[i] != null) {
                            otpValues[i] = null;
                            break;
                          }
                        }
                      });
                    }),
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Returns "Otp text field"
  Widget _otpTextField(int digit) {
    double size = MediaQuery.of(context).size.width / (widget.otpLength) - 20;
    if (MediaQuery.of(context).size.width > 600) {
      size = 80;
    }
    return new Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: new Text(
        digit != null ? digit.toString() : "",
        style: new TextStyle(
          fontSize: 25.0,
          color: widget.titleColor,
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.titleColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: 80.0,
          width: 80.0,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 30.0,
                color: widget.themeColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  /// sets number into text fields n performs
  ///  validation after last number is entered
  void _setCurrentDigit(int i) async {
    setState(() {
      _currentDigit = i;
      int currentField;
      for (currentField = 0; currentField < widget.otpLength; currentField++) {
        if (otpValues[currentField] == null) {
          otpValues[currentField] = _currentDigit;
          break;
        }
      }
      if (currentField == widget.otpLength - 1) {
        showLoadingButton = true;
        String otp = otpValues.join();
        widget.validateOtp(otp).then((value) {
          showLoadingButton = false;
          if (value == null) {
            widget.routeCallback(context);
          } else if (value.isNotEmpty) {
            Utility.showToast(value);
            clearOtp();
          }
        });
      }
    });
  }

  ///to clear otp when error occurs
  void clearOtp() {
    otpValues = List<int>.filled(widget.otpLength, null, growable: false);
    setState(() {});
  }
}
