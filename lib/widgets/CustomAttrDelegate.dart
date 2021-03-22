import 'package:flutter/material.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/zefyr/src/widgets/attr_delegate.dart';

class CustomAttrDelegate implements ZefyrAttrDelegate {
  CustomAttrDelegate();

  @override
  void onLinkTap(BuildContext context, String value) {
    Utility.launchURL(context, value.trim());
  }
}
