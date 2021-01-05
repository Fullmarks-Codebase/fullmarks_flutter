import 'package:flutter/material.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class AddCommentScreen extends StatefulWidget {
  @override
  _AddCommentScreenState createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
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
          text: "Comment",
          homeassetName: AppAssets.checkBlue,
          onHomePressed: () async {
            //delay to give ripple effect
            await Future.delayed(Duration(milliseconds: AppStrings.delay));
            Navigator.pop(context);
          },
        ),
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
                      hintText: "Type your comment",
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
}
