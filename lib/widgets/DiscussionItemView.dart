import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/UserView.dart';
import 'package:fullmarks/zefyr/zefyr.dart';
import 'package:fullmarks/notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import 'CustomAttrDelegate.dart';
import 'CustomImageDelegate.dart';

class DiscussionItemView extends StatefulWidget {
  DiscussionDetails discussion;
  Function onItemTap;
  bool isDetails = false;
  Customer customer;
  Function onAddComment;
  Function onLikeDislike;
  Function onEdit;
  Function onDelete;
  Function onSaveUnsave;
  Function onUserTap;
  Function onCameraTap;
  Function onCommentTap;
  DiscussionItemView({
    @required this.discussion,
    @required this.onItemTap,
    @required this.isDetails,
    @required this.customer,
    @required this.onAddComment,
    @required this.onLikeDislike,
    @required this.onEdit,
    @required this.onDelete,
    @required this.onSaveUnsave,
    @required this.onUserTap,
    @required this.onCameraTap,
    @required this.onCommentTap,
  });
  @override
  _DiscussionItemViewState createState() => _DiscussionItemViewState();
}

class _DiscussionItemViewState extends State<DiscussionItemView> {
  @override
  Widget build(BuildContext context) {
    return discussionItemView();
  }

  Widget discussionItemView() {
    return GestureDetector(
      onTap: widget.onItemTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            UserView(
              onUserTap: widget.onUserTap,
              discussion: widget.discussion,
            ),
            questionView(),
            utilityView(),
            commentView(),
          ],
        ),
      ),
    );
  }

  Widget questionView() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: ZefyrView(
        document: NotusDocument.fromDelta(
          Delta.fromJson(json.decode(widget.discussion.question) as List),
        ),
        imageDelegate: CustomImageDelegate(AppStrings.postImage),
        attrDelegate: CustomAttrDelegate(),
      ),
    );
  }

  Widget commentView() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyColor5,
        border: Border.all(
          color: AppColors.greyColor7,
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              right: 16,
            ),
            child: Utility.getUserImage(
              url: widget.customer.thumbnail,
              height: 35,
              width: 35,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onAddComment,
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 16,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColors.greyColor6,
                        ),
                      ),
                      child: Text(
                        "Add a Comment...",
                        style: TextStyle(
                          color: AppColors.greyColor8,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onCameraTap,
                  child: Container(
                    color: Colors.transparent,
                    child: SvgPicture.asset(AppAssets.camera),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget utilityView() {
    return Container(
      padding: EdgeInsets.only(
        right: 8,
        left: 8,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Utility.likeCommentView(
              assetName: widget.discussion.liked == 1
                  ? AppAssets.liked
                  : AppAssets.postLike,
              count: widget.discussion.likes.toString(),
              onPressed: widget.onLikeDislike,
            ),
            SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                widget.onCommentTap();
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.postComment,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.discussion.comments.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            widget.discussion.userId != widget.customer.id
                ? Container()
                : Utility.iconButton(
                    assetName: AppAssets.postEdit,
                    onPressed: widget.onEdit,
                  ),
            widget.discussion.userId != widget.customer.id
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: VerticalDivider(),
                  ),
            widget.discussion.userId != widget.customer.id
                ? Container()
                : Utility.iconButton(
                    assetName: AppAssets.postDelete,
                    onPressed: () {
                      Utility.showDeleteDialog(
                        context: context,
                        onDeletePress: widget.onDelete,
                        title: "Do you want to delete this Question?",
                      );
                    },
                  ),
            widget.discussion.userId != widget.customer.id
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: VerticalDivider(),
                  ),
            Utility.iconButton(
              assetName: widget.discussion.save == 1
                  ? AppAssets.bookmark
                  : AppAssets.postunBookmark,
              onPressed: widget.onSaveUnsave,
            ),
          ],
        ),
      ),
    );
  }
}
