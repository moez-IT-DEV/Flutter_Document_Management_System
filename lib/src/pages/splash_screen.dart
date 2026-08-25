import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/dimensions.dart';

import '../Utils/my_images.dart';
import '../Utils/routes.dart';
import '../Utils/util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  final _key = GlobalKey<FormState>();
  void initState() {
    MyUtils.splashScreenUtil();
    super.initState();
  }

  @override
  void dispose() {
    MyUtils.allScreenUtil();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 206, 16),
        body: Center(
          child: Image.asset(MyImages.appLogo,
              height: Dimensions.logoH, width: Dimensions.logoW),
        ),
      ),
    );
  }
}
