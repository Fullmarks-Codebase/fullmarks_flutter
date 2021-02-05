import 'package:firebase_analytics/firebase_analytics.dart';

class AppFirebaseAnalytics {
  static FirebaseAnalytics get _instance =>
      _prefsInstance ??= FirebaseAnalytics();
  static FirebaseAnalytics _prefsInstance;

  // call this method from iniState() function of mainApp().
  static FirebaseAnalytics init() {
    _prefsInstance = _instance;
    return _prefsInstance;
  }
}
