import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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
            ],
          ),
        ],
      ),
    );
  }

  Widget profileDetails() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Profile Detail",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.pencil),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.drawerMyProfile),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                "Amitstcetet",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.email),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                "Amits@info.com",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.gender),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                "Male",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.birthday),
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                "18 Dec 1996",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget accountDetailsView() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Account Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              SvgPicture.asset(AppAssets.mobile),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  "+91 9898339898",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                height: 15,
                width: 15,
                child: SvgPicture.asset(AppAssets.pencil),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        Utility.profileTopView(
          context,
          assetName: AppAssets.profileTopBg,
        ),
        Container(
          padding: MediaQuery.of(context).padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              userImage(),
              SizedBox(
                height: 8,
              ),
              nameClassView(),
              Utility.leaderBoardView(),
              accountDetailsView(),
              profileDetails()
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
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.class1,
              color: Colors.white,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Class Four',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              onPressed: null,
            )
          ],
        ),
      ],
    );
  }

  Widget userImage() {
    return Container(
      height: (MediaQuery.of(context).size.height / 3.5) / 2,
      width: (MediaQuery.of(context).size.width / 3.5),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: (MediaQuery.of(context).size.height / 3.5) / 2,
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
          ),
          Positioned(
            right: 10,
            child: Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.myProgressIncorrectcolor,
                  width: 2,
                ),
              ),
              child: SvgPicture.asset(
                AppAssets.pencil,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
