import 'package:fullmarks/utility/Utiity.dart';
import 'package:fullmarks/zefyr/src/widgets/attr_delegate.dart';

class CustomAttrDelegate implements ZefyrAttrDelegate {
  CustomAttrDelegate();

  @override
  void onLinkTap(String value) {
    print(value);
    Utility.launchURL(value.trim());
  }
}
