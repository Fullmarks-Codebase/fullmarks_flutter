import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fullmarks/models/GuestUserResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/screens/LoginScreen.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'AppAssets.dart';
import 'AppColors.dart';

class Utility {
  static showToast(BuildContext context, String msg) {
    Fluttertoast.showToast(
      msg: msg,
    );
  }

  static showAnswerToast(BuildContext context, String msg, Color textColor) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Container(
        child: Text(
          msg,
          style: TextStyle(
            color: textColor,
            fontSize: 30,
            fontWeight: FontWeight.w900,
            shadows: [
              BoxShadow(
                offset: Offset(1, 0),
                blurRadius: 5,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }

  static Widget progress(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // color: Colors.white.withOpacity(0.5),
      child: Container(
        width: MediaQuery.of(context).size.width /
            1.5, // change this value to increase/decrease size of progress
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LottieBuilder.asset(AppAssets.loading),
          // child: LinearProgressIndicator(
          //   backgroundColor: AppColors.appColor.withOpacity(0.1),
          //   valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
          // ),
        ),
      ),
    );
  }

  static Widget imageLoader({
    @required String baseUrl,
    @required String url,
    @required String placeholder,
    BoxFit fit = BoxFit.contain,
    Color placeholderColor,
  }) {
    return (url == "null" || url == null || url.trim() == "")
        ? Image.asset(
            placeholder,
            color: placeholderColor,
          )
        : CachedNetworkImage(
            imageUrl: (url.startsWith("http")) ? url : baseUrl + url,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
            placeholder: (context, url) => progress(context),
            errorWidget: (context, url, error) =>
                Image.asset(AppAssets.imageNotFound),
          );
  }

  static Widget emptyView(String text, {Color textColor = Colors.black}) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }

  static launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast(context, "Invalid url");
    }
  }

  static Widget setSvgFullScreen(BuildContext context, String assetName) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SvgPicture.asset(
        assetName,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
    );
    await PackageInfo.fromPlatform().then((value) {
      _packageInfo = value;
    });
    return _packageInfo;
  }

  static Widget roundShadowButton({
    @required BuildContext context,
    @required String assetName,
    @required Function() onPressed,
    bool isBadge = false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipOval(
            child: Material(
              shape: CircleBorder(
                side: BorderSide(
                  color: assetName == null
                      ? Colors.transparent
                      : AppColors.appColor,
                ),
              ),
              color: assetName == null ? Colors.transparent : Colors.white,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: assetName == null
                      ? Container()
                      : SvgPicture.asset(assetName),
                ),
                onTap: assetName == null ? null : onPressed,
              ),
            ),
          ),
          isBadge
              ? Positioned(
                  right: 0,
                  child: SvgPicture.asset(AppAssets.redDot),
                )
              : Container()
        ],
      ),
    );
    // return SafeArea(
    //   bottom: false,
    //   child: Container(
    //     padding: EdgeInsets.only(
    //       bottom: 16,
    //     ),
    //     child: FlatButton(
    //       color: assetName == null ? Colors.transparent : Colors.white,
    //       shape: CircleBorder(
    //         side: BorderSide(
    //           color:
    //               assetName == null ? Colors.transparent : AppColors.appColor,
    //         ),
    //       ),
    //       onPressed: assetName == null ? null : onPressed,
    //       child: assetName == null ? Container() : SvgPicture.asset(assetName),
    //     ),
    //   ),
    // );
    // return SafeArea(
    //   bottom: false,
    //   child: Container(
    //     padding: EdgeInsets.only(
    //       bottom: 16,
    //     ),
    //     child: IconButton(
    //       icon: Container(
    //         padding: EdgeInsets.all(8),
    // decoration: assetName == null
    //     ? BoxDecoration()
    //     : BoxDecoration(
    //         color: Colors.white,
    //         boxShadow: [
    //           BoxShadow(
    //             offset: Offset(0, 1),
    //             blurRadius: 1,
    //             color: AppColors.appColor,
    //           ),
    //         ],
    //         shape: BoxShape.circle,
    //       ),
    //         child:
    //             assetName == null ? Container() : SvgPicture.asset(assetName),
    //       ),
    //       onPressed: onPressed,
    //     ),
    //   ),
    // );
  }

  static Widget button(
    BuildContext context, {
    @required Function() onPressed,
    Color bgColor,
    Color gradientColor1,
    Color gradientColor2,
    Color textcolor = Colors.white,
    double radius = 8,
    double padding = 8,
    double fontSize = 16,
    String text,
    String assetName,
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    Color borderColor,
    bool isPrefix = false,
    bool isSufix = false,
    bool isSpacer = false,
    double height = 60,
    double borderWidth = 1.0,
    double width,
  }) {
    if (width == null) {
      width = MediaQuery.of(context).size.width;
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        gradient: gradientColor1 == null || gradientColor2 == null
            ? null
            : LinearGradient(
                begin: begin,
                end: end,
                colors: [gradientColor1, gradientColor2],
                stops: [0.25, 0.75],
              ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor == null ? Colors.transparent : borderColor,
          width: borderWidth,
        ),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(padding),
        child: text != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: 8,
                    ),
                    child: isPrefix
                        ? SvgPicture.asset(
                            assetName,
                          )
                        : Container(),
                  ),
                  isSpacer ? Spacer() : Container(),
                  Text(
                    text,
                    style: TextStyle(
                      color: textcolor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isSpacer ? Spacer() : Container(),
                  Container(
                    margin: EdgeInsets.only(
                      left: 8,
                    ),
                    child: isSufix
                        ? SvgPicture.asset(
                            assetName,
                          )
                        : Container(),
                  ),
                ],
              )
            : assetName != null
                ? SvgPicture.asset(
                    assetName,
                  )
                : Container(),
        onPressed: onPressed,
      ),
    );
  }

  static Future<bool> quitLiveQuizDialog({
    @required BuildContext context,
    @required Function onPressed,
  }) async {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do you want to quit this Live Quiz?",
                style: TextStyle(
                  color: AppColors.appColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                bgColor: AppColors.redColor2,
                onPressed: onPressed,
                text: "Quit",
              ),
              SizedBox(
                height: 8,
              ),
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                },
                text: "Cancel",
                textcolor: AppColors.appColor,
                borderColor: AppColors.appColor,
              )
            ],
          ),
        );
      },
    );
  }

  static Widget appbar(
    BuildContext context, {
    @required String text,
    Function() onBackPressed,
    bool isHome = true,
    bool isBack = true,
    Color textColor = Colors.black,
    String homeassetName,
    Function onHomePressed,
    Widget sufixWidget,
    bool isTitleCenter = true,
  }) {
    if (homeassetName == null) {
      homeassetName = AppAssets.home;
    }
    if (onHomePressed == null) {
      onHomePressed = () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
            (Route<dynamic> route) => false);
      };
    }
    if (onBackPressed == null) {
      onBackPressed = () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        Navigator.pop(context);
      };
    }
    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 16,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            roundShadowButton(
              context: context,
              assetName: isBack ? AppAssets.backArrow : null,
              onPressed: isBack ? onBackPressed : null,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                alignment:
                    isTitleCenter ? Alignment.center : Alignment.centerRight,
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            roundShadowButton(
              context: context,
              assetName: isHome ? homeassetName : null,
              onPressed: isHome ? onHomePressed : null,
            ),
            sufixWidget == null ? Container() : sufixWidget,
            SizedBox(
              width: 8,
            ),
          ],
        ),
      ),
    );
  }

  static Widget averageView({
    @required String assetName,
    @required String title,
  }) {
    return Row(
      children: [
        SvgPicture.asset(assetName),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  static Widget correctIncorrectView({
    Color color,
    bool isCorrect = false,
    bool isIncorrect = false,
    bool isSkipped = false,
    @required String title,
    double fontSize = 16,
    Color textColor = Colors.white,
  }) {
    if (color == null) {
      color = Colors.transparent;
      if (isCorrect) {
        color = AppColors.myProgressCorrectcolor;
      }
      if (isIncorrect) {
        color = AppColors.wrongBorderColor;
      }
      if (isSkipped) {
        color = AppColors.myProgressIncorrectcolor;
      }
    }
    return Row(
      children: [
        Container(
          height: fontSize,
          width: fontSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  static List<PieChartSectionData> showingSections(List<double> values) {
    return List.generate(
      values.length,
      (i) {
        // final isTouched = i == touchedIndex;
        // final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.myProgressCorrectcolor,
              value: values[0],
              showTitle: false,
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.wrongBorderColor,
              value: values[1],
              showTitle: false,
            );
          case 2:
            return PieChartSectionData(
              color: AppColors.myProgressIncorrectcolor,
              value: values[2],
              showTitle: false,
            );
          default:
            return null;
        }
      },
    );
  }

  static BoxDecoration selectedAnswerDecoration({
    Color color,
  }) {
    if (color == null) {
      color = AppColors.myProgressIncorrectcolor;
    }
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: color,
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1,
          color: Colors.black38,
        ),
      ],
    );
  }

  static BoxDecoration defaultAnswerDecoration() {
    return BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: AppColors.blackColor,
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1,
          color: Colors.black38,
        ),
      ],
    );
  }

  static BoxDecoration resultAnswerDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: color,
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 1,
          color: Colors.black38,
        ),
      ],
    );
  }

  static Widget pieChart({
    List<double> values = const [70, 20, 10], //incorrect - correct
  }) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
          // click on pie
          // setState(() {
          //   if (pieTouchResponse.touchInput is FlLongPressEnd ||
          //       pieTouchResponse.touchInput is FlPanEnd) {
          //     touchedIndex = -1;
          //   } else {
          //     touchedIndex = pieTouchResponse.touchedSectionIndex;
          //   }
          // });
        }),
        startDegreeOffset: 0,
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 10,
        sections: showingSections(values),
      ),
    );
  }

  static Widget profileTopView(
    BuildContext context, {
    @required String assetName,
  }) {
    return Stack(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height / 3.5) + 25,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.setsItemGradientColor1,
                        AppColors.setsItemGradientColor2
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.width / 3.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.setsItemGradientColor1,
                    AppColors.setsItemGradientColor2
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(MediaQuery.of(context).size.width / 3.5),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 30,
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height / 3.5,
          child: SvgPicture.asset(
            assetName,
            width: MediaQuery.of(context).size.width,
            color: AppColors.appColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  static Widget leaderBoardView(String likes, String buddies, String rank) {
    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            color: Colors.black38,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(AppAssets.like),
                        onPressed: null,
                      ),
                      Expanded(
                        child: Text(
                          "Likes : " + likes,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(AppAssets.drawerMyBuddies),
                        onPressed: null,
                      ),
                      Expanded(
                        child: Text(
                          "Friends : " + buddies,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: SvgPicture.asset(AppAssets.trophy),
                onPressed: null,
              ),
              Text(
                "Leaderboard Rank : " + rank,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  static showStartQuizDialog({
    @required BuildContext context,
    @required Function onStartPress,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do you want to start Quiz?",
                style: TextStyle(
                  color: AppColors.appColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              button(
                context,
                gradientColor1: AppColors.buttonGradient1,
                gradientColor2: AppColors.buttonGradient2,
                onPressed: onStartPress,
                text: "Start",
                assetName: AppAssets.play,
                isPrefix: true,
              ),
              SizedBox(
                height: 8,
              ),
              button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                },
                text: "Cancel",
                textcolor: AppColors.appColor,
                borderColor: AppColors.appColor,
              )
            ],
          ),
        );
      },
    );
  }

  static showSubmitQuizDialog({
    @required BuildContext context,
    @required Function onSubmitPress,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do you want to Submit Quiz?",
                style: TextStyle(
                  color: AppColors.appColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              button(
                context,
                gradientColor1: AppColors.buttonGradient1,
                gradientColor2: AppColors.buttonGradient2,
                onPressed: onSubmitPress,
                text: "Submit",
                assetName: AppAssets.submit,
                isPrefix: true,
              ),
              SizedBox(
                height: 8,
              ),
              button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                },
                text: "Back to Quiz",
                textcolor: AppColors.appColor,
                borderColor: AppColors.appColor,
              )
            ],
          ),
        );
      },
    );
  }

  static showDeleteDialog({
    @required BuildContext context,
    @required String title,
    @required Function onDeletePress,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.appColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              button(
                context,
                bgColor: AppColors.redColor2,
                onPressed: onDeletePress,
                text: "Delete",
              ),
              SizedBox(
                height: 8,
              ),
              button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context);
                },
                text: "Cancel",
                textcolor: AppColors.appColor,
                borderColor: AppColors.appColor,
              )
            ],
          ),
        );
      },
    );
  }

  static Widget categoryItemView({
    @required String title,
    @required Function(int) onTap,
    @required int selectedCategory,
    @required bool isLast,
    @required int index,
  }) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Container(
        margin: EdgeInsets.only(
          right: isLast ? 0 : 8,
        ),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              selectedCategory == index ? AppColors.strongCyan : Colors.white,
          border: Border.all(
            color: AppColors.strongCyan,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedCategory == index ? Colors.white : Colors.black,
            // fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget discussionListSeparator() {
    return Container(
      height: 10,
      color: AppColors.dividerColor,
    );
  }

  static Widget likeCommentView({
    @required String assetName,
    @required String count,
    @required Function onPressed,
  }) {
    return ButtonTheme(
      minWidth: 60,
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          child: Row(
            children: [
              SvgPicture.asset(
                assetName,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                count,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static BoxDecoration bottomDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      ),
      boxShadow: [
        BoxShadow(
          offset: Offset(1, 0),
          blurRadius: 5,
          color: Colors.black12,
        ),
      ],
    );
  }

  static String getUsername({Customer customer}) {
    if (customer == null) {
      customer = getCustomer();
    }
    return customer == null
        ? ""
        : customer.username == ""
            ? "User" + customer.id.toString()
            : customer.username;
  }

  static Widget getUserImage({
    @required String url,
    double width = 50,
    double borderWidth = 2,
    double height = 50,
    Color bordercolor,
    Color placeholderColor,
    double borderRadius = 50,
  }) {
    if (bordercolor == null) {
      bordercolor = AppColors.appColor;
    }
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: bordercolor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageLoader(
          baseUrl: AppStrings.userImage,
          url: url,
          placeholder: AppAssets.person,
          placeholderColor: placeholderColor,
        ),
      ),
    );
  }

  static GuestUserDetails getGuest() {
    if (PreferenceUtils.getString(AppStrings.guestUserPreference) == "") {
      return null;
    }
    return GuestUserDetails.fromJson(
        jsonDecode(PreferenceUtils.getString(AppStrings.guestUserPreference)));
  }

  static Customer getCustomer() {
    if (PreferenceUtils.getString(AppStrings.userPreference) == "") {
      return null;
    }
    return Customer.fromJson(
        jsonDecode(PreferenceUtils.getString(AppStrings.userPreference)));
  }

  static Widget noUserProgressView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 3,
            color: Colors.black38,
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "Please Login or Signup to \nTrack your Progress",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: button(
              context,
              gradientColor1: AppColors.buttonGradient1,
              gradientColor2: AppColors.buttonGradient2,
              onPressed: () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen(),
                    ),
                    (Route<dynamic> route) => false);
              },
              text: "Sign Up",
            ),
          )
        ],
      ),
    );
  }

  static int getQuestionCorrectAnswer(QuestionDetails questionDetails) {
    return questionDetails.ansOneStatus
        ? 0
        : questionDetails.ansTwoStatus
            ? 1
            : questionDetails.ansThreeStatus
                ? 2
                : questionDetails.ansFourStatus
                    ? 3
                    : -1;
  }

  static String getHMS(int seconds) {
    if (seconds == null) return "";
    final int minutes = (seconds / 60).truncate();
    final int hours = (minutes / 60).truncate();
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    return "$hoursStr.$minutesStr.$secondsStr";
  }

  static String secondsToHms(double secs) {
    int hours = (secs / (60 * 60)).floor();

    double divisorForMinutes = secs % (60 * 60);
    int minutes = (divisorForMinutes / 60).floor();

    double divisorForSeconds = divisorForMinutes % 60;
    int seconds = (divisorForSeconds).ceil();

    String hDisplay =
        hours > 0 ? (hours.toString() + (hours == 1 ? "h " : "h ")) : "";
    return hDisplay + minutes.toString() + "m " + seconds.toString() + "s";
  }

  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static String getLiveQuizLink(
      String roomId, String className, String subjectName) {
    String txt = AppStrings.heyAppNameStr +
        "\n\n" +
        "Room ID : " +
        roomId +
        (className == null ? "" : "\nClass : ") +
        (className == null ? "" : className) +
        (subjectName == null ? "" : "\nSubject : ") +
        (subjectName == null ? "" : subjectName) +
        "\n\n" +
        AppStrings.alreadyApp +
        "https://fullmarks.app/" +
        AppStrings.joinLiveQuizDeepLinkKey +
        "/" +
        roomId +
        " to join my LIVE quiz !";
    print(txt);
    return txt;
  }

  static Widget horizontalItemView({
    @required BuildContext context,
    @required Color color,
    @required String assetName,
    @required String text,
    @required String buttonText,
    EdgeInsets margin,
    @required Function onTap,
    bool isPng = false,
    bool isComingSoon = false,
  }) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: isPng ? Image.asset(assetName) : SvgPicture.asset(assetName),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                text.trim().length == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          5,
                          (index) => SvgPicture.asset(AppAssets.star),
                        ),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                SizedBox(
                  height: 16,
                ),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Utility.button(
                      context,
                      onPressed: isComingSoon ? () {} : onTap,
                      text: buttonText,
                      gradientColor1: Color(0xFF76B5FF),
                      gradientColor2: Color(0xFF4499FF),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      fontSize: 14,
                      height: 40,
                    ),
                    isComingSoon
                        ? Image.asset(
                            AppAssets.comingSoon,
                            height: 20,
                            width: 80,
                          )
                        : Container()
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget drawerItemView({
    @required String assetName,
    @required String text,
    @required Function onTap,
    bool iscomingsoon = false,
  }) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: iscomingsoon ? () {} : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 55,
              child: SvgPicture.asset(
                assetName,
                height: 15,
                width: 15,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Spacer(),
            iscomingsoon
                ? Image.asset(
                    AppAssets.comingSoon,
                    height: 30,
                    width: 90,
                  )
                : Container(),
            SizedBox(
              width: 4,
            )
          ],
        ),
      ),
    );
  }

  static String convertDate(String date) {
    return DateFormat("dd MMMM, yyyy")
        .format(DateFormat("yyyy-MM-dd").parse(date));
  }

  static Widget iconButton({
    @required String assetName,
    @required Function onPressed,
  }) {
    return ButtonTheme(
      minWidth: 30,
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          child: Row(
            children: [
              SvgPicture.asset(
                assetName,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static BoxDecoration attemptedDecoration() {
    return BoxDecoration(
      color: AppColors.strongCyan,
      borderRadius: BorderRadius.circular(8),
    );
  }

  static BoxDecoration activeDecoration() {
    return BoxDecoration(
      color: AppColors.greyColor4,
      border: Border.all(
        color: AppColors.wrongBorderColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  static BoxDecoration notAttemptedDecoration() {
    return BoxDecoration(
      color: AppColors.greyColor2,
      borderRadius: BorderRadius.circular(8),
    );
  }

  static String getRankShareText(int rank) {
    String rankTitleStr = rank.toString().endsWith("11") ||
            rank.toString().endsWith("12") ||
            rank.toString().endsWith("13")
        ? "th"
        : rank.toString().endsWith("1")
            ? "st"
            : rank.toString().endsWith("2")
                ? "nd"
                : rank.toString().endsWith("3")
                    ? "rd"
                    : "th";
    return "I just got $rank$rankTitleStr rank in Fullmarks- The Learning App.\nCome join and beat me on Fullmarks- The Learning App where learning is fun.\n${AppStrings.playStore} \nIf you already have the app, click here - ${AppStrings.deepLinkURL}";
  }
}
