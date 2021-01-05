import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/SubtopicResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/InstructionsScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

import 'AskingForProgressScreen.dart';

class SetsScreen extends StatefulWidget {
  SubtopicDetails subtopic;
  SubjectDetails subject;
  SetsScreen({
    @required this.subtopic,
    @required this.subject,
  });
  @override
  _SetsScreenState createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  Customer customer;

  @override
  void initState() {
    customer = Utility.getCustomer();
    _notify();
    super.initState();
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
          text: widget.subtopic.name,
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
      margin: EdgeInsets.only(bottom: 8),
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
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => customer == null
                  ? AskingForProgressScreen()
                  : InstructionsScreen(
                      subtopicName: widget.subtopic.name,
                      subjectName: widget.subject.name,
                      setName: "Set " + index.toString(),
                    ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
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
                icon: SvgPicture.asset(index == 1 || index == 2
                    ? AppAssets.check
                    : AppAssets.uncheck),
                onPressed: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
