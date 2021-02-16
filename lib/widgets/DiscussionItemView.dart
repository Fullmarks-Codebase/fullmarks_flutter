import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/zefyr/zefyr.dart';
import 'package:fullmarks/notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import 'CustomAttrDelegate.dart';
import 'CustomImageDelegate.dart';

class DiscussionItemView extends StatefulWidget {
  DiscussionDetails discussion;
  Function onUpArrowTap;
  Function onItemTap;
  bool isDetails = false;
  bool isLast;
  Customer customer;
  Function onAddComment;
  Function onLikeDislike;
  Function onEdit;
  Function onDelete;
  Function onSaveUnsave;
  DiscussionItemView({
    @required this.discussion,
    @required this.onUpArrowTap,
    @required this.onItemTap,
    @required this.isDetails,
    @required this.isLast,
    @required this.customer,
    @required this.onAddComment,
    @required this.onLikeDislike,
    @required this.onEdit,
    @required this.onDelete,
    @required this.onSaveUnsave,
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
            userView(),
            questionView(),
            utilityView(),
            commentView(),
            widget.isLast
                ? widget.isDetails
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Utility.roundShadowButton(
                          context: context,
                          assetName: AppAssets.upArrow,
                          onPressed: widget.onUpArrowTap,
                        ),
                      )
                : Container()
          ],
        ),
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
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  AppStrings.userImage + widget.customer.thumbnail,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: widget.onAddComment,
              child: Row(
                children: [
                  Expanded(
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
                  SvgPicture.asset(AppAssets.camera),
                ],
              ),
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
            Row(
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
