import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/LeaderBoardResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _isLoading = false;
  List<Customer> customers = List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.leaderboardEvent);
    _getLeaderboard();
    super.initState();
  }

  _getLeaderboard() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["mode"] = "public";
      //api call
      LeaderBoardResponse response = LeaderBoardResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.leaderboard, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        customers.clear();
        await Future.forEach(response.result, (Customer element) {
          if (element.reportMaster.length != 0) {
            customers.add(element);
          }
        });
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Future<Null> _handleRefresh() async {
    _getLeaderboard();
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    return null;
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

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
      child: _isLoading
          ? Utility.progress(context)
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: customers.length == 0
                  ? ListView(
                      padding: EdgeInsets.all(16),
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              ((AppBar().preferredSize.height * 2) + 100),
                          child: Utility.emptyView(
                            "No Leaderboard",
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 16,
                        right: 16,
                        left: 16,
                      ),
                      itemCount: customers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return leaderboardItemView(index);
                      },
                    ),
            ),
    );
  }

  Widget leaderboardItemView(index) {
    bool isyou = customers[index].id == Utility.getCustomer().id;
    String points = customers[index].reportMaster.length != 0
        ? customers[index].reportMaster.first.points
        : "";
    String rank = customers[index].reportMaster.length != 0
        ? customers[index].reportMaster.first.rank.toString()
        : "";

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
                  customers[index].username + (isyou ? " (You)" : ""),
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
                      points + " Points",
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
            "#" + rank,
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
