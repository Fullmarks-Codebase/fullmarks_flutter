import 'package:flutter/material.dart';
import 'package:fullmarks/screens/OtherProfileScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/Utiity.dart';

class MyFriendsScreen extends StatefulWidget {
  @override
  _MyFriendsScreenState createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {
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
      children: [
        Utility.appbar(
          context,
          text: "My Friends",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
        ),
        myFriendsList(),
      ],
    );
  }

  Widget myFriendsList() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(
          bottom: 16,
        ),
        itemCount: 25,
        itemBuilder: (BuildContext context, int index) {
          return myFriendsItemView(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  Widget myFriendsItemView(int index) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherProfileScreen(
              isMyFriend: index % 2 == 0,
            ),
          ),
        );
      },
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(AppAssets.dummyUser),
          ),
        ),
      ),
      title: Text(
        'User Name',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
