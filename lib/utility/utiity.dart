import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:fullmarks/screens/LoginScreen.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';

import 'AppAssets.dart';
import 'AppColors.dart';

class Utility {
  static showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
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
    BoxFit fit = BoxFit.cover,
  }) {
    return (url == "null" || url == null || url.trim() == "")
        ? Image.asset(placeholder)
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

  static Widget emptyView(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  // static launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: 8,
        right: 8,
      ),
      child: ClipOval(
        child: Material(
          shape: CircleBorder(
            side: BorderSide(
              color:
                  assetName == null ? Colors.transparent : AppColors.appColor,
            ),
          ),
          color: assetName == null ? Colors.transparent : Colors.white,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              child:
                  assetName == null ? Container() : SvgPicture.asset(assetName),
            ),
            onTap: assetName == null ? null : onPressed,
          ),
        ),
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
    double padding = 16,
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
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
        ),
      ),
      child: FlatButton(
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

  static Widget appbar(
    BuildContext context, {
    @required String text,
    Function() onBackPressed,
    bool isHome = true,
    bool isBack = true,
    Color textColor = Colors.black,
    String homeassetName,
    Function onHomePressed,
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
                alignment: Alignment.center,
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
    @required Color color,
    @required String title,
    double fontSize = 16,
    Color textColor = Colors.white,
  }) {
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
      2,
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
              color: AppColors.myProgressIncorrectcolor,
              value: values[1],
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
    List<double> values = const [75, 25],
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

  static Widget leaderBoardView() {
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
                          "Likes : 234",
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
                          "Buddies : 340",
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
                "Leaderboard Rank : 301",
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
                "Do you want to  delete this Question?",
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

  static List<String> getCategories({
    bool isAll = true,
  }) {
    return isAll
        ? [
            "All",
            "English",
            "Science",
            "Math",
            "Biology",
            "Physics",
            "Chemistry"
          ]
        : ["English", "Science", "Math", "Biology", "Physics", "Chemistry"];
  }

  static Widget categoryItemView({
    @required String title,
    @required Function(int) onTap,
    @required int selectedCategory,
  }) {
    int index = getCategories().indexOf(title);
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Container(
        margin: EdgeInsets.only(
          right: (getCategories().length - 1) == index ? 0 : 8,
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

  static Widget textFieldIcons(
    BuildContext context, {
    @required Function onPickImageTap,
    @required Function onKeyboardTap,
    @required Function onSymbolTap,
    @required Function onBigTTap,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPickImageTap,
          child: Container(
            color: Colors.transparent,
            child: SvgPicture.asset(
              AppAssets.pickImages,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: onKeyboardTap,
          child: Container(
            color: Colors.transparent,
            child: SvgPicture.asset(
              AppAssets.keyboard,
              color: MediaQuery.of(context).viewInsets.bottom == 0
                  ? AppColors.blackColor2
                  : AppColors.appColor,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: onSymbolTap,
          child: Container(
            color: Colors.transparent,
            child: SvgPicture.asset(
              AppAssets.symbol,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: onBigTTap,
          child: Container(
            color: Colors.transparent,
            child: SvgPicture.asset(
              AppAssets.bigT,
            ),
          ),
        ),
      ],
    );
  }

  static Widget discussionUserView() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              bottom: 16,
              right: 16,
            ),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(AppAssets.dummyUser),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'User Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '15th Sep, 2020',
                      style: TextStyle(
                        color: AppColors.lightTextColor,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Container(
                      height: 12,
                      width: 12,
                      child: SvgPicture.asset(
                        AppAssets.sci,
                        color: AppColors.appColor,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Science",
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget discussionListSeparator() {
    return Container(
      height: 10,
      color: AppColors.dividerColor,
    );
  }

  static Widget likeCommentView(
    String assetName,
    String count,
  ) {
    return Row(
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

  static String getUsername() {
    Customer customer = getCustomer();
    return customer == null
        ? ""
        : customer.username == ""
            ? customer.phoneNumber
            : customer.username;
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
}
