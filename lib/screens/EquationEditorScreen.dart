import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/EquationFeaturesScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class EquationEditorScreen extends StatefulWidget {
  String expression;
  EquationEditorScreen({
    @required this.expression,
  });
  @override
  _EquationEditorScreenState createState() => _EquationEditorScreenState();
}

class _EquationEditorScreenState extends State<EquationEditorScreen> {
  TextEditingController editorController;

  @override
  void initState() {
    editorController = TextEditingController(
      text: widget.expression,
    );
    super.initState();
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
              ),
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
          text: "Equation Editor",
          textColor: Colors.white,
        ),
        mainContent(),
      ],
    );
  }

  Widget mainContent() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Editor",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Utility.button(
                    context,
                    onPressed: () async {
                      //delay to give ripple effect
                      await Future.delayed(
                          Duration(milliseconds: AppStrings.delay));
                      widget.expression += " \\ ";
                      editorController.text += " \\ ";
                      _notify();
                      Timer(Duration(milliseconds: 300), () {
                        editorController.selection = TextSelection(
                          baseOffset: editorController.text.length,
                          extentOffset: editorController.text.length,
                        );
                      });
                    },
                    text: "Tap to add space",
                    bgColor: AppColors.strongCyan,
                    width: 200,
                    height: 40,
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              TextField(
                controller: editorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.appColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.appColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Type something or add equation ...",
                ),
                maxLines: 5,
                onChanged: (value) {
                  widget.expression = value;
                  _notify();
                },
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  String equation = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EquationFeaturesScreen(),
                    ),
                  );
                  if (equation != null) {
                    widget.expression += equation;
                    editorController.text = widget.expression;
                    _notify();
                  }
                },
                text: "Tap to add equation features",
                bgColor: AppColors.strongCyan,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Preview",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.appColor,
                    width: 2,
                  ),
                ),
                child: widget.expression.isEmpty
                    ? Container()
                    : Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Math.tex(
                            widget.expression,
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 16,
              ),
              Utility.button(
                context,
                onPressed: () async {
                  //delay to give ripple effect
                  await Future.delayed(
                      Duration(milliseconds: AppStrings.delay));
                  Navigator.pop(context, editorController.text);
                },
                text: "Done",
                bgColor: AppColors.strongCyan,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
