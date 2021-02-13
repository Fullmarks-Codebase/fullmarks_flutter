import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/DiscussionItemView.dart';

import 'AddCommentScreen.dart';

class DiscussionDetailsScreen extends StatefulWidget {
  DiscussionDetails discussion;
  DiscussionDetailsScreen({
    @required this.discussion,
  });
  @override
  _DiscussionDetailsScreenState createState() =>
      _DiscussionDetailsScreenState();
}

class _DiscussionDetailsScreenState extends State<DiscussionDetailsScreen> {
  ScrollController controller;

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.discussionDetailsEvent);
    controller = ScrollController();
    _getDiscussions();
    super.initState();
  }

  _getDiscussions() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = widget.discussion.id.toString();
      //api call
      DiscussionResponse response = DiscussionResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.getPosts, request: request),
      );

      if (response.code == 200) {
        if (response.result.length != 0) {
          widget.discussion = response.result.first;
          _notify();
        }
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
    return Column(
      children: [
        Utility.appbar(context, text: "Discussion Forum",
            onBackPressed: () async {
          //delay to give ripple effect
          await Future.delayed(Duration(milliseconds: AppStrings.delay));
          Navigator.pop(context, widget.discussion);
        }),
        discussionDetailsView()
      ],
    );
  }

  Widget discussionDetailsView() {
    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            DiscussionItemView(
              onUpArrowTap: null,
              isDetails: true,
              onItemTap: null,
              customer: Utility.getCustomer(),
              discussion: widget.discussion,
              isLast: false,
              onAddComment: () async {
                bool isComment = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCommentScreen(
                      discussion: widget.discussion,
                    ),
                  ),
                );
                if (isComment != null) {
                  widget.discussion.comments = widget.discussion.comments + 1;
                  _notify();
                }
              },
              onDelete: () {},
              onEdit: () {},
              onLikeDislike: () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                if (widget.discussion.liked == 1) {
                  disLikePost();
                } else {
                  likePost();
                }
              },
              onSaveUnsave: () {},
            ),
            commentsListView(),
            Utility.roundShadowButton(
              context: context,
              assetName: AppAssets.upArrow,
              onPressed: () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                controller.animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  likePost() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = widget.discussion.id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.likePosts, request: request),
      );

      if (response.code == 200) {
        widget.discussion.likes = widget.discussion.likes + 1;
        widget.discussion.liked = 1;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  disLikePost() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = widget.discussion.id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.dislikePosts, request: request),
      );

      if (response.code == 200) {
        widget.discussion.likes = widget.discussion.likes - 1;
        widget.discussion.liked = 0;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  Widget commentsListView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return commentsItemView(index);
      }),
    );
  }

  Widget commentsItemView(index) {
    return Container(
      color: AppColors.lightAppColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utility.discussionListSeparator(),
          userView(),
          Container(
            margin: EdgeInsets.only(
              left:
                  82, // (50 + 16 +16) (width of image + left and right padding)
            ),
            child: Text(
              "My answer is 20",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            margin: EdgeInsets.only(
              left:
                  82, // (50 + 16 +16) (width of image + left and right padding)
            ),
            child: Utility.likeCommentView(
              assetName: AppAssets.liked,
              count: "34",
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget userView() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              bottom: 16,
              right: 16,
            ),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  AppStrings.userImage + widget.discussion.user.thumbnail,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.discussion.user.username,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      Utility.convertDate(
                          widget.discussion.createdAt.substring(0, 10)),
                      style: TextStyle(
                        color: AppColors.lightTextColor,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Container(
                      height: 12,
                      width: 12,
                      child: Utility.imageLoader(
                        baseUrl: AppStrings.subjectImage,
                        url: widget.discussion.subject.image,
                        placeholder: AppAssets.subjectPlaceholder,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.discussion.subject.name,
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
