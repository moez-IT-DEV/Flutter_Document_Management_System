import 'package:test1/src/Utils/string_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_color.dart';
import 'my_strings.dart';

class CustomSnackBar {
  static showCustomSnackBar(
      {required List<String> errorList,
      required List<String> msg,
      required bool isError,
      int duration = 5}) {
    String message = '';
    if (isError) {
      if (errorList.isEmpty) {
        message = 'unknown error';
      } else {
        for (var element in errorList) {
          message = message.isEmpty ? '$message$element' : "$message\n$element";
        }
      }
      message =
          MyConverter.removeQuotationAndSpecialCharacterFromString(message);
    } else {
      if (msg.isEmpty) {
        message = 'success';
      } else {
        for (var element in msg) {
          message = message.isEmpty ? '$message$element' : "$message\n$element";
        }
      }

      message =
          MyConverter.removeQuotationAndSpecialCharacterFromString(message);
    }

    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.primaryColor,
      message: message,
      // icon:  Icon(isError?Icons.error:Icons.done_outline, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.redAccent : MyColor.primaryColor,
      borderRadius: 4,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static error({required List<String> errorList, int duration = 5}) {
    String message = '';
    if (errorList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in errorList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
    message = MyConverter.removeQuotationAndSpecialCharacterFromString(message);

    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.primaryColor,
      message: message,
      // icon:  Icon(isError?Icons.error:Icons.done_outline, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      borderRadius: 4,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static success(List<String> list,
      {required List<String> successList, int duration = 5}) {
    String message = '';
    if (successList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in successList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
    message = MyConverter.removeQuotationAndSpecialCharacterFromString(message);

    Get.rawSnackbar(
      progressIndicatorBackgroundColor: MyColor.primaryColor,
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: MyColor.primaryColor,
      borderRadius: 12,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      duration: Duration(seconds: duration),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
