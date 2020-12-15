import 'package:flutter/material.dart';
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
    return Container(
      padding: EdgeInsets.all(8),
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
      ),
      child: Text(
        "Set " + index.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
