import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
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
          text: "Global Rank",
          isHome: false,
          textColor: Colors.white,
        ),
        leaderboardList(),
      ],
    );
  }

  Widget leaderboardList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 16,
          right: 16,
          left: 16,
        ),
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return leaderboardItemView(index);
        },
      ),
    );
  }

  Widget leaderboardItemView(index) {
    bool isyou = index == 4;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: isyou ? AppColors.yellowColor : Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isyou ? "Amitstcetet ( You )" : "User Name",
                  style: TextStyle(
                    color: isyou ? Colors.white : AppColors.appColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.coins,
                      color: isyou ? Colors.white : AppColors.yellowColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "56 Points",
                      style: TextStyle(
                        color: isyou ? Colors.white : AppColors.yellowColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Text(
            "#" + (index + 1).toString(),
            style: TextStyle(
              color: isyou ? Colors.white : AppColors.myProgressCorrectcolor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
