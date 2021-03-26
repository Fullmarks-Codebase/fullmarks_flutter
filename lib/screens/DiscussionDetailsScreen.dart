import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fullmarks/models/CommentResponse.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/CommentsItemView.dart';
import 'package:fullmarks/widgets/DiscussionItemView.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'AddCommentScreen.dart';
import 'AddDiscussionScreen.dart';
import 'OtherProfileScreen.dart';

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
  File _image;
  final _picker = ImagePicker();

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
      Utility.showToast(context, AppStrings.noInternet);
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
      Utility.showToast(context, AppStrings.noInternet);
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
                      onCommentTap: () {},
                      onCameraTap: () {
                        _onPicTap();
                      },
                      onUserTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherProfileScreen(
                              id: widget.discussion.userId.toString(),
                            ),
                          ),
                        );
                      },
                      isDetails: true,
                      onItemTap: null,
                      customer: Utility.getCustomer(),
                      discussion: widget.discussion,
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

  _onPicTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Select Post Picture"),
          message: Text("Select from"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
              child: Text("Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        );
      },
    );
  }

  _getImage(ImageSource source) async {
    _picker.getImage(source: source).then((value) {
      if (value != null) {
        _image = File(value.path);
        _notify();
        _cropImage();
      } else {
        print('No image selected.');
      }
      _notify();
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 80,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.appColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      _notify();
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
      var uri = Uri.parse(AppStrings.addPostsComments);
      var request = MultipartRequest('POST', uri);
      request.headers.addAll(headers);

      request.fields["postId"] = widget.discussion.id.toString();
      List question = [
        {
          "insert": "​",
          "attributes": {
            "embed": {
              "type": "image",
              "source": _image.path,
            }
          }
        },
        {"insert": "\n"}
      ];
      request.fields["comment"] = jsonEncode(question);

      if (_image != null) {
        request.files.add(
          await MultipartFile.fromPath(
            'postimages',
            _image.path,
            contentType: MediaType('image', _image.path.split(".").last),
            filename: _image.path.split("/").last,
          ),
        );
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
        Utility.showToast(context, commonResponse.message);
        _getDiscussions();
        refresh();
      } else {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(context, commonResponse.message);
      }
    } else {
      Utility.showToast(context, AppStrings.noInternet);
    }
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

      Utility.showToast(context, response.message);

      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        Navigator.pop(context, true);
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
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
      Utility.showToast(context, AppStrings.noInternet);
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
      Utility.showToast(context, AppStrings.noInternet);
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
      Utility.showToast(context, AppStrings.noInternet);
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
      Utility.showToast(context, AppStrings.noInternet);
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
    return CommentsItemView(
      onUserTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherProfileScreen(
              id: widget.discussion.userId.toString(),
            ),
          ),
        );
      },
      customer: customer,
      discussion: widget.discussion,
      comment: comments[index],
      onDeleteTap: () {
        Utility.showDeleteDialog(
          context: context,
          title: "Do you want to delete this Comment?",
          onDeletePress: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
            _deleteComment(index);
          },
        );
      },
      onEditTap: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
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
      onLikeDislikeTap: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        if (comments[index].liked == 1) {
          disLikeComment(index);
        } else {
          likeComment(index);
        }
      },
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

      Utility.showToast(context, response.message);

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
      Utility.showToast(context, AppStrings.noInternet);
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
      Utility.showToast(context, AppStrings.noInternet);
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
      Utility.showToast(context, AppStrings.noInternet);
    }
  }
}
