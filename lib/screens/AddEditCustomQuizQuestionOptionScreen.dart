import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:image_picker/image_picker.dart';

import 'EquationEditorScreen.dart';

class AddEditCustomQuizQuestionOptionScreen extends StatefulWidget {
  bool isEdit;
  String option;
  String optionImage;
  File optionFileImage;
  bool isAnswer;
  String questionid;
  String image_field;
  AddEditCustomQuizQuestionOptionScreen({
    @required this.isEdit,
    @required this.option,
    @required this.optionImage,
    @required this.optionFileImage,
    @required this.isAnswer,
    @required this.questionid,
    @required this.image_field,
  });
  @override
  _AddEditCustomQuizQuestionOptionScreenState createState() =>
      _AddEditCustomQuizQuestionOptionScreenState();
}

class _AddEditCustomQuizQuestionOptionScreenState
    extends State<AddEditCustomQuizQuestionOptionScreen> {
  TextEditingController optionController = TextEditingController();
  File optionImage;
  bool isAnswer = false;
  bool _isLoading = false;

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.addEditCustomQuizQuestionOptionEvent);
    optionController.text = widget.option;
    isAnswer = widget.isAnswer;
    optionImage = widget.optionFileImage;
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
                    addImageView(),
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
              String equation = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EquationEditorScreen(
                    expression: optionController.text,
                  ),
                ),
              );
              if (equation != null) {
                optionController.text = equation;
                _notify();
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: optionController,
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
                  hintText: "Type the Option...",
                ),
              ),
            ),
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
              if (optionController.text.trim().length == 0 &&
                  optionImage == null) {
                Utility.showToast(
                    context, "Please select option image or type option");
              } else {
                Navigator.pop(
                  context,
                  {
                    "option": optionController.text,
                    "optionFileImage": optionImage,
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

  deleteImage() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["id"] = widget.questionid;
      request["image_field"] = widget.image_field;
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.deleteImage, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(context, response.message);

      if (response.code == 200) {
        Navigator.of(context)..pop()..pop();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  showEditDeleteImageDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Do you want edit or delete this image?"),
          message: Text("Select from"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _onImageTap();
              },
              child: Text("Edit"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                deleteImage();
              },
              child: Text("Delete"),
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
        optionImage = File(value.path);
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
          baseUrl: AppStrings.customAnswers,
          url: widget.optionImage,
          placeholder: AppAssets.imagePlaceholder,
        ),
      ),
    );
  }

  Widget addImageView() {
    return GestureDetector(
      onTap: () {
        if (widget.isEdit) {
          showEditDeleteImageDialog();
        } else {
          _onImageTap();
        }
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
            optionImage == null
                ? widget.isEdit
                    ? widget.optionImage.length == 0
                        ? Container()
                        : questionImageView()
                    : SvgPicture.asset(AppAssets.addImage)
                : Image.file(
                    optionImage,
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
}
