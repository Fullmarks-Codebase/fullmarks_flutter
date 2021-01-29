import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/CustomQuizResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/screens/SetTimeLimitScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class AddQuestionScreen extends StatefulWidget {
  CustomQuizDetails quizDetails;
  QuestionDetails questionDetails;
  bool isEdit;
  AddQuestionScreen({
    @required this.quizDetails,
    @required this.questionDetails,
    @required this.isEdit,
  });
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  TextEditingController questionController = TextEditingController();
  String questionSeconds = "30";
  File question_image;
  String ans_one = "for testing";
  String ans_two = "for testing";
  String ans_three = "for testing";
  String ans_four = "for testing";
  bool ans_one_status = true;
  bool ans_two_status = false;
  bool ans_three_status = false;
  bool ans_four_status = false;
  File ans_one_image;
  File ans_two_image;
  File ans_three_image;
  File ans_four_image;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      questionSeconds = widget.questionDetails.time.toString();
      questionController.text = widget.questionDetails.question;
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
          child: _isLoading
              ? Utility.progress(context)
              : ListView(
                  padding: EdgeInsets.only(top: 16),
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
              addEditTap();
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

  _onImageTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Select Profile Picture"),
          message: Text("Select from"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
              child: Text("Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        );
      },
    );
  }

  _getImage(ImageSource source) async {
    ImagePicker().getImage(source: source).then((value) {
      if (value != null) {
        question_image = File(value.path);
        _notify();
      } else {
        print('No image selected.');
      }
      _notify();
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget questionImageView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      height: 200,
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

  Widget addImageView() {
    return GestureDetector(
      onTap: () {
        _onImageTap();
      },
      child: Container(
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
            question_image == null
                ? widget.isEdit
                    ? widget.questionDetails.questionImage.length == 0
                        ? Container()
                        : questionImageView()
                    : SvgPicture.asset(AppAssets.addImage)
                : Image.file(
                    question_image,
                  ),
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
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget timerView() {
    return SafeArea(
      bottom: false,
      child: GestureDetector(
        onTap: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          String sec = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetTimeLimitScreen(
                questionSeconds: questionSeconds,
              ),
            ),
          );
          if (sec != null) {
            questionSeconds = sec;
            _notify();
          }
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
                  questionSeconds + " Sec",
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
              widget.isEdit ? "Edit Option" : "Add Option",
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

  addEditTap() {
    if (question_image == null && questionController.text.trim().length == 0) {
      Utility.showToast("Please select question image or type question");
    } else if (ans_one_image == null && ans_one.length == 0) {
      Utility.showToast("Please select option 1 image or type option 1");
    } else if (ans_two_image == null && ans_two.length == 0) {
      Utility.showToast("Please select option 2 image or type option 2");
    } else if (ans_three_image == null && ans_three.length == 0) {
      Utility.showToast("Please select option 3 image or type option 3");
    } else if (ans_four_image == null && ans_four.length == 0) {
      Utility.showToast("Please select option 4 image or type option 4");
    } else if (!ans_one_status &&
        !ans_two_status &&
        !ans_three_status &&
        !ans_four_status) {
      Utility.showToast("Please select any one right answer");
    } else {
      _addEditQuestion();
    }
  }

  _addEditQuestion() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //headers
      var headers = Map<String, String>();
      headers["Accept"] = "application/json";
      if (Utility.getCustomer() != null) {
        headers["Authorization"] = Utility.getCustomer().token;
      }

      //api request
      var uri = Uri.parse(widget.isEdit
          ? AppStrings.updateCustomQuestions
          : AppStrings.addCustomQuestions);
      var request = MultipartRequest(widget.isEdit ? 'PUT' : 'POST', uri);
      request.headers.addAll(headers);
      if (widget.isEdit) {
        request.fields["id"] = widget.questionDetails.id.toString();
      } else {
        request.fields["customMasterId"] = widget.quizDetails.id.toString();
      }
      if (questionController.text.trim().length != 0)
        request.fields["question"] = questionController.text.trim();
      if (ans_one.length != 0) request.fields["ans_one"] = ans_one;
      if (ans_two.length != 0) request.fields["ans_two"] = ans_two;
      if (ans_three.length != 0) request.fields["ans_three"] = ans_three;
      if (ans_four.length != 0) request.fields["ans_four"] = ans_four;

      request.fields["ans_one_status"] = ans_one_status.toString();
      request.fields["ans_two_status"] = ans_two_status.toString();
      request.fields["ans_three_status"] = ans_three_status.toString();
      request.fields["ans_four_status"] = ans_four_status.toString();

      request.fields["time"] = questionSeconds;

      if (question_image != null) {
        request.files.add(
          await MultipartFile.fromPath(
            'question_image',
            question_image.path,
            contentType:
                MediaType('image', question_image.path.split(".").last),
          ),
        );
      }
      if (ans_one_image != null) {
        request.files.add(
          await MultipartFile.fromPath(
            'ans_one_image',
            ans_one_image.path,
            contentType: MediaType('image', ans_one_image.path.split(".").last),
          ),
        );
      }
      if (ans_two_image != null) {
        request.files.add(
          await MultipartFile.fromPath(
            'ans_two_image',
            ans_two_image.path,
            contentType: MediaType('image', ans_two_image.path.split(".").last),
          ),
        );
      }
      if (ans_three_image != null) {
        request.files.add(
          await MultipartFile.fromPath(
            'ans_three_image',
            ans_three_image.path,
            contentType:
                MediaType('image', ans_three_image.path.split(".").last),
          ),
        );
      }
      if (ans_four_image != null) {
        request.files.add(
          await MultipartFile.fromPath(
            'ans_four_image',
            ans_four_image.path,
            contentType:
                MediaType('image', ans_four_image.path.split(".").last),
          ),
        );
      }

      //api call
      Response response = await Response.fromStream(await request.send());
      //hide progress
      _isLoading = false;
      _notify();
      print(response.body);
      if (response.statusCode == 200) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(commonResponse.message);
        Navigator.pop(context);
      } else {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(commonResponse.message);
      }
    } else {
      Utility.showToast(AppStrings.noInternet);
    }
  }
}
