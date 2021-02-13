import 'package:flutter/material.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/DiscussionItemView.dart';

class DiscussionDetailsScreen extends StatefulWidget {
  int index;
  int totalDiscussions;
  DiscussionDetailsScreen({
    @required this.index,
    @required this.totalDiscussions,
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
    return Column(
      children: [
        Utility.appbar(
          context,
          text: "Discussion Forum",
        ),
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
              index: widget.index,
              onUpArrowTap: null,
              totalDiscussions: widget.totalDiscussions,
              isDetails: true,
              onItemTap: null,
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
          Utility.discussionUserView(),
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
              AppAssets.liked,
              "34",
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
