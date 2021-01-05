import 'package:flutter/material.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class AddDiscussionScreen extends StatefulWidget {
  @override
  _AddDiscussionScreenState createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  int selectedCategory = 0;
  List<String> categoryList = Utility.getCategories(isAll: false);
  FocusNode fn = FocusNode();

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utility.appbar(
          context,
          text: "Add Question",
          homeassetName: AppAssets.checkBlue,
          onHomePressed: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
          },
        ),
        Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Text(
            "Select Category",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        categoryView(),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            color: AppColors.greyColor9,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: fn,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type your question",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Utility.textFieldIcons(
                  context,
                  onPickImageTap: () {},
                  onKeyboardTap: () {
                    if (MediaQuery.of(context).viewInsets.bottom == 0) {
                      FocusScope.of(context).requestFocus(fn);
                    } else {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  },
                  onSymbolTap: () {},
                  onBigTTap: () {},
                )
              ],
            ),
          ),
        ),
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
}
