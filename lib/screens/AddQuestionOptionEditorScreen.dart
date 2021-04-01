import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fullmarks/notus/src/document.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';
import 'package:fullmarks/zefyr/src/widgets/controller.dart';
import 'package:fullmarks/zefyr/src/widgets/field.dart';
import 'package:fullmarks/zefyr/src/widgets/scaffold.dart';
import 'package:quill_delta/quill_delta.dart';

class AddQuestionOptionEditorScreen extends StatefulWidget {
  String title;
  String string;
  bool isEdit;
  bool isQuestion;
  AddQuestionOptionEditorScreen({
    @required this.string,
    @required this.title,
    @required this.isEdit,
    @required this.isQuestion,
  });
  @override
  _AddQuestionOptionEditorScreenState createState() =>
      _AddQuestionOptionEditorScreenState();
}

class _AddQuestionOptionEditorScreenState
    extends State<AddQuestionOptionEditorScreen> {
  FocusNode fn = FocusNode();
  ZefyrController _controller = ZefyrController(NotusDocument());
  List<File> images = List();
  List<String> deleteImages = List();
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.string.isNotEmpty) {
      _controller = ZefyrController(NotusDocument.fromDelta(
        Delta.fromJson(json.decode(widget.string) as List),
      ));
    }

    _controller.document.changes.listen((event) async {
      // print("LISTEN");
      // print("BEFORE");
      // print(event.before.toJson());
      // print(event.before.length);
      // print("CHANGE");
      // print(event.change.toJson());
      // print(event.change.length);
      await Future.forEach(event.change.toList(),
          (Operation elementChange) async {
        if (elementChange.isInsert) {
          // print("isInsert");
          // print(elementChange.attributes);
          // if image is added then add in list
          if (elementChange.attributes != null) {
            try {
              if (elementChange.attributes["embed"]["type"] == "image") {
                images.add(File(elementChange.attributes["embed"]["source"]));
                // print("INSERT IMAGE ADD");
                // print(images.length);
              }
            } catch (e) {
              print("error - INSERT IMAGE ADD");
            }
          }
        } else if (elementChange.isDelete) {
          await Future.forEach(event.before.toList(),
              (Operation elementDelete) async {
            // print("isDelete");
            // print(elementDelete.attributes);
            //if image is deleted
            if (elementDelete.attributes != null) {
              try {
                if (elementDelete.attributes["embed"]["type"] == "image") {
                  try {
                    //remove from list
                    await Future.forEach(images, (File img) {
                      int index = images.indexOf(img);
                      images.removeAt(index);
                      // print("DELETE IMAGE REMOVE");
                      // print(images.length);
                    });
                  } catch (e) {
                    print("error - DELETE IMAGE REMOVE");
                  }
                  if (widget.isEdit) {
                    //add deleted in deleteImages list
                    deleteImages
                        .add(elementDelete.attributes["embed"]["source"]);
                    // print("delete");
                    // print(deleteImages.length);
                  }
                }
              } catch (e) {
                print("error - DELETE");
              }
            }
          });
        }
      });
    });

    super.initState();
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
    return ZefyrScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utility.appbar(
            context,
            text: (widget.isEdit ? "Edit" : "Add") +
                (widget.isQuestion ? " Question" : " Option"),
            homeassetName: AppAssets.checkBlue,
            onHomePressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              if (_controller.plainTextEditingValue.text.trim().length == 0) {
                Utility.showToast(
                    context,
                    "Please type your " +
                        (widget.isQuestion ? "question" : "option"));
              } else {
                Navigator.pop(
                  context,
                  {
                    "text": jsonEncode(_controller.document),
                    "images": images,
                    "deleteImages": deleteImages,
                  },
                );
              }
            },
          ),
          _isLoading
              ? Container()
              : Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Type your " + (widget.isQuestion ? "question" : "option"),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          _isLoading
              ? Container()
              : Expanded(
                  child: Container(
                    color: AppColors.greyColor9,
                    padding: EdgeInsets.all(16),
                    child: ZefyrField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: _controller,
                      focusNode: fn,
                      autofocus: false,
                      imageDelegate: CustomImageDelegate(widget.isQuestion
                          ? AppStrings.customQuestion
                          : AppStrings.customAnswers),
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                ),
          _isLoading ? Expanded(child: Utility.progress(context)) : Container()
        ],
      ),
    );
  }
}
