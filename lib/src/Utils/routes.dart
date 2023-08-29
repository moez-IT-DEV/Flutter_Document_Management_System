import 'package:get/get_navigation/get_navigation.dart';

import '../pages/loginpage.dart';
import '../pages/splash_screen.dart';

class RouteHelper {
  static const String splashScreen = "/splash_screen";
  static const String loginScreen = "/login_screen";

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: loginScreen, page: () => const loginpage()),
  ];
}
