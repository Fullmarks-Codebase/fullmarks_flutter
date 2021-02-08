import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/models/UsersResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class OtherProfileScreen extends StatefulWidget {
  String id;
  OtherProfileScreen({
    @required this.id,
  });
  @override
  _OtherProfileScreenState createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  bool _isLoading = false;
  Customer customer;

  @override
  void initState() {
    _getCustomer();
    super.initState();
  }

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
                isHome: false,
              ),
              Spacer(),
              // widget.isMyFriend ? addBuddyView() : Container(),
            ],
          ),
        ],
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  _getCustomer() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["customerId"] = widget.id;
      //api call
      UsersResponse response = UsersResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.customer, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        if (response.result.length > 0) {
          customer = response.result.first;
          _notify();
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  // Widget addBuddyView() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: Utility.bottomDecoration(),
  //     child: Utility.button(
  //       context,
  //       gradientColor1: AppColors.buttonGradient1,
  //       gradientColor2: AppColors.buttonGradient2,
  //       onPressed: () async {
  //         //delay to give ripple effect
  //         await Future.delayed(Duration(milliseconds: AppStrings.delay));
  //       },
  //       text: "Add Buddy",
  //     ),
  //   );
  // }

  Widget body() {
    return _isLoading
        ? Utility.progress(context)
        : Stack(
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
          Utility.getUsername(customer: customer),
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
              customer?.classGrades?.name ?? "",
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
          image: NetworkImage(
            AppStrings.userImage + (customer?.thumbnail ?? ""),
          ),
        ),
      ),
    );
  }
}
