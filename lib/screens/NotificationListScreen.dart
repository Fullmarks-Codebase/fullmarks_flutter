import 'package:flutter/material.dart';
import 'package:fullmarks/screens/NotificationDetailsScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.notificationBg),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Notifications",
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        notificationList(),
      ],
    );
  }

  Widget notificationList() {
    return Expanded(
      child: ListView.separated(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return notificationItemView(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return index == 0 ? Container() : Divider();
        },
      ),
    );
  }

  Widget notificationItemView(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => NotificationDetailsScreen(),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 12,
        ),
        color: index == 0 ? AppColors.unreadColor : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 12,
                    ),
                    child: Text(
                      "Notification Title",
                      style: TextStyle(
                        color: index == 0 ? AppColors.appColor : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 12,
                      right: 12,
                    ),
                    child: Text(
                      index == 0
                          ? "A day ago"
                          : (index.toString()) + " days ago",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            index == 0
                ? Container(
                    margin: EdgeInsets.only(
                      left: 12,
                      right: 12,
                    ),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.appColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
