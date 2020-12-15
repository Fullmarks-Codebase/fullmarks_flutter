import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/utility/appAssets.dart';
import 'package:fullmarks/utility/appColors.dart';
import 'package:fullmarks/utility/utiity.dart';

class SetsScreen extends StatefulWidget {
  String subtopicName;
  SetsScreen({
    @required this.subtopicName,
  });
  @override
  _SetsScreenState createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  List<int> selectedIndex = [1, 2];

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
          text: widget.subtopicName,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: List.generate(10, (index) {
              return setsItemView(index + 1);
            }),
          ),
        ),
      ],
    );
  }

  Widget setsItemView(int index) {
    return GestureDetector(
      onTap: () {
        if (mounted)
          setState(() {
            if (selectedIndex.contains(index)) {
              selectedIndex.remove(index);
            } else {
              selectedIndex.add(index);
            }
          });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.setsItemGradientColor1,
              AppColors.setsItemGradientColor2
            ],
            stops: [0.25, 0.75],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Set " + index.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(selectedIndex.contains(index)
                  ? AppAssets.check
                  : AppAssets.uncheck),
              onPressed: null,
            )
          ],
        ),
      ),
    );
  }
}
