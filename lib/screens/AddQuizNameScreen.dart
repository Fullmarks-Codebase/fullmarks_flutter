import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/AddQuizResponse.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/screens/StartAddQuestionScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class AddQuizNameScreen extends StatefulWidget {
  @override
  _AddQuizNameScreenState createState() => _AddQuizNameScreenState();
}

class _AddQuizNameScreenState extends State<AddQuizNameScreen> {
  TextEditingController quizNameController = TextEditingController();
  bool _isLoading = false;

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
          Column(
            children: [
              Utility.appbar(
                context,
                text: "Create Custom Quiz",
                isHome: false,
                textColor: Colors.white,
              ),
              _isLoading ? Utility.progress(context) : body(),
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Column(
        children: [
          Spacer(),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Stack(
              children: [
                SvgPicture.asset(
                  AppAssets.myQuizItemBg,
                  color: AppColors.lightAppColor,
                ),
                Column(
                  children: [
                    TextField(
                      controller: quizNameController,
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
                        hintText: "Type the Quiz name",
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
                        _addTap();
                      },
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      gradientColor1: AppColors.buttonGradient1,
                      gradientColor2: AppColors.buttonGradient2,
                      text: "Add",
                    )
                  ],
                )
              ],
            ),
          ),
          Spacer(),
          Spacer(),
        ],
      ),
    );
  }

  _addTap() {
    if (quizNameController.text.trim().length == 0) {
      Utility.showToast("Please type the quiz name");
    } else {
      _addQuiz();
    }
  }

  _addQuiz() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["name"] = quizNameController.text.trim();
      //api call
      AddQuizResponse response = AddQuizResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.addCustomQuiz, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StartAddQuestionScreen(
              customQuiz: response.result,
            ),
          ),
        );
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
