import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class OtherProfileScreen extends StatefulWidget {
  bool isMyFriend;
  OtherProfileScreen({
    @required this.isMyFriend,
  });
  @override
  _OtherProfileScreenState createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.profileBg),
          body(),
          Column(
            children: [
              Utility.appbar(
                context,
                text: "",
                onBackPressed: () {
                  Navigator.pop(context);
                },
                isHome: false,
              ),
              Spacer(),
              widget.isMyFriend ? addBuddyView() : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget addBuddyView() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: Utility.bottomDecoration(),
      child: Utility.button(
        context,
        gradientColor1: AppColors.buttonGradient1,
        gradientColor2: AppColors.buttonGradient2,
        onPressed: () {},
        text: "Add Buddy",
      ),
    );
  }

  Widget body() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Utility.profileTopView(
          context,
          assetName: AppAssets.profileBg2,
        ),
        Positioned(
          top: (MediaQuery.of(context).size.height / 3.5) / 1.35,
          child: userImage(),
        ),
        Container(
          padding: EdgeInsets.only(
            top: (MediaQuery.of(context).size.height / 2.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 8,
              ),
              nameClassView(),
              SizedBox(
                height: 8,
              ),
              Utility.leaderBoardView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget nameClassView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Amitstcetet Nohire",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.class1,
              color: Colors.black,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Class Four',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget userImage() {
    return Container(
      height: (MediaQuery.of(context).size.height / 3.5) / 2,
      width: (MediaQuery.of(context).size.height / 3.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.appColor,
          width: 2,
        ),
        image: DecorationImage(
          image: AssetImage(AppAssets.dummyUser),
        ),
      ),
    );
  }
}
