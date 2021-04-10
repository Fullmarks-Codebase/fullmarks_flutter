import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/notus/src/document.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomAttrDelegate.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';
import 'package:fullmarks/zefyr/src/widgets/view.dart';
import 'package:quill_delta/quill_delta.dart';

import 'AddQuestionOptionEditorScreen.dart';

class AddEditCustomQuizQuestionOptionScreen extends StatefulWidget {
  bool isEdit;
  String option;
  bool isAnswer;
  String questionid;
  AddEditCustomQuizQuestionOptionScreen({
    @required this.isEdit,
    @required this.option,
    @required this.isAnswer,
    @required this.questionid,
  });
  @override
  _AddEditCustomQuizQuestionOptionScreenState createState() =>
      _AddEditCustomQuizQuestionOptionScreenState();
}

class _AddEditCustomQuizQuestionOptionScreenState
    extends State<AddEditCustomQuizQuestionOptionScreen> {
  TextEditingController optionController = TextEditingController();
  bool isAnswer = false;
  bool _isLoading = false;
  List<String> deletedImages = [];
  List<File> answerImages = [];

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.addEditCustomQuizQuestionOptionEvent);
    optionController.text = widget.option;
    isAnswer = widget.isAnswer;
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
          text: (widget.isEdit ? "Edit" : "Add") + " Option",
          isHome: false,
          textColor: Colors.white,
        ),
        Expanded(
          child: _isLoading
              ? Utility.progress(context)
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    addOptionView(),
                  ],
                ),
        )
      ],
    );
  }

  Widget addOptionView() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              var data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddQuestionOptionEditorScreen(
                    string: optionController.text,
                    title: (widget.isEdit ? "Add " : "Edit ") + "Question",
                    isEdit: widget.isEdit,
                    isQuestion: false,
                  ),
                ),
              );
              if (data != null) {
                if (data["text"] != null) {
                  optionController.text = data["text"].toString();
                }
                if (data["images"] != null) {
                  answerImages = data["images"];
                }
                if (data["deleteImages"] != null) {
                  deletedImages.addAll(data["deleteImages"]);
                }

                _notify();
              }
              // String equation = await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => AddQuestionOptionEditorScreen(
              //       string: optionController.text,
              //       title: (widget.isEdit ? "Add " : "Edit ") + "Option",
              //       isEdit: widget.isEdit,
              //       isQuestion: false,
              //     ),
              //   ),
              // );
              // if (equation != null) {
              //   optionController.text = equation;
              //   _notify();
              // }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: optionController.text.isEmpty ? 16 : 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.appColor,
                  width: 2,
                ),
              ),
              alignment: Alignment.centerLeft,
              child: optionController.text.isEmpty
                  ? Text(
                      "Tap to add/edit Option",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  : ZefyrView(
                      document: NotusDocument.fromDelta(
                        Delta.fromJson(
                            json.decode(optionController.text) as List),
                      ),
                      imageDelegate:
                          CustomImageDelegate(AppStrings.customAnswers),
                      attrDelegate: CustomAttrDelegate(),
                    ),
            ),
            // child: AbsorbPointer(
            //   child: TextField(
            //     controller: optionController,
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: BorderSide(
            //           color: AppColors.appColor,
            //           width: 2,
            //         ),
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: BorderSide(
            //           color: AppColors.appColor,
            //           width: 2,
            //         ),
            //       ),
            //       filled: true,
            //       fillColor: Colors.white,
            //       hintText: "Type the Option...",
            //     ),
            //   ),
            // ),
          ),
          SizedBox(
            height: 16,
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text("Correct Answer?"),
            value: isAnswer,
            onChanged: (value) {
              isAnswer = value;
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
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              if (optionController.text.trim().length == 0) {
                Utility.showToast(context, "Please add option");
              } else {
                Navigator.pop(
                  context,
                  {
                    "option": optionController.text,
                    "images": answerImages,
                    "deleteImages": deletedImages,
                    "isAnswer": isAnswer,
                  },
                );
              }
            },
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            gradientColor1: AppColors.buttonGradient1,
            gradientColor2: AppColors.buttonGradient2,
            text: widget.isEdit ? "Save" : "Add",
          )
        ],
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
