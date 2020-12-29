import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class RankListScreen extends StatefulWidget {
  bool isRandomQuiz;
  String title;
  RankListScreen({
    @required this.isRandomQuiz,
    @required this.title,
  });
  @override
  _RankListScreenState createState() => _RankListScreenState();
}

class _RankListScreenState extends State<RankListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.mockTestBg),
          Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                AppAssets.bottomBarbg,
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
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
          text: widget.title,
          onBackPressed: () {
            Navigator.pop(context);
          },
          homeassetName: AppAssets.home,
          textColor: Colors.white,
        ),
        ranklistView(),
      ],
    );
  }

  Widget ranklistView() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          top: 0,
          right: 16,
          left: 16,
          bottom: 80,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(48),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(48),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(
                  top: 32,
                  right: 16,
                  left: 16,
                ),
                itemCount: widget.isRandomQuiz ? 2 : 27,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: AppColors.lightAppColor,
                    thickness: 1,
                  );
                },
                itemBuilder: (context, index) {
                  return rankItemView(index);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Utility.button(
                context,
                onPressed: () {},
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                gradientColor1: AppColors.buttonGradient1,
                gradientColor2: AppColors.buttonGradient2,
                text: "Share",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget rankItemView(int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(
            AppAssets.rankItemBg,
            color: AppColors.lightAppColor,
          ),
        ),
        ListTile(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.myProgressIncorrectcolor,
                width: 2,
              ),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(AppAssets.dummyUser),
              ),
            ),
          ),
          title: Text(
            'User Name' +
                (index == 0
                    ? " (You)"
                    : index == 3
                        ? " (Host)"
                        : ""),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            "#" + (index + 1).toString(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.appColor,
            ),
          ),
        ),
      ],
    );
  }
}
