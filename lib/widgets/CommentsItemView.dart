import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommentResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/notus/src/document.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/UserView.dart';
import 'package:fullmarks/zefyr/src/widgets/view.dart';
import 'package:quill_delta/quill_delta.dart';

import 'CustomAttrDelegate.dart';
import 'CustomImageDelegate.dart';

class CommentsItemView extends StatefulWidget {
  DiscussionDetails discussion;
  CommentDetails comment;
  Function onUserTap;
  Function onLikeDislikeTap;
  Function onEditTap;
  Function onDeleteTap;
  Customer customer;
  CommentsItemView({
    @required this.discussion,
    @required this.comment,
    @required this.onUserTap,
    @required this.customer,
    @required this.onLikeDislikeTap,
    @required this.onEditTap,
    @required this.onDeleteTap,
  });
  @override
  _CommentsItemViewState createState() => _CommentsItemViewState();
}

class _CommentsItemViewState extends State<CommentsItemView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightAppColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utility.discussionListSeparator(),
          Container(
            padding: EdgeInsets.only(
              left: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserView(
                  onUserTap: widget.onUserTap,
                  discussion: widget.discussion,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: ZefyrView(
                    document: NotusDocument.fromDelta(
                      Delta.fromJson(
                          json.decode(widget.comment.comment) as List),
                    ),
                    imageDelegate: CustomImageDelegate(AppStrings.commentImage),
                    attrDelegate: CustomAttrDelegate(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Utility.likeCommentView(
                        assetName: widget.comment.liked == 1
                            ? AppAssets.liked
                            : AppAssets.postLike,
                        count: widget.comment.likes.toString(),
                        onPressed: () {
                          widget.onLikeDislikeTap();
                        },
                      ),
                      Spacer(),
                      widget.comment.userId != widget.customer.id
                          ? Container()
                          : Utility.iconButton(
                              assetName: AppAssets.postEdit,
                              onPressed: () async {
                                widget.onEditTap();
                              },
                            ),
                      widget.comment.userId != widget.customer.id
                          ? Container()
                          : Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              child: VerticalDivider(),
                            ),
                      widget.comment.userId != widget.customer.id
                          ? Container()
                          : Utility.iconButton(
                              assetName: AppAssets.postDelete,
                              onPressed: () {
                                widget.onDeleteTap();
                              },
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
