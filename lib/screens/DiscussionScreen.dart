import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:fullmarks/widgets/DiscussionItemView.dart';
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
      Utility.showToast(AppStrings.noInternet);
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
    discussions.clear();
    stop = false;
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

  Widget itemView(int index) {
    return DiscussionItemView(
      customer: customer,
      discussion: discussions[index],
      isLast: (discussions.length - 1) == index,
      isDetails: false,
      onUpArrowTap: () async {
        //delay to give ripple effect
        await Future.delayed(Duration(milliseconds: AppStrings.delay));
        controller.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
      onItemTap: () async {
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
    );
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

      Utility.showToast(response.message);

      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        discussions.removeAt(index);
        _notify();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(AppStrings.noInternet);
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
      Utility.showToast(AppStrings.noInternet);
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
      Utility.showToast(AppStrings.noInternet);
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
      Utility.showToast(AppStrings.noInternet);
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
      Utility.showToast(AppStrings.noInternet);
    }
  }
}
