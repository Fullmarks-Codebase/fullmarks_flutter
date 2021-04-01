import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/CustomQuizResponse.dart';
import 'package:fullmarks/models/QuestionsResponse.dart';
import 'package:fullmarks/screens/AddQuestionOptionEditorScreen.dart';
import 'package:fullmarks/screens/SetTimeLimitScreen.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'AddEditCustomQuizQuestionOptionScreen.dart';

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
  List<File> questionImages = [];
  List<File> answerOneImages = [];
  List<File> answerTwoImages = [];
  List<File> answerThreeImages = [];
  List<File> answerFourImages = [];
  List<String> answers = ["", "", "", ""];
  List<bool> answerStatus = [false, false, false, false];
  bool _isLoading = false;
  List<String> deletedImages = [];

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.addQuestionEvent);
    if (widget.isEdit) {
      questionSeconds = widget.questionDetails.time.toString();
      questionController.text = widget.questionDetails.question;
      answers[0] = widget.questionDetails.ansOne;
      answers[1] = widget.questionDetails.ansTwo;
      answers[2] = widget.questionDetails.ansThree;
      answers[3] = widget.questionDetails.ansFour;

      answerStatus[0] = widget.questionDetails.ansOneStatus;
      answerStatus[1] = widget.questionDetails.ansTwoStatus;
      answerStatus[2] = widget.questionDetails.ansThreeStatus;
      answerStatus[3] = widget.questionDetails.ansFourStatus;
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
        Utility.appbar(
          context,
          text: (widget.isEdit ? "Edit" : "Add") + " Question",
          isHome: false,
          textColor: Colors.white,
          isTitleCenter: false,
          sufixWidget: timerView(),
        ),
        Expanded(
          child: _isLoading
              ? Utility.progress(context)
              : ListView(
                  padding: EdgeInsets.only(top: 16),
                  children: [
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
          GestureDetector(
            onTap: () async {
              var data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddQuestionOptionEditorScreen(
                    string: questionController.text,
                    title: (widget.isEdit ? "Add " : "Edit ") + "Question",
                    isEdit: widget.isEdit,
                    isQuestion: true,
                  ),
                ),
              );
              if (data != null) {
                if (data["text"] != null) {
                  questionController.text = data["text"].toString();
                }
                if (data["images"] != null) {
                  questionImages = data["images"];
                }
                if (data["deleteImages"] != null) {
                  deletedImages.addAll(data["deleteImages"]);
                }
                _notify();
              }
            },
            child: AbsorbPointer(
              child: TextField(
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
                  hintText: "Tap to add/edit Question",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              optionView(0, AppColors.myProgressCorrectcolor, "ans_one_image"),
              SizedBox(
                width: 16,
              ),
              optionView(1, AppColors.subtopicItemBorderColor, "ans_two_image"),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              optionView(2, AppColors.strongCyan, "ans_three_image"),
              SizedBox(
                width: 16,
              ),
              optionView(3, AppColors.introColor4, "ans_four_image"),
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
                    fontSize: 14,
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

  Widget optionView(int index, Color bgColor, String image_field) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        child: FlatButton(
          onPressed: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            var data = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditCustomQuizQuestionOptionScreen(
                  isEdit: widget.isEdit,
                  isAnswer: answerStatus[index],
                  option: answers[index],
                  questionid: widget.questionDetails != null
                      ? widget.questionDetails.id.toString()
                      : "",
                ),
              ),
            );
            if (data != null) {
              answers[index] = data["option"];
              if (index == 0) {
                answerOneImages = data["images"];
              } else if (index == 1) {
                answerTwoImages = data["images"];
              } else if (index == 2) {
                answerThreeImages = data["images"];
              } else if (index == 3) {
                answerFourImages = data["images"];
              }
              if (data["isAnswer"]) {
                answerStatus[0] = false;
                answerStatus[1] = false;
                answerStatus[2] = false;
                answerStatus[3] = false;
              }
              answerStatus[index] = data["isAnswer"];
              _notify();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 32,
            ),
            child: Column(
              children: [
                answers[index] == ""
                    ? widget.isEdit
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
                        : SvgPicture.asset(AppAssets.add)
                    : Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: SvgPicture.asset(
                          AppAssets.checkBlue,
                          color: bgColor,
                        ),
                      ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  answers[index] == ""
                      ? widget.isEdit
                          ? "Edit Option"
                          : "Add Option"
                      : "Added",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  addEditTap() {
    if (!widget.isEdit && questionController.text.trim().length == 0) {
      Utility.showToast(context, "Please add question");
    } else if (!widget.isEdit && answers[0].length == 0) {
      Utility.showToast(context, "Please add option 1");
    } else if (!widget.isEdit && answers[1].length == 0) {
      Utility.showToast(context, "Please add option 2");
    } else if (!widget.isEdit && answers[2].length == 0) {
      Utility.showToast(context, "Please add option 3");
    } else if (!widget.isEdit && answers[3].length == 0) {
      Utility.showToast(context, "Please add option 4");
    } else if (!answerStatus[0] &&
        !answerStatus[1] &&
        !answerStatus[2] &&
        !answerStatus[3]) {
      Utility.showToast(context, "Please select any one right answer");
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
        if (widget.isEdit) {
          if (deletedImages.length > 0) {
            await Future.forEach(deletedImages, (String element) {
              int index = deletedImages.indexOf(element);
              request.fields["deleteImages[$index]"] = element;
            });
          }
        }
      } else {
        request.fields["customMasterId"] = widget.quizDetails.id.toString();
      }
      if (questionController.text.trim().length != 0)
        request.fields["question"] = questionController.text.trim();
      if (answers[0].length != 0) request.fields["ans_one"] = answers[0];
      if (answers[1].length != 0) request.fields["ans_two"] = answers[1];
      if (answers[2].length != 0) request.fields["ans_three"] = answers[2];
      if (answers[3].length != 0) request.fields["ans_four"] = answers[3];

      request.fields["ans_one_status"] = answerStatus[0].toString();
      request.fields["ans_two_status"] = answerStatus[1].toString();
      request.fields["ans_three_status"] = answerStatus[2].toString();
      request.fields["ans_four_status"] = answerStatus[3].toString();

      request.fields["time"] = questionSeconds;

      if (questionImages.length != 0) {
        await Future.forEach(questionImages, (File element) async {
          int index = questionImages.indexOf(element);
          request.files.add(
            await MultipartFile.fromPath(
              'question_image[$index]',
              element.path,
              contentType: MediaType('image', element.path.split(".").last),
              filename: element.path.split("/").last,
            ),
          );
        });
      }

      if (answerOneImages.length != 0) {
        await Future.forEach(answerOneImages, (File element) async {
          int index = answerOneImages.indexOf(element);
          request.files.add(
            await MultipartFile.fromPath(
              'ans_one_image[$index]',
              element.path,
              contentType: MediaType('image', element.path.split(".").last),
              filename: element.path.split("/").last,
            ),
          );
        });
      }

      if (answerTwoImages.length != 0) {
        await Future.forEach(answerTwoImages, (File element) async {
          int index = answerTwoImages.indexOf(element);
          request.files.add(
            await MultipartFile.fromPath(
              'ans_two_image[$index]',
              element.path,
              contentType: MediaType('image', element.path.split(".").last),
              filename: element.path.split("/").last,
            ),
          );
        });
      }

      if (answerThreeImages.length != 0) {
        await Future.forEach(answerThreeImages, (File element) async {
          int index = answerThreeImages.indexOf(element);
          request.files.add(
            await MultipartFile.fromPath(
              'ans_three_image[$index]',
              element.path,
              contentType: MediaType('image', element.path.split(".").last),
              filename: element.path.split("/").last,
            ),
          );
        });
      }

      if (answerFourImages.length != 0) {
        await Future.forEach(answerFourImages, (File element) async {
          int index = answerFourImages.indexOf(element);
          request.files.add(
            await MultipartFile.fromPath(
              'ans_four_image[$index]',
              element.path,
              contentType: MediaType('image', element.path.split(".").last),
              filename: element.path.split("/").last,
            ),
          );
        });
      }

      // if (question_image != null) {
      //   request.files.add(
      //     await MultipartFile.fromPath(
      //       'question_image',
      //       question_image.path,
      //       contentType:
      //           MediaType('image', question_image.path.split(".").last),
      //     ),
      //   );
      // }
      // if (answerFileImages[0] != null) {
      //   request.files.add(
      //     await MultipartFile.fromPath(
      //       'ans_one_image',
      //       answerFileImages[0].path,
      //       contentType:
      //           MediaType('image', answerFileImages[0].path.split(".").last),
      //     ),
      //   );
      // }
      // if (answerFileImages[1] != null) {
      //   request.files.add(
      //     await MultipartFile.fromPath(
      //       'ans_two_image',
      //       answerFileImages[1].path,
      //       contentType:
      //           MediaType('image', answerFileImages[1].path.split(".").last),
      //     ),
      //   );
      // }
      // if (answerFileImages[2] != null) {
      //   request.files.add(
      //     await MultipartFile.fromPath(
      //       'ans_three_image',
      //       answerFileImages[2].path,
      //       contentType:
      //           MediaType('image', answerFileImages[2].path.split(".").last),
      //     ),
      //   );
      // }
      // if (answerFileImages[3] != null) {
      //   request.files.add(
      //     await MultipartFile.fromPath(
      //       'ans_four_image',
      //       answerFileImages[3].path,
      //       contentType:
      //           MediaType('image', answerFileImages[3].path.split(".").last),
      //     ),
      //   );
      // }

      //api call
      Response response = await Response.fromStream(await request.send());
      //hide progress
      _isLoading = false;
      _notify();
      print(response.body);
      if (response.statusCode == 200) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(context, commonResponse.message);
        Navigator.pop(context);
      } else {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(context, commonResponse.message);
      }
    } else {
      Utility.showToast(context, AppStrings.noInternet);
    }
  }
}
