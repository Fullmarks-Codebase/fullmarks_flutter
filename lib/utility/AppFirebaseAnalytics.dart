import 'package:firebase_analytics/firebase_analytics.dart';

class AppFirebaseAnalytics {
  static FirebaseAnalytics get _instance =>
      _firAnaInstance ??= FirebaseAnalytics();
  static FirebaseAnalytics _firAnaInstance;

  // call this method from iniState() function of mainApp().
  static FirebaseAnalytics init() {
    _firAnaInstance = _instance;
    return _firAnaInstance;
  }
}
