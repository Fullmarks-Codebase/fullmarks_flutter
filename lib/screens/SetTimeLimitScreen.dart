import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class SetTimeLimitScreen extends StatefulWidget {
  @override
  _SetTimeLimitScreenState createState() => _SetTimeLimitScreenState();
}

class _SetTimeLimitScreenState extends State<SetTimeLimitScreen> {
  int selectedIndex = 0;

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
          text: "Set Time Limit",
          isHome: false,
          textColor: Colors.white,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("5", 0),
              SizedBox(
                width: 16,
              ),
              timeItemView("30", 1),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("10", 2),
              SizedBox(
                width: 16,
              ),
              timeItemView("60", 3),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("15", 4),
              SizedBox(
                width: 16,
              ),
              timeItemView("90", 5),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              timeItemView("20", 6),
              SizedBox(
                width: 16,
              ),
              timeItemView("120", 7),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Utility.button(
            context,
            onPressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              Navigator.pop(context);
            },
            text: "Done",
            bgColor: AppColors.myProgressCorrectcolor,
          ),
        ),
      ],
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget timeItemView(String time, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedIndex = index;
          _notify();
        },
        child: Container(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? AppColors.myProgressIncorrectcolor
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.whiteClock,
                  color: AppColors.appColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  time + " Sec",
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
