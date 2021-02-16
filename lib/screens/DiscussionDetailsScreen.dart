import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommentResponse.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/notus/src/document.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CustomAttrDelegate.dart';
import 'package:fullmarks/widgets/CustomImageDelegate.dart';
import 'package:fullmarks/widgets/DiscussionItemView.dart';
import 'package:fullmarks/zefyr/src/widgets/view.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'AddCommentScreen.dart';
import 'AddDiscussionScreen.dart';

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
  bool _isLoading = false;
  bool _isLoadingComments = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  int page = 0;
  bool stop = false;
  List<CommentDetails> comments = List();
  Customer customer = Utility.getCustomer();

  @override
  void initState() {
    AppFirebaseAnalytics.init()
        .logEvent(name: AppStrings.discussionDetailsEvent);
    controller = ScrollController();
    _getDiscussions();
    _getComments();
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

  _getComments() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoadingComments = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = widget.discussion.id.toString();
      page = page + 1;
      request["page"] = page.toString();
      //api call
      CommentResponse response = CommentResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.getPostsComments, request: request),
      );
      //hide progress
      _isLoadingComments = false;
      _notify();

      if (response.code == 200) {
        if (response.result.length != 0) {
          comments.addAll(response.result);
          _notify();
        } else {
          noDataLogic(page);
        }
      } else {
        noDataLogic(page);
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  noDataLogic(int pagenum) {
    print("noDataLogic");
    //show empty view
    page = pagenum - 1;
    stop = true;
    _notify();
  }

  refresh() {
    print("refresh");
    //to refresh page
    page = 0;
    comments.clear();
    stop = false;
    _notify();
    _getComments();
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
      child: _isLoading
          ? Utility.progress(context)
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                _getDiscussions();
                refresh();
              },
              child: SingleChildScrollView(
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(),
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
                              isEdit: false,
                              discussion: widget.discussion,
                              comment: null,
                            ),
                          ),
                        );
                        if (isComment != null) {
                          _getDiscussions();
                          refresh();
                        }
                      },
                      onDelete: () {
                        Navigator.pop(context);
                        _deleteDiscussion();
                      },
                      onEdit: () async {
                        bool isRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDiscussionScreen(
                              isEdit: true,
                              discussion: widget.discussion,
                            ),
                          ),
                        );
                        if (isRefresh != null) {
                          _getDiscussions();
                        }
                      },
                      onLikeDislike: () async {
                        //delay to give ripple effect
                        await Future.delayed(
                            Duration(milliseconds: AppStrings.delay));
                        if (widget.discussion.liked == 1) {
                          disLikePost();
                        } else {
                          likePost();
                        }
                      },
                      onSaveUnsave: () {
                        if (widget.discussion.save == 0) {
                          savePost();
                        } else {
                          unsavePost();
                        }
                      },
                    ),
                    commentsListView(),
                    _isLoadingComments || comments.length == 0
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(
                              top: 16,
                              bottom: 16,
                            ),
                            child: Utility.roundShadowButton(
                              context: context,
                              assetName: AppAssets.upArrow,
                              onPressed: () async {
                                //delay to give ripple effect
                                await Future.delayed(
                                    Duration(milliseconds: AppStrings.delay));
                                controller.animateTo(
                                  0,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
    );
  }

  _deleteDiscussion() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context).deleteCall(
          url: AppStrings.deletePosts + widget.discussion.id.toString(),
        ),
      );

      Utility.showToast(response.message);

      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        Navigator.pop(context, true);
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  savePost() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = widget.discussion.id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.savePosts, request: request),
      );

      if (response.code == 200) {
        widget.discussion.save = 1;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  unsavePost() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = widget.discussion.id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.removeSavePosts, request: request),
      );

      if (response.code == 200) {
        widget.discussion.save = 0;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
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
    return Stack(
      children: [
        !_isLoadingComments && comments.length == 0
            ? Utility.emptyView("No Comments")
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(comments.length, (index) {
                  return (comments.length - 1) == index
                      /*
                                VisibilityDetector is only attached to last item of list.
                                when this view is visible we will call api for next page.
                              */
                      ? VisibilityDetector(
                          key: Key(index.toString()),
                          child: commentsItemView(index),
                          onVisibilityChanged: (visibilityInfo) {
                            if (!stop) {
                              _getComments();
                            }
                          },
                        )
                      : commentsItemView(index);
                }),
              ),
        _isLoadingComments ? Utility.progress(context) : Container()
      ],
    );
  }

  Widget commentsItemView(int index) {
    return Container(
      color: AppColors.lightAppColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Utility.discussionListSeparator(),
          userView(),
          Container(
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ZefyrView(
              document: NotusDocument.fromDelta(
                Delta.fromJson(json.decode(comments[index].comment) as List),
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
                  assetName: comments[index].liked == 1
                      ? AppAssets.liked
                      : AppAssets.postLike,
                  count: comments[index].likes.toString(),
                  onPressed: () async {
                    //delay to give ripple effect
                    await Future.delayed(
                        Duration(milliseconds: AppStrings.delay));
                    if (comments[index].liked == 1) {
                      disLikeComment(index);
                    } else {
                      likeComment(index);
                    }
                  },
                ),
                Spacer(),
                comments[index].userId != customer.id
                    ? Container()
                    : Utility.iconButton(
                        assetName: AppAssets.postEdit,
                        onPressed: () async {
                          //delay to give ripple effect
                          await Future.delayed(
                              Duration(milliseconds: AppStrings.delay));
                          bool isRefresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCommentScreen(
                                isEdit: true,
                                discussion: widget.discussion,
                                comment: comments[index],
                              ),
                            ),
                          );
                          if (isRefresh != null) {
                            _getDiscussions();
                            refresh();
                          }
                        },
                      ),
                comments[index].userId != customer.id
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        child: VerticalDivider(),
                      ),
                comments[index].userId != customer.id
                    ? Container()
                    : Utility.iconButton(
                        assetName: AppAssets.postDelete,
                        onPressed: () {
                          Utility.showDeleteDialog(
                            context: context,
                            title: "Do you want to delete this Comment?",
                            onDeletePress: () async {
                              //delay to give ripple effect
                              await Future.delayed(
                                  Duration(milliseconds: AppStrings.delay));
                              Navigator.pop(context);
                              _deleteComment(index);
                            },
                          );
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
    );
  }

  _deleteComment(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context).deleteCall(
          url: AppStrings.deletePostsComments + comments[index].id.toString(),
        ),
      );

      Utility.showToast(response.message);

      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        comments.removeAt(index);
        widget.discussion.comments = widget.discussion.comments - 1;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  likeComment(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["commentId"] = comments[index].id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.likePostsComments, request: request),
      );

      if (response.code == 200) {
        comments[index].likes = comments[index].likes + 1;
        comments[index].liked = 1;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
  }

  disLikeComment(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["commentId"] = comments[index].id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.dislikePostsComments, request: request),
      );

      if (response.code == 200) {
        comments[index].likes = comments[index].likes - 1;
        comments[index].liked = 0;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
    }
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
