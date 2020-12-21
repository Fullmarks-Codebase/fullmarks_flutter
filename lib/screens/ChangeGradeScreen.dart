import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class ChangeGradeScreen extends StatefulWidget {
  @override
  _ChangeGradeScreenState createState() => _ChangeGradeScreenState();
}

class _ChangeGradeScreenState extends State<ChangeGradeScreen> {
  int selected = 0;
  List<String> gradesList = [
    AppAssets.class4,
    AppAssets.class5,
    AppAssets.class6,
    AppAssets.class7,
    AppAssets.class8,
    AppAssets.class9,
    AppAssets.class10,
    AppAssets.class11science,
    AppAssets.class11commerce,
    AppAssets.class12science,
    AppAssets.class12commerce,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.commonBg),
          Expanded(
            child: Column(
              children: [
                Spacer(),
                SvgPicture.asset(
                  AppAssets.bottomBarbg,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
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
          text: "Choose Grade",
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        gradeList(),
      ],
    );
  }

  Widget gradeList() {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        itemCount: gradesList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (BuildContext context, int index) {
          return gradeItemView(index);
        },
      ),
    );
  }

  Widget gradeItemView(int index) {
    return GestureDetector(
      onTap: () {
        if (mounted)
          setState(() {
            selected = index;
          });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected == index ? AppColors.strongCyan : AppColors.appColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2.5,
              child: SvgPicture.asset(
                AppAssets.grageItemBg,
                width: MediaQuery.of(context).size.width / 2.5,
                fit: BoxFit.fill,
                color: Color(0x1affffff),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2.5,
              child: SvgPicture.asset(
                gradesList[index],
                width: MediaQuery.of(context).size.width / 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
