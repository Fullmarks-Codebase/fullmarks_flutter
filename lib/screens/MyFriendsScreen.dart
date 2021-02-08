import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/FriendRequestResponse.dart';
import 'package:fullmarks/models/MyFriendsResponse.dart';
import 'package:fullmarks/screens/OtherProfileScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class MyFriendsScreen extends StatefulWidget {
  @override
  _MyFriendsScreenState createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {
  int currentIndex = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeyReceived =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKeySent =
      new GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  List<MyFriendsDetails> myFriendsDetails = List();
  List<FriendRequestDetails> requestReceivedDetails = List();
  List<FriendRequestDetails> requestSentDetails = List();

  @override
  void initState() {
    _getMyFriends();
    _getRequestsReceived();
    _getRequestsSent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: [
            Utility.setSvgFullScreen(context, AppAssets.commonBg),
            body(),
            _isLoading ? Utility.progress(context) : Container()
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: currentIndex == 0
              ? "My Friends"
              : currentIndex == 1
                  ? "Requests Received"
                  : "Requests Sent",
          isHome: false,
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            bottom: 16,
          ),
          child: Row(
            children: [
              tabsItemView(0, "My Friends", 0),
              SizedBox(
                width: 16,
              ),
              tabsItemView(
                  1, "Requests \nReceived", requestReceivedDetails.length),
              SizedBox(
                width: 16,
              ),
              tabsItemView(2, "Requests \nSent", requestSentDetails.length),
            ],
          ),
        ),
        currentIndex == 0
            ? myFriendsList()
            : currentIndex == 1
                ? requestReceivedList()
                : requestsSentList(),
      ],
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  _getMyFriends() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      MyFriendsResponse response = MyFriendsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.myFriends, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        myFriendsDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _getRequestsReceived() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      FriendRequestResponse response = FriendRequestResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.requestRecieved, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        requestReceivedDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _getRequestsSent() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      //api call
      FriendRequestResponse response = FriendRequestResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.requestSent, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        requestSentDetails = response.result;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget tabsItemView(int index, String text, int badge) {
    return Expanded(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Utility.button(
            context,
            onPressed: () {
              currentIndex = index;
              _notify();
            },
            text: text,
            borderColor: AppColors.tabBorderColor,
            bgColor: AppColors.tabColor,
            fontSize: 14,
            radius: 8,
            borderWidth: currentIndex == index ? 5 : 0,
            padding: 2,
          ),
          badge == 0
              ? Container()
              : Positioned(
                  top: -10,
                  right: -5,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.tabColor,
                        width: 3,
                      ),
                    ),
                    child: Text(
                      badge.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _getMyFriends();
    _getRequestsReceived();
    _getRequestsSent();
    //delay to give ripple effect
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  Widget myFriendsList() {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: myFriendsDetails.length == 0
            ? ListView(
                padding: EdgeInsets.all(16),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        ((AppBar().preferredSize.height * 2) + 100),
                    child: Utility.emptyView("No Friends"),
                  ),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                itemCount: myFriendsDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return myFriendsItemView(index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
      ),
    );
  }

  Widget requestReceivedList() {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKeyReceived,
        onRefresh: _handleRefresh,
        child: requestReceivedDetails.length == 0
            ? ListView(
                padding: EdgeInsets.all(16),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        ((AppBar().preferredSize.height * 2) + 100),
                    child: Utility.emptyView("No Requests Received"),
                  ),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                itemCount: requestReceivedDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return myFriendsItemView(index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
      ),
    );
  }

  Widget requestsSentList() {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKeySent,
        onRefresh: _handleRefresh,
        child: requestSentDetails.length == 0
            ? ListView(
                padding: EdgeInsets.all(16),
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        ((AppBar().preferredSize.height * 2) + 100),
                    child: Utility.emptyView("No Requests Sent"),
                  ),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                itemCount: requestSentDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return myFriendsItemView(index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
      ),
    );
  }

  Widget myFriendsItemView(int index) {
    String thumbnail = currentIndex == 0
        ? myFriendsDetails[index].thumbnail
        : currentIndex == 1
            ? requestReceivedDetails[index].from.thumbnail
            : requestSentDetails[index].to.thumbnail;
    String username = currentIndex == 0
        ? myFriendsDetails[index].username
        : currentIndex == 1
            ? requestReceivedDetails[index].from.username
            : requestSentDetails[index].to.username;
    String id = currentIndex == 0
        ? myFriendsDetails[index].id.toString()
        : currentIndex == 1
            ? requestReceivedDetails[index].from.id.toString()
            : requestSentDetails[index].to.id.toString();
    if (username == "") {
      username = "User" +
          (currentIndex == 0
              ? myFriendsDetails[index].id.toString()
              : currentIndex == 1
                  ? requestReceivedDetails[index].from.id.toString()
                  : requestSentDetails[index].to.id.toString());
    }
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherProfileScreen(
              id: id,
            ),
          ),
        );
      },
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.appColor,
            width: 2,
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              AppStrings.userImage + thumbnail,
            ),
          ),
        ),
      ),
      title: Text(
        username,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: currentIndex == 0
          ? null
          : currentIndex == 1
              ? acceptRejectView(index)
              : pendingView(),
    );
  }

  Widget acceptRejectView(int index) {
    return Container(
      width: 160,
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Utility.button(
              context,
              onPressed: () {
                acceptRejectRequest(index, "1");
              },
              text: "Accept",
              bgColor: AppColors.acceptColor,
              fontSize: 14,
              radius: 8,
              padding: 2,
              height: 40,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Utility.button(
              context,
              onPressed: () {
                acceptRejectRequest(index, "2");
              },
              text: "Reject",
              bgColor: AppColors.rejectColor,
              fontSize: 14,
              radius: 8,
              height: 40,
              padding: 2,
            ),
          )
        ],
      ),
    );
  }

  acceptRejectRequest(int index, String status) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["id"] = requestReceivedDetails[index].id.toString();
      request["fromId"] = requestReceivedDetails[index].fromId.toString();
      request["toId"] = requestReceivedDetails[index].toId.toString();
      request["status"] = status;
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.requestResponse, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        _getMyFriends();
        _getRequestsReceived();
        _getRequestsSent();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget pendingView() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.pendingColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Pending",
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
