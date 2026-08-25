import 'dart:convert';

import 'package:test1/src/api_sevices/api_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

///open service.dart file
///replace the url
class FilesController extends GetxController {
  final String URL =
      "https://filemanagementsystemapi-production-6326.up.railway.app/api/Files";
  RxList<FileList>? files = RxList<FileList>();

  Future<void> getFiles() async {
    var client = http.Client();
    var uri = Uri.parse(URL);
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      var fileList = fileListFromJson(json)
          as List<FileList>?; // Explicitly cast to List<FileList>
      files!.value = fileList ?? [];
    }
  }

  Future<List<FileList>> getFilesCategory(String tittle) async {
    var client = http.Client();
    var uri = Uri.parse(URL + "/" + tittle);

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      // Parse the response body
      List<dynamic> jsonList = json.decode(response.body);
      // Convert each JSON object to a FileList object
      List<FileList> fileList =
          jsonList.map((json) => FileList.fromJson(json)).toList();

      return fileList;
    } else {
      print('Failed to get files. Status code: ${response.statusCode}');
      return [];
    }
  }

  Future<void> deleteFiles(String tittle) async {
    var client = http.Client();
    var uri = Uri.parse(URL + "/" + tittle);
    var response = await client.delete(uri);
    if (response.statusCode == 200) {
      print('File deleted successfully.');
      Fluttertoast.showToast(
          msg: "File deleted successfully.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Failed to delete file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      print('Failed to delete file. Status code: ${response.statusCode}');
    }
  }

  Future<void> showDeleteConfirmation(String tittle) async {
    bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the file?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false); // User canceled deletion
            },
            child: Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true); // User confirmed deletion
            },
            child: Text('YES'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await deleteFiles(tittle);
    }
  }
}
