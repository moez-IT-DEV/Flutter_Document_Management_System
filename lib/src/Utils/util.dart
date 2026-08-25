import 'package:flutter/services.dart';

import 'my_color.dart';

class MyUtils {
  static void splashScreenUtil() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: MyColor.primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MyColor.primaryColor,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  static void allScreenUtil() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: MyColor.primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MyColor.screenBgColor,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  static void authScreenUtils() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: MyColor.primaryColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MyColor.screenBgColor,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  static makePortraitOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static makePortraitAndLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
