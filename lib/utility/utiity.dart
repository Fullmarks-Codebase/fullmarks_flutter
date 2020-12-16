import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fullmarks/screens/HomeScreen.dart';
import 'package:package_info/package_info.dart';

import 'appAssets.dart';
import 'appColors.dart';

class Utility {
  static showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  static Widget progress(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white.withOpacity(0.5),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            backgroundColor: AppColors.appColor.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
          ),
        ),
      ),
    );
  }

  // static Widget imageLoader(String url, String placeholder,
  //     {BoxFit fit = BoxFit.cover}) {
  //   return (url == "null" || url == null || url.trim() == "")
  //       ? Image.asset(placeholder)
  //       : CachedNetworkImage(
  //           imageUrl: url,
  //           imageBuilder: (context, imageProvider) => Container(
  //             decoration: BoxDecoration(
  //               image: DecorationImage(
  //                 image: imageProvider,
  //                 fit: fit,
  //               ),
  //             ),
  //           ),
  //           placeholder: (context, url) => progress(context),
  //           errorWidget: (context, url, error) =>
  //               Image.asset(AppAssets.imageNotFound),
  //         );
  // }

  static Widget emptyView(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  static Image imageLoaderImage(String url, String placeholder) {
    return url == null || url == ""
        ? Image.asset(placeholder)
        : Image.network(
            url,
            // (url.startsWith("http")) ? url : AppStrings.IMAGEBASE_URL + url,
            fit: BoxFit.contain,
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
    return SafeArea(
      child: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 1,
                color: AppColors.appColor,
              ),
            ],
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(assetName),
        ),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onPressed,
      ),
    );
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
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(padding),
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
        child: text != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isPrefix
                      ? Container(
                          margin: EdgeInsets.only(
                            right: 8,
                          ),
                          child: SvgPicture.asset(
                            assetName,
                          ),
                        )
                      : Container(),
                  Text(
                    text,
                    style: TextStyle(
                      color: textcolor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isSufix
                      ? Container(
                          margin: EdgeInsets.only(
                            left: 8,
                          ),
                          child: SvgPicture.asset(
                            assetName,
                          ),
                        )
                      : Container(),
                ],
              )
            : assetName != null
                ? SvgPicture.asset(
                    assetName,
                  )
                : Container(),
      ),
    );
  }

  static Widget appbar(
    BuildContext context, {
    @required String text,
    @required Function() onBackPressed,
    bool isHome = true,
    bool isBack = true,
  }) {
    return Row(
      children: [
        isBack
            ? Utility.roundShadowButton(
                context: context,
                assetName: AppAssets.backArrow,
                onPressed: onBackPressed,
              )
            : Container(),
        Spacer(),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        isHome
            ? Utility.roundShadowButton(
                context: context,
                assetName: AppAssets.home,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen(),
                      ),
                      (Route<dynamic> route) => false);
                },
              )
            : Container(),
      ],
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
  }) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
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
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  static List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        // final isTouched = i == touchedIndex;
        // final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: AppColors.myProgressCorrectcolor,
              value: 75,
              showTitle: false,
            );
          case 1:
            return PieChartSectionData(
              color: AppColors.myProgressIncorrectcolor,
              value: 25,
              showTitle: false,
            );
          default:
            return null;
        }
      },
    );
  }

  static List<Subject> getsubjects() {
    return [
      Subject(
        AppAssets.maths,
        "Mathmatics",
        "7% Completed",
      ),
      Subject(
        AppAssets.physics,
        "Physics",
        "100% Completed",
      ),
      Subject(
        AppAssets.chemistry,
        "Chemistry",
        "20% Completed",
      ),
      Subject(
        AppAssets.biology,
        "Biology",
        "20% Completed",
      ),
      Subject(
        AppAssets.english,
        "English",
        "20% Completed",
      ),
    ];
  }

  static BoxDecoration selectedAnswerDecoration() {
    return BoxDecoration(
      color: AppColors.myProgressIncorrectcolor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: AppColors.myProgressIncorrectcolor,
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

  static BoxDecoration defaultDecoration() {
    return BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.black,
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

  static BoxDecoration getSubmitedDecoration() {
    return BoxDecoration(
      color: AppColors.strongCyan,
      shape: BoxShape.circle,
      border: Border.all(
        color: AppColors.strongCyan,
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

  static BoxDecoration getCurrentDecoration() {
    return BoxDecoration(
      color: AppColors.appColor,
      shape: BoxShape.circle,
      border: Border.all(
        color: AppColors.appColor,
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
}

class Subject {
  String assetName;
  String title;
  String subtitle;

  Subject(String assetName, String title, String subtitle) {
    this.assetName = assetName;
    this.title = title;
    this.subtitle = subtitle;
  }
}
