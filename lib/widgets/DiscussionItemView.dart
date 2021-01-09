import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/AddCommentScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class DiscussionItemView extends StatefulWidget {
  int index;
  int totalDiscussions;
  Function onUpArrowTap;
  Function onItemTap;
  bool isDetails = false;
  DiscussionItemView({
    @required this.index,
    @required this.totalDiscussions,
    @required this.onUpArrowTap,
    @required this.onItemTap,
    @required this.isDetails,
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
            Utility.discussionUserView(),
            questionView(widget.index),
            questionImageView(widget.index),
            utilityView(widget.index),
            commentView(widget.index),
            (widget.totalDiscussions - 1) == widget.index
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

  Widget questionImageView(int index) {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: Image.asset(
        AppAssets.dummyQuestionImage,
      ),
    );
  }

  Widget questionView(int index) {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: Text(
        "How to answer this question? I am getting answer as 5 Kg, but it is wrong answer pls help!",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget commentView(int index) {
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
                image: AssetImage(AppAssets.dummyUser),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCommentScreen(),
                  ),
                );
              },
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
          SvgPicture.asset(AppAssets.camera),
        ],
      ),
    );
  }

  Widget utilityView(int index) {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Utility.likeCommentView(
              AppAssets.postLike,
              "34",
            ),
            SizedBox(
              width: 16,
            ),
            Utility.likeCommentView(
              AppAssets.postComment,
              "59",
            ),
            Spacer(),
            index % 2 == 0
                ? Container()
                : GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 16,
                        right: 8,
                      ),
                      child: SvgPicture.asset(AppAssets.postEdit),
                    ),
                  ),
            index % 2 == 0
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: VerticalDivider(),
                  ),
            index % 2 == 0
                ? Container()
                : GestureDetector(
                    onTap: () {
                      Utility.showDeleteDialog(
                        context: context,
                        onDeletePress: () async {
                          //delay to give ripple effect
                          await Future.delayed(
                              Duration(milliseconds: AppStrings.delay));
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      child: SvgPicture.asset(AppAssets.postDelete),
                    ),
                  ),
            index % 2 == 0
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: VerticalDivider(),
                  ),
            GestureDetector(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(
                  left: 8,
                  top: 16,
                  bottom: 16,
                ),
                child: SvgPicture.asset(index % 2 == 0
                    ? AppAssets.bookmark
                    : AppAssets.postunBookmark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
