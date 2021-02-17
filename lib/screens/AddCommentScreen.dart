import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommentResponse.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fullmarks/notus/notus.dart';
import 'package:fullmarks/zefyr/zefyr.dart';
import 'package:http/http.dart';
import 'package:quill_delta/quill_delta.dart';

class AddCommentScreen extends StatefulWidget {
  bool isEdit;
  DiscussionDetails discussion;
  CommentDetails comment;
  AddCommentScreen({
    @required this.isEdit,
    @required this.discussion,
    @required this.comment,
  });
  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  FocusNode fn = FocusNode();
  ZefyrController _controller = ZefyrController(NotusDocument());
  bool _isLoading = false;
  List<File> images = List();
  List<String> deleteImages = List();

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.addCommentEvent);

    if (widget.isEdit) {
      _controller = ZefyrController(NotusDocument.fromDelta(
        Delta.fromJson(json.decode(widget.comment.comment) as List),
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
            text: "Comment",
            homeassetName: AppAssets.checkBlue,
            onHomePressed: () async {
              //delay to give ripple effect
              await Future.delayed(Duration(milliseconds: AppStrings.delay));
              addCommentTap();
            },
          ),
          _isLoading
              ? Container()
              : Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Type your comment",
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
                      imageDelegate:
                          CustomImageDelegate(AppStrings.commentImage),
                      physics: BouncingScrollPhysics(),
                    ),
                  ),
                ),
          _isLoading ? Expanded(child: Utility.progress(context)) : Container()
        ],
      ),
    );
  }

  addCommentTap() {
    if (_controller.plainTextEditingValue.text.trim().length == 0) {
      Utility.showToast("Please type your comment");
    } else {
      addComment();
    }
  }

  addComment() async {
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
          ? AppStrings.updatePostsComments
          : AppStrings.addPostsComments);
      var request = MultipartRequest(widget.isEdit ? 'PUT' : 'POST', uri);
      request.headers.addAll(headers);
      request.fields["postId"] = widget.discussion.id.toString();
      if (widget.isEdit) {
        request.fields["commentId"] = widget.comment.id.toString();
        if (deleteImages.length > 0) {
          await Future.forEach(deleteImages, (String element) {
            int index = deleteImages.indexOf(element);
            request.fields["deleteImages[$index]"] = element;
          });
        }
      }
      request.fields["comment"] = jsonEncode(_controller.document);

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

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }
}
