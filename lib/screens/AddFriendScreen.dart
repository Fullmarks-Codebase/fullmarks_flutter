import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

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
  List<Friends> friends = [
    Friends("Ankit Solanki", false),
    Friends("Brijesh Kumar", false),
    Friends("Chintan Kumar", false),
    Friends("Jasprit Bumrah", false),
    Friends("Mohammed Siraj", false),
    Friends("Mahendra Singh Dhoni", false),
    Friends("Ravichandran Ashwin", false),
    Friends("Ravindra Jadeja", false),
    Friends("Virat kohli", false),
    Friends("Umesh Yadav", false),
  ];
  List<Friends> suggestionList = List();
  ScrollController controller;
  TextEditingController _searchQueryController = TextEditingController();

  @override
  void initState() {
    controller = ScrollController();
    suggestionList = friends;
    super.initState();
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
          )
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
          onBackPressed: () {
            Navigator.pop(context);
          },
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
        onPressed: () {
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
    if (mounted)
      setState(() {
        suggestionList = newQuery.isEmpty
            ? friends
            : friends
                .where((p) =>
                    p.name.contains(RegExp(newQuery, caseSensitive: false)))
                .toList();
      });
  }

  void _clearSearchQuery() {
    if (mounted)
      setState(() {
        _searchQueryController.clear();
        updateSearchQuery("");
      });
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
          onTap: () {
            if (mounted)
              setState(() {
                suggestionList[index].isChecked =
                    !suggestionList[index].isChecked;
              });
          },
          leading: CircleAvatar(
            backgroundColor: AppColors.greyColor10,
            child: Text(
              suggestionList[index].name.substring(0, 1),
              style: TextStyle(
                color: AppColors.greyColor11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: Text(
            suggestionList[index].name,
            style: TextStyle(
              color: AppColors.blackColor,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: SvgPicture.asset(suggestionList[index].isChecked
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
                  onPressed: () {
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
