import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/NotificationResponse.dart';
import 'package:fullmarks/screens/NotificationDetailsScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  bool _isLoading = false;
  List<NotificationDetails> notificationDetails = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _getNotifications();
    super.initState();
  }

  _getNotifications() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      NotificationResponse response = NotificationResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.getNotification, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        notificationDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Future<Null> _handleRefresh() async {
    _getNotifications();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

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
        ),
        notificationList(),
      ],
    );
  }

  Widget notificationList() {
    return Expanded(
      child: _isLoading
          ? Utility.progress(context)
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: notificationDetails.length == 0
                  ? ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              ((AppBar().preferredSize.height * 2) + 100),
                          child: Utility.emptyView("No Notifications"),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(16),
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: notificationDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return notificationItemView(index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return !notificationDetails[index].status
                            ? Container()
                            : Divider();
                      },
                    ),
            ),
    );
  }

  Widget notificationItemView(int index) {
    return GestureDetector(
      onTap: () {
        _readNotifications(notificationDetails[index].id.toString());
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => NotificationDetailsScreen(
            notificationDetail: notificationDetails[index],
          ),
        ));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 12,
        ),
        color: !notificationDetails[index].status
            ? AppColors.unreadColor
            : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationDetails[index].title,
                    style: TextStyle(
                      color: !notificationDetails[index].status
                          ? AppColors.appColor
                          : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    notificationDetails[index].createdAt,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            !notificationDetails[index].status
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

  _readNotifications(String id) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["id"] = id;
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .putCall(url: AppStrings.readNotification, request: request),
      );
      //hide progress
      if (response.code == 200) {
        _getNotifications();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }
}
