import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/SetTimeLimitScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class AddQuestionScreen extends StatefulWidget {
  bool isEdit;
  AddQuestionScreen({
    @required this.isEdit,
  });
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  TextEditingController questionController = TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      questionController.text =
          "Which one of the following has maximum number of atoms?";
    }
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
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Utility.appbar(
              context,
              text: (widget.isEdit ? "Edit" : "Add") + " Question",
              isHome: false,
              textColor: Colors.white,
            ),
            widget.isEdit ? Container() : timerView(),
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              addImageView(),
              addQuestionView(),
            ],
          ),
        )
      ],
    );
  }

  Widget addQuestionView() {
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
          TextField(
            controller: questionController,
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
              hintText: "Type the Question...",
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              optionView(AppColors.myProgressCorrectcolor),
              SizedBox(
                width: 16,
              ),
              optionView(AppColors.subtopicItemBorderColor),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              optionView(AppColors.strongCyan),
              SizedBox(
                width: 16,
              ),
              optionView(AppColors.introColor4),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Utility.button(
            context,
            onPressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              Navigator.pop(context);
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

  Widget addImageView() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greyColor12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.isEdit
              ? Image.asset(
                  AppAssets.dummyQuestionImage,
                  fit: BoxFit.fitHeight,
                  height: 180,
                )
              : SvgPicture.asset(AppAssets.addImage),
          widget.isEdit
              ? Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    color: Colors.black12,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.pencil,
                    color: Colors.white,
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget timerView() {
    return SafeArea(
      bottom: false,
      child: GestureDetector(
        onTap: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetTimeLimitScreen(),
            ),
          );
        },
        child: Container(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(
              bottom: 16,
              right: 16,
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
                  "30 Sec",
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontSize: 16,
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

  Widget optionView(Color bgColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            widget.isEdit
                ? Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: SvgPicture.asset(
                      AppAssets.pencil,
                      color: bgColor,
                    ),
                  )
                : SvgPicture.asset(AppAssets.add),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.isEdit ? "Option 123" : "Add Option",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
