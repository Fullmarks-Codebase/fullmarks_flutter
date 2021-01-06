import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:permission_handler/permission_handler.dart';

class AddFriendScreen extends StatefulWidget {
  String title;
  String buttonStr;
  bool isShare;
  AddFriendScreen({
    @required this.buttonStr,
    @required this.title,
    @required this.isShare,
  });
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  Iterable<Contact> friends = List();
  Iterable<Contact> suggestionList = List();
  ScrollController controller;
  TextEditingController _searchQueryController = TextEditingController();
  List<int> selectedContact = List();
  bool _isLoading = false;

  @override
  void initState() {
    controller = ScrollController();
    getContacts();
    super.initState();
  }

  getContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      _isLoading = true;
      _notify();
      await ContactsService.getContacts().then((value) {
        _isLoading = false;
        _notify();
        friends = value;
        suggestionList = friends;
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
          Column(
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
        searchView(),
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
          Navigator.pop(context);
        },
        text: widget.buttonStr,
      ),
    );
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
              (p) => p.displayName.contains(
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
      child: ListView.separated(
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
          leading: CircleAvatar(
            backgroundColor: AppColors.greyColor10,
            child: Text(
              suggestionList.toList()[index].displayName == null ||
                      suggestionList.toList()[index].displayName == ""
                  ? "-"
                  : suggestionList.toList()[index].displayName.substring(0, 1),
              style: TextStyle(
                color: AppColors.greyColor11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: Text(
            suggestionList.toList()[index].displayName ?? "-",
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
