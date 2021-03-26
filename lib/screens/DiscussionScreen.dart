import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommentResponse.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/models/SubjectsResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/screens/DiscussionDetailsScreen.dart';
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

class DiscussionScreen extends StatefulWidget {
  @override
  _DiscussionScreenState createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  ScrollController controller;
  int selectedFilter = 0;
  int selectedCategory = 0;
  List<SubjectDetails> subjects = List();
  bool _isLoadingCategory = false;
  bool _isLoading = false;
  Customer customer = Utility.getCustomer();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<DiscussionDetails> discussions = List();
  int page = 0;
  bool stop = false;
  File _image;
  final _picker = ImagePicker();
  bool _isLoadingComments = false;
  List<CommentDetails> comments = List();
  int selectedPostToViewComment = -1;
  bool isShowMoreComments = false;

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.discussionEvent);
    controller = ScrollController();
    _getSubjects();
    super.initState();
  }

  _getSubjects() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoadingCategory = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["userId"] = customer.id.toString();
      request["id"] = customer.classGrades.id.toString();
      request["calledFrom"] = "app";
      //api call
      SubjectsResponse response = SubjectsResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.subjects, request: request),
      );
      //hide progress
      _isLoadingCategory = false;
      _notify();
      if (response.code == 200) {
        if (response.result.length != 0) {
          subjects.clear();
          subjects.add(SubjectDetails(
            id: 0,
            name: "All",
          ));
          subjects.addAll(response.result);
          _notify();
          refresh();
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  _getDiscussions() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      if (subjects.length > 0) {
        if (subjects[selectedCategory].id != 0) {
          request["subjectId"] = subjects[selectedCategory].id.toString();
        }
      }
      page = page + 1;
      request["page"] = page.toString();
      //api call
      DiscussionResponse response = DiscussionResponse.fromJson(
        await ApiManager(context).postCall(
            url: selectedFilter == 0
                ? AppStrings.getPosts
                : selectedFilter == 1
                    ? AppStrings.myPosts
                    : AppStrings.mySavedPosts,
            request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        if (response.result.length != 0) {
          discussions.addAll(response.result);
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
    discussions.clear();
    stop = false;
    selectedPostToViewComment = -1;
    _notify();
    _getDiscussions();
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
      floatingActionButton: subjects.length == 0
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.appColor,
              child: Icon(Icons.add),
              onPressed: () async {
                //delay to give ripple effect
                await Future.delayed(Duration(milliseconds: AppStrings.delay));
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDiscussionScreen(
                      isEdit: false,
                      discussion: null,
                    ),
                  ),
                );
                refresh();
              },
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
        subjects.length == 0 ? Container() : filterDiscussion(),
        SizedBox(
          height: 16,
        ),
        _isLoadingCategory ? Utility.progress(context) : categoryView(),
        SizedBox(
          height: 16,
        ),
        Expanded(
          child: Stack(
            children: [
              discussionList(),
              _isLoading ? Utility.progress(context) : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget categoryView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Row(
          children: subjects.map((e) {
            int index = subjects.indexOf(e);
            return Utility.categoryItemView(
              title: subjects[index].name,
              selectedCategory: selectedCategory,
              onTap: (index) {
                selectedCategory = index;
                _notify();
                refresh();
              },
              index: index,
              isLast: (subjects.length - 1) == index,
            );
          }).toList(),
        ),
      ),
    );
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  Widget filterDiscussion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 8,
        ),
        filterItemView(AppAssets.explore, "Explore", 0),
        SizedBox(
          width: 8,
        ),
        filterItemView(AppAssets.help, "My Question", 1),
        SizedBox(
          width: 8,
        ),
        filterItemView(AppAssets.bookmark, "Favourites", 2),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }

  Widget filterItemView(String assetName, String title, int index) {
    return GestureDetector(
      onTap: () {
        selectedFilter = index;
        _notify();
        refresh();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedFilter == index
              ? AppColors.appColor
              : AppColors.chartBgColorLight,
          border: Border.all(
            color: AppColors.appColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetName,
              color:
                  selectedFilter == index ? Colors.white : AppColors.appColor,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: TextStyle(
                color:
                    selectedFilter == index ? Colors.white : AppColors.appColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget discussionList() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        refresh();
      },
      child: !_isLoadingCategory && !_isLoading && discussions.length == 0
          ? ListView(
              padding: EdgeInsets.all(16),
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      ((AppBar().preferredSize.height * 2) + 100),
                  child: Utility.emptyView(selectedFilter == 0
                      ? "No Discussion Forum"
                      : selectedFilter == 1
                          ? "No My Question"
                          : "No Favourites"),
                ),
              ],
            )
          : ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              controller: controller,
              itemBuilder: (context, index) {
                return (discussions.length - 1) == index
                    /*
                            VisibilityDetector is only attached to last item of list.
                            when this view is visible we will call api for next page.
                          */
                    ? VisibilityDetector(
                        key: Key(index.toString()),
                        child: itemView(index),
                        onVisibilityChanged: (visibilityInfo) {
                          if (!stop) {
                            _getDiscussions();
                          }
                        },
                      )
                    : itemView(index);
              },
              separatorBuilder: (context, index) {
                return Utility.discussionListSeparator();
              },
              itemCount: discussions.length,
            ),
    );
  }

  _onPicTap(int index) {
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
                _getImage(ImageSource.camera, index);
              },
              child: Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery, index);
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

  _getImage(ImageSource source, int index) async {
    _picker.getImage(source: source).then((value) {
      if (value != null) {
        _image = File(value.path);
        _notify();
        _cropImage(index);
      } else {
        print('No image selected.');
      }
      _notify();
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<Null> _cropImage(int index) async {
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
      addComment(index);
    }
  }

  addComment(int index) async {
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

      request.fields["postId"] = discussions[index].id.toString();
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
        discussions[index].comments++;
      } else {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(context, commonResponse.message);
      }
    } else {
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  _getComments(int index) async {
    isShowMoreComments = false;
    _notify();
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoadingComments = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = discussions[index].id.toString();
      request["page"] = "1";
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
          if (response.result.length > 5) {
            isShowMoreComments = true;
            comments = response.result.sublist(0, 5);
          } else {
            isShowMoreComments = false;
            comments = response.result;
          }
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

  Widget itemView(int index) {
    return Column(
      children: [
        DiscussionItemView(
          onCommentTap: () {
            if (discussions[index].comments > 0) {
              if (selectedPostToViewComment == index) {
                selectedPostToViewComment = -1;
                comments.clear();
                _notify();
              } else {
                selectedPostToViewComment = index;
                comments.clear();
                _notify();
                _getComments(index);
              }
            }
          },
          onCameraTap: () {
            _onPicTap(index);
          },
          customer: customer,
          discussion: discussions[index],
          isDetails: false,
          onItemTap: () {
            onItemTap(index);
          },
          onAddComment: () async {
            bool isComment = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddCommentScreen(
                  isEdit: false,
                  discussion: discussions[index],
                  comment: null,
                ),
              ),
            );
            if (isComment != null) {
              discussions[index].comments = discussions[index].comments + 1;
              _notify();
              if (selectedPostToViewComment == index) {
                _getComments(index);
              }
            }
          },
          onLikeDislike: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            if (discussions[index].liked == 1) {
              disLikePost(index);
            } else {
              likePost(index);
            }
          },
          onEdit: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            bool isRefresh = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddDiscussionScreen(
                  isEdit: true,
                  discussion: discussions[index],
                ),
              ),
            );
            if (isRefresh != null) {
              refresh();
            }
          },
          onDelete: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
            _deleteDiscussion(index);
          },
          onSaveUnsave: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            if (discussions[index].save == 0) {
              savePost(index);
            } else {
              unsavePost(index);
            }
          },
          onUserTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherProfileScreen(
                  id: discussions[index].userId.toString(),
                ),
              ),
            );
          },
        ),
        commentsListView(index),
        showMoreCommentsView(index),
        (discussions.length - 1) == index
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 16),
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
            : Container(),
      ],
    );
  }

  Widget showMoreCommentsView(int postIndex) {
    return selectedPostToViewComment == postIndex
        ? isShowMoreComments
            ? GestureDetector(
                onTap: () {
                  onItemTap(postIndex);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Text(
                    "Show more ...",
                    style: TextStyle(
                      color: AppColors.appColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container()
        : Container();
  }

  Widget commentsListView(int postIndex) {
    return selectedPostToViewComment == postIndex
        ? Stack(
            children: [
              !_isLoadingComments && comments.length == 0
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Utility.emptyView("No Comments"),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(comments.length, (commentIndex) {
                        return commentsItemView(postIndex, commentIndex);
                      }),
                    ),
              _isLoadingComments ? Utility.progress(context) : Container()
            ],
          )
        : Container();
  }

  onItemTap(int index) async {
    //delay to give ripple effect
    await Future.delayed(Duration(milliseconds: AppStrings.delay));
    var data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscussionDetailsScreen(
          discussion: discussions[index],
        ),
      ),
    );
    if (selectedPostToViewComment == index) {
      _getComments(index);
    }
    try {
      DiscussionDetails discussion = data;
      if (discussion != null) {
        discussions[index] = discussion;
        _notify();
      }
    } catch (e) {}
    try {
      bool isRefresh = data;
      if (isRefresh != null) {
        refresh();
      }
    } catch (e) {}
  }

  Widget commentsItemView(int postIndex, int commentIndex) {
    return CommentsItemView(
      onUserTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherProfileScreen(
              id: discussions[postIndex].userId.toString(),
            ),
          ),
        );
      },
      customer: customer,
      discussion: discussions[postIndex],
      comment: comments[commentIndex],
      onDeleteTap: () {
        Utility.showDeleteDialog(
          context: context,
          title: "Do you want to delete this Comment?",
          onDeletePress: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
            _deleteComment(postIndex, commentIndex);
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
              discussion: discussions[postIndex],
              comment: comments[commentIndex],
            ),
          ),
        );
        if (isRefresh != null) {
          _getDiscussions();
          refresh();
          if (selectedPostToViewComment == postIndex) {
            _getComments(postIndex);
          }
        }
      },
      onLikeDislikeTap: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        if (comments[commentIndex].liked == 1) {
          disLikeComment(commentIndex);
        } else {
          likeComment(commentIndex);
        }
      },
    );
  }

  _deleteComment(int postIndex, int commentIndex) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context).deleteCall(
          url: AppStrings.deletePostsComments +
              comments[commentIndex].id.toString(),
        ),
      );

      Utility.showToast(context, response.message);

      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        comments.removeAt(commentIndex);
        discussions[postIndex].comments = discussions[postIndex].comments - 1;
        _notify();
        _getComments(postIndex);
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

  _deleteDiscussion(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context).deleteCall(
          url: AppStrings.deletePosts + discussions[index].id.toString(),
        ),
      );

      Utility.showToast(context, response.message);

      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        discussions.removeAt(index);
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  savePost(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = discussions[index].id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.savePosts, request: request),
      );

      if (response.code == 200) {
        discussions[index].save = 1;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  unsavePost(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = discussions[index].id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.removeSavePosts, request: request),
      );

      if (response.code == 200) {
        if (selectedFilter == 2) {
          discussions.removeAt(index);
        } else {
          discussions[index].save = 0;
        }
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  likePost(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = discussions[index].id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.likePosts, request: request),
      );

      if (response.code == 200) {
        discussions[index].likes = discussions[index].likes + 1;
        discussions[index].liked = 1;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  disLikePost(int index) async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //api request
      var request = Map<String, dynamic>();
      request["postId"] = discussions[index].id.toString();
      //api call
      CommonResponse response = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.dislikePosts, request: request),
      );

      if (response.code == 200) {
        discussions[index].likes = discussions[index].likes - 1;
        discussions[index].liked = 0;
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }
}
