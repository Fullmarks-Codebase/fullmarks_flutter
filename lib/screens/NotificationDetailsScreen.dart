import 'package:flutter/material.dart';
import 'package:fullmarks/models/NotificationResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
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
        ],
      ),
    );
  }
}
