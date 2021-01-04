import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/DiscussionDetailsScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/widgets/DiscussionItemView.dart';

import 'AddDiscussionScreen.dart';

class DiscussionScreen extends StatefulWidget {
  @override
  _DiscussionScreenState createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  ScrollController controller;
  int selectedFilter = 0;
  int selectedCategory = 0;
  List<String> categoryList = Utility.getCategories();
  int totalDiscussions = 5;

  @override
  void initState() {
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.appColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDiscussionScreen(),
            ),
          );
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
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        filterDiscussion(),
        SizedBox(
          height: 16,
        ),
        categoryView(),
        SizedBox(
          height: 16,
        ),
        discussionList(),
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
          children: categoryList.map((e) {
            return Utility.categoryItemView(
              title: e,
              selectedCategory: selectedCategory,
              onTap: (index) {
                selectedCategory = index;
                _notify();
              },
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
                // fontSize: 16,
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
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: controller,
        itemBuilder: (context, index) {
          return DiscussionItemView(
            isDetails: false,
            index: index,
            onUpArrowTap: () {
              controller.animateTo(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            totalDiscussions: totalDiscussions,
            onItemTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiscussionDetailsScreen(
                    index: index,
                    totalDiscussions: totalDiscussions,
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return Utility.discussionListSeparator();
        },
        itemCount: totalDiscussions,
      ),
    );
  }
}
