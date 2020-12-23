import 'package:flutter/material.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/Utiity.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
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
          text: "Add a Friend",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
        ),
      ],
    );
  }
}
