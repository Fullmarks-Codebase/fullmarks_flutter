import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';

import 'package:fullmarks/notus/notus.dart';
import 'package:fullmarks/zefyr/zefyr.dart';

class AddCommentScreen extends StatefulWidget {
  DiscussionDetails discussion;
  AddCommentScreen({
    @required this.discussion,
  });
  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  FocusNode fn = FocusNode();
  final ZefyrController _controller = ZefyrController(NotusDocument());
  bool _isLoading = false;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.addCommentEvent);
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
              Navigator.pop(context);
              if (_controller.plainTextEditingValue.text.trim().length == 0) {
                Utility.showToast("Please type your question");
              } else {
                addComment();
              }
            },
          ),
          Expanded(
            child: _isLoading
                ? Utility.progress(context)
                : Container(
                    margin: EdgeInsets.only(top: 16),
                    color: AppColors.greyColor9,
                    padding: EdgeInsets.all(16),
                    child: Expanded(
                      child: ZefyrField(
                        decoration: InputDecoration(
                          hintText: "Type your comment",
                          border: InputBorder.none,
                        ),
                        controller: _controller,
                        focusNode: fn,
                        autofocus: false,
                        imageDelegate: CustomImageDelegate(),
                        physics: ClampingScrollPhysics(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  addComment() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = widget.discussion.id.toString();
      request["comment"] = jsonEncode(_controller.document);
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.addPostsComments, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(response.message);

      if (response.code == 200) {
        Navigator.of(context).pop(true);
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
