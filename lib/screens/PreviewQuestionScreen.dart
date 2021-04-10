import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/notus/src/document.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomAttrDelegate.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';
import 'package:fullmarks/zefyr/src/widgets/view.dart';
import 'package:quill_delta/quill_delta.dart';

class PreviewQuestionScreen extends StatefulWidget {
  QuestionDetails questionDetails;
  PreviewQuestionScreen({
    @required this.questionDetails,
  });
  @override
  _PreviewQuestionScreenState createState() => _PreviewQuestionScreenState();
}

class _PreviewQuestionScreenState extends State<PreviewQuestionScreen> {
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
          text: "Preview",
          isHome: false,
          textColor: Colors.white,
        ),
        timerView(),
        questionAnswerItemView(),
      ],
    );
  }

  Widget questionAnswerItemView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            right: 16,
            left: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.questionDetails.question.length == 0
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(
                        right: 16,
                        left: 16,
                        top: 16,
                      ),
                      child: ZefyrView(
                        document: NotusDocument.fromDelta(
                          Delta.fromJson(json
                              .decode(widget.questionDetails.question) as List),
                        ),
                        imageDelegate:
                            CustomImageDelegate(AppStrings.customQuestion),
                        attrDelegate: CustomAttrDelegate(),
                        textStyle: TextStyle(
                          color: AppColors.appColor,
                          fontSize: 18,
                        ),
                      )
                      // child: Scrollbar(
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: Math.tex(
                      //       widget.questionDetails.question,
                      // textStyle: TextStyle(
                      //   color: AppColors.appColor,
                      //   fontSize: 18,
                      //   fontWeight: FontWeight.bold,
                      // ),
                      //     ),
                      //   ),
                      // ),
                      ),
              widget.questionDetails.question.length == 0
                  ? SizedBox(
                      height: 16,
                    )
                  : Container(
                      padding: EdgeInsets.all(8),
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
              widget.questionDetails.questionImage.length == 0
                  ? Container()
                  : questionImageView(),
              SizedBox(
                height: 16,
              ),
              answersView()
            ],
          ),
        ),
      ),
    );
  }

  Widget answersView() {
    return Column(
      children: List.generate(4, (index) {
        return textAnswerItemView(index);
      }),
    );
  }

  Widget textAnswerItemView(int index) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      alignment: Alignment.center,
      decoration:
          Utility.getQuestionCorrectAnswer(widget.questionDetails) == index
              ? Utility.resultAnswerDecoration(AppColors.strongCyan)
              : Utility.defaultAnswerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                index == 0
                    ? "(A) "
                    : index == 1
                        ? "(B) "
                        : index == 2
                            ? "(C) "
                            : "(D) ",
                style: TextStyle(
                  color: Utility.getQuestionCorrectAnswer(
                              widget.questionDetails) ==
                          index
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Expanded(
                child: ZefyrView(
                  document: NotusDocument.fromDelta(
                    Delta.fromJson(json.decode(index == 0
                        ? widget.questionDetails.ansOne
                        : index == 1
                            ? widget.questionDetails.ansTwo
                            : index == 2
                                ? widget.questionDetails.ansThree
                                : widget.questionDetails.ansFour) as List),
                  ),
                  imageDelegate: CustomImageDelegate(AppStrings.customAnswers),
                  attrDelegate: CustomAttrDelegate(),
                  textStyle: TextStyle(
                    color: Utility.getQuestionCorrectAnswer(
                                widget.questionDetails) ==
                            index
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          // Scrollbar(
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Math.tex(
          //       index == 0
          //           ? "(A) \\ " + widget.questionDetails.ansOne
          //           : index == 1
          //               ? "(B) \\ " + widget.questionDetails.ansTwo
          //               : index == 2
          //                   ? "(C) \\ " + widget.questionDetails.ansThree
          //                   : "(D) \\ " + widget.questionDetails.ansFour,
          // textStyle: TextStyle(
          //   color: Utility.getQuestionCorrectAnswer(
          //               widget.questionDetails) ==
          //           index
          //       ? Colors.white
          //       : Colors.black,
          //   fontWeight: FontWeight.bold,
          //   fontSize: 18,
          // ),
          //     ),
          //   ),
          // ),
          (index == 0
                  ? widget.questionDetails.ansOneImage == ""
                  : index == 1
                      ? widget.questionDetails.ansTwoImage == ""
                      : index == 2
                          ? widget.questionDetails.ansThreeImage == ""
                          : widget.questionDetails.ansFourImage == "")
              ? Container()
              : SizedBox(
                  height: 8,
                ),
          (index == 0
                  ? widget.questionDetails.ansOneImage == ""
                  : index == 1
                      ? widget.questionDetails.ansTwoImage == ""
                      : index == 2
                          ? widget.questionDetails.ansThreeImage == ""
                          : widget.questionDetails.ansFourImage == "")
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Utility.imageLoader(
                      baseUrl: AppStrings.customAnswers,
                      url: index == 0
                          ? widget.questionDetails.ansOneImage
                          : index == 1
                              ? widget.questionDetails.ansTwoImage
                              : index == 2
                                  ? widget.questionDetails.ansThreeImage
                                  : widget.questionDetails.ansFourImage,
                      placeholder: AppAssets.imagePlaceholder,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget questionImageView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      height: 200,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Utility.imageLoader(
          baseUrl: AppStrings.customQuestion,
          url: widget.questionDetails.questionImage,
          placeholder: AppAssets.imagePlaceholder,
        ),
      ),
    );
  }

  Widget timerView() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.myProgressIncorrectcolor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.whiteClock,
              color: AppColors.appColor,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              widget.questionDetails.time.toString(),
              style: TextStyle(
                color: AppColors.appColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
