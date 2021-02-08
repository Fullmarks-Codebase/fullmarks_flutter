import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/MyFriendsResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

class AddFriendScreen extends StatefulWidget {
  String title;
  String buttonStr;
  String roomId;
  AddFriendScreen({
    @required this.buttonStr,
    @required this.title,
    @required this.roomId,
  });
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  Iterable<MyFriendsDetails> friends = List();
  Iterable<MyFriendsDetails> suggestionList = List();
  ScrollController controller;
  TextEditingController _searchQueryController = TextEditingController();
  List<int> selectedContact = List();
  bool _isLoading = false;

  @override
  void initState() {
    controller = ScrollController();
    if (widget.roomId == null) {
      getContacts();
    } else {
      _getMyFriends();
    }
    super.initState();
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
        friends = response.result;
        suggestionList = friends;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  getContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      _isLoading = true;
      _notify();
      await ContactsService.getContacts().then((value) async {
        List<String> strContacts = List();
        await Future.forEach(value, (Contact element) {
          if (element.phones.length > 0) {
            String contact = element.phones.first.value.trim();
            contact = contact.replaceAll("-", "");
            contact = contact.replaceAll("(", "");
            contact = contact.replaceAll(")", "");
            contact = contact.replaceAll("+91", "");
            contact = contact.replaceAll(" ", "");
            if (!strContacts.contains(contact)) {
              strContacts.add(contact);
            }
          }
        });
        _getNotFriends(strContacts);
        _notify();
      }).catchError((onError) {
        _isLoading = false;
        _notify();
        print(onError);
      });
    } else {
      //If permissions have been denied show standard cupertino alert dialog
      openAppSettings();
    }
  }

  _getNotFriends(List<String> strContacts) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["numbers"] = jsonEncode(strContacts);
      //api call
      MyFriendsResponse response = MyFriendsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.notFriend, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        friends = response.result;
        suggestionList = friends;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          body(),
          _isLoading
              ? Container()
              : friends.length == 0
                  ? Container()
                  : Column(
                      children: [
                        Spacer(),
                        buttonView(),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Utility.appbar(
          context,
          text: widget.title,
          isHome: false,
        ),
        _isLoading
            ? Container()
            : friends.length == 0
                ? Container()
                : searchView(),
        friendsList(),
      ],
    );
  }

  Widget buttonView() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: Utility.bottomDecoration(),
      child: Utility.button(
        context,
        gradientColor1: AppColors.buttonGradient1,
        gradientColor2: AppColors.buttonGradient2,
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          if (selectedContact.length == 0) {
            Utility.showToast("Please select atleast one friend.");
          } else {
            if (widget.roomId == null) {
              sendRequest();
            } else {
              shareCode();
            }
          }
        },
        text: widget.buttonStr,
      ),
    );
  }

  sendRequest() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      List<String> strContacts = List();
      await Future.forEach(suggestionList, (MyFriendsDetails element) {
        int index = suggestionList.toList().indexOf(element);
        if (selectedContact.contains(index)) {
          strContacts.add(element.phoneNumber);
        }
      });
      request["numbers"] = jsonEncode(strContacts);
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.sentRequest, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        Navigator.pop(context);
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  shareCode() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      List<String> strContacts = List();
      await Future.forEach(suggestionList, (MyFriendsDetails element) {
        int index = suggestionList.toList().indexOf(element);
        if (selectedContact.contains(index)) {
          strContacts.add(element.phoneNumber);
        }
      });
      request["numbers"] = jsonEncode(strContacts);
      request["roomId"] = widget.roomId;
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.shareCode, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        Navigator.pop(context);
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget searchView() {
    return Container(
      margin: EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.appColor,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(icon: SvgPicture.asset(AppAssets.search), onPressed: null),
          _buildSearchField(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Expanded(
      child: TextField(
        controller: _searchQueryController,
        decoration: InputDecoration(
          hintText: "Search a friend to play with",
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 16.0),
        onChanged: (query) => updateSearchQuery(query),
      ),
    );
  }

  Widget _buildActions() {
    if (_searchQueryController.text.trim().length > 0) {
      return IconButton(
        icon: Icon(
          Icons.clear,
          color: AppColors.appColor,
        ),
        onPressed: () {
          if (_searchQueryController == null ||
              _searchQueryController.text.isEmpty) {
            Navigator.pop(context);
            return;
          }
          _clearSearchQuery();
        },
      );
    }
    return Container();
  }

  void updateSearchQuery(String newQuery) {
    suggestionList = newQuery.isEmpty
        ? friends
        : friends
            .where(
              (p) => p.username.contains(
                RegExp(newQuery, caseSensitive: false),
              ),
            )
            .toList();
    _notify();
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  void _clearSearchQuery() {
    _searchQueryController.clear();
    updateSearchQuery("");
    _notify();
  }

  Widget friendsList() {
    return Expanded(
      child: _isLoading
          ? Utility.progress(context)
          : friends.length == 0
              ? Utility.emptyView("No Friends to add")
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  controller: controller,
                  itemCount: suggestionList.length,
                  itemBuilder: (context, index) {
                    return friendsItemView(index);
                  },
                ),
    );
  }

  Widget friendsItemView(int index) {
    return Column(
      children: [
        ListTile(
          onTap: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            if (selectedContact.contains(index)) {
              selectedContact.remove(index);
            } else {
              selectedContact.add(index);
            }
            _notify();
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
                  AppStrings.userImage +
                      suggestionList.toList()[index].thumbnail,
                ),
              ),
            ),
          ),
          title: Text(
            suggestionList.toList()[index].username == ""
                ? "User" + suggestionList.toList()[index].id.toString()
                : suggestionList.toList()[index].username,
            style: TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: SvgPicture.asset(selectedContact.contains(index)
              ? AppAssets.friendCheck
              : AppAssets.friendUncheck),
        ),
        (suggestionList.length - 1) == index
            ? Container(
                margin: EdgeInsets.only(
                  bottom: 100,
                ),
                child: Utility.roundShadowButton(
                  context: context,
                  assetName: AppAssets.upArrow,
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    controller.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }
}
