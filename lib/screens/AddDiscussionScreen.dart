import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';
import 'package:fullmarks/notus/notus.dart';
import 'package:fullmarks/zefyr/zefyr.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quill_delta/quill_delta.dart';

class AddDiscussionScreen extends StatefulWidget {
  bool isEdit;
  DiscussionDetails discussion;
  AddDiscussionScreen({
    @required this.isEdit,
    @required this.discussion,
  });
  @override
  _AddDiscussionScreenState createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  int selectedCategory = -1;
  FocusNode fn = FocusNode();
  List<SubjectDetails> subjects = List();
  bool _isLoading = false;
  Customer customer = Utility.getCustomer();
  ZefyrController _controller = ZefyrController(NotusDocument());
  List<File> images = List();
  List<String> deleteImages = List();

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.addDiscussionEvent);
    _getSubjects();

    if (widget.isEdit) {
      _controller = ZefyrController(NotusDocument.fromDelta(
        Delta.fromJson(json.decode(widget.discussion.question) as List),
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

  _getSubjects() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["userId"] = customer.id.toString();
      request["id"] = customer.classGrades.id.toString();
      request["calledFrom"] = "app";
      //api call
      SubjectsResponse response = SubjectsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.subjects, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        subjects = response.result;
        _notify();
        if (widget.isEdit) {
          try {
            SubjectDetails temp = subjects.firstWhere((element) {
              return element.id == widget.discussion.subjectId;
            });
            print(temp.id);
            print(widget.discussion.subjectId);
            selectedCategory = subjects.indexOf(temp);
            _notify();
          } catch (e) {}
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
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
            text: (widget.isEdit ? "Edit" : "Add") + " Question",
            homeassetName: AppAssets.checkBlue,
            onHomePressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              // print(images.length);
              // print(deleteImages.length);
              addQuestionTap();
            },
          ),
          _isLoading
              ? Container()
              : Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    "Select Category",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
          _isLoading ? Container() : categoryView(),
          _isLoading
              ? Container()
              : Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Type your question",
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
                      imageDelegate: CustomImageDelegate(AppStrings.postImage),
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                ),
          _isLoading ? Expanded(child: Utility.progress(context)) : Container()
        ],
      ),
    );
  }

  addQuestionTap() {
    if (selectedCategory == -1) {
      Utility.showToast("Please select category");
    } else if (_controller.plainTextEditingValue.text.trim().length == 0) {
      Utility.showToast("Please type your question");
    } else {
      addQuestion();
    }
  }

  addQuestion() async {
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
      var uri = Uri.parse(
          widget.isEdit ? AppStrings.updatePosts : AppStrings.addPosts);
      var request = MultipartRequest(widget.isEdit ? 'PUT' : 'POST', uri);
      request.headers.addAll(headers);
      if (widget.isEdit) {
        request.fields["postId"] = widget.discussion.id.toString();
        if (deleteImages.length > 0) {
          await Future.forEach(deleteImages, (String element) {
            int index = deleteImages.indexOf(element);
            request.fields["deleteImages[$index]"] = element;
          });
        }
      }
      request.fields["subjectId"] = subjects[selectedCategory].id.toString();
      request.fields["question"] = jsonEncode(_controller.document);

      if (images.length != 0) {
        await Future.forEach(images, (File element) async {
          int index = images.indexOf(element);
          request.files.add(
            await MultipartFile.fromPath(
              'images[$index]',
              element.path,
              contentType: MediaType('image', element.path.split(".").last),
              filename: element.path.split("/").last,
            ),
          );
        });
      }

      print(request.fields);
      print(request.files);

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
        Navigator.pop(context, true);
      } else {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(commonResponse.message);
      }
    } else {
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget categoryView() {
    return subjects.length == 0
        ? Utility.emptyView("No Categories")
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Row(
                children: subjects.map((e) {
                  int index = subjects.indexOf(e);
                  return Utility.categoryItemView(
                    title: subjects[index].name,
                    selectedCategory: selectedCategory,
                    onTap: (index) {
                      selectedCategory = index;
                      _notify();
                    },
                    index: index,
                    isLast: (subjects.length - 1) == index,
                  );
                }).toList(),
              ),
            ),
          );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
