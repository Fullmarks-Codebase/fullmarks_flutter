import 'package:fullmarks/zefyr/src/widgets/attr_delegate.dart';

class CustomAttrDelegate implements ZefyrAttrDelegate {
  CustomAttrDelegate();

  @override
  void onLinkTap(String value) {
    print('the link is: ${value}');
  }
}
