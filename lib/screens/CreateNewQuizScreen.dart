import 'package:flutter/material.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/Utiity.dart';

class CreateNewQuizScreen extends StatefulWidget {
  @override
  _CreateNewQuizScreenState createState() => _CreateNewQuizScreenState();
}

class _CreateNewQuizScreenState extends State<CreateNewQuizScreen> {
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
          text: "Create New Quiz",
          onBackPressed: () {
            Navigator.pop(context);
          },
          isHome: false,
        ),
      ],
    );
  }
}
