import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  static Widget backButton({
    @required BuildContext context,
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
          child: SvgPicture.asset(
            AppAssets.backArrow,
          ),
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
                  colors: [gradientColor1, gradientColor2],
                  stops: [0.25, 0.75],
                ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: text != null
            ? Text(
                text,
                style: TextStyle(
                  color: textcolor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              )
            : assetName != null
                ? Image.asset(
                    assetName,
                  )
                : Container(),
      ),
    );
  }
}
