import 'package:flutter/material.dart';
import 'package:fullmarks/models/NotificationResponse.dart';
import 'package:fullmarks/screens/JoinQuizScreen.dart';
import 'package:fullmarks/screens/MyFriendsScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class NotificationDetailsScreen extends StatefulWidget {
  NotificationDetails notificationDetail;
  NotificationDetailsScreen({
    @required this.notificationDetail,
  });
  @override
  _NotificationDetailsScreenState createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.notificationDetailsEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utility.appbar(
          context,
          text: "Notifications",
        ),
        notificationItemView(),
      ],
    );
  }

  Widget notificationItemView() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.notificationDetail.title,
            style: TextStyle(
              color: AppColors.appColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            widget.notificationDetail.createdAt,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.notificationDetail.body,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          widget.notificationDetail.notifyType == AppStrings.friends
              ? Utility.button(
                  context,
                  gradientColor1: AppColors.buttonGradient1,
                  gradientColor2: AppColors.buttonGradient2,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyFriendsScreen(),
                      ),
                    );
                  },
                  text: "My Friends",
                )
              : Container(),
          widget.notificationDetail.room.length != 0
              ? Utility.button(
                  context,
                  gradientColor1: AppColors.buttonGradient1,
                  gradientColor2: AppColors.buttonGradient2,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => JoinQuizScreen(
                          roomId: widget.notificationDetail.room.toString(),
                        ),
                      ),
                    );
                  },
                  text: "Join Live Quiz",
                )
              : Container()
        ],
      ),
    );
  }
}
