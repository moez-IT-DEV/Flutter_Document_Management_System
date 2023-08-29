// ignore_for_file: deprecated_member_use

import 'package:dms/src/api_sevices/api_services.dart';
import 'package:dms/src/api_sevices/services.dart';
import 'package:dms/src/database/FirebaseStorage.dart';
import 'package:dms/src/services/folderService.dart';
import 'package:dms/src/model/foldermodel.dart';
import 'package:dms/src/pages/add_document.dart';
import 'package:dms/src/pages/audit.dart';
import 'package:dms/src/pages/charts.dart';
import 'package:dms/src/pages/settings.dart';
import 'package:dms/src/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../services/auth_sevices.dart';
import '../widgets/buttons.dart';
import '../widgets/nav_bar.dart';
import '../widgets/text.dart';
import 'filesbyCategory.dart';

class allDocuments extends StatefulWidget {
  const allDocuments({Key? key}) : super(key: key);

  @override
  State<allDocuments> createState() => _allDocumentsState();
}

class _allDocumentsState extends State<allDocuments> {
  int pageindex = 0;
  final pages = [
    displaypage(),
    Homepage(),
    fileCategory(),
    Userspage(),
    Auditspage(),
    Settings()
  ];
  final FilesController controller =
      Get.put<FilesController>(FilesController());
  @override
  void initState() {
    super.initState();
    controller.getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: <Widget>[
          Icon(Icons.home),
          Icon(Icons.file_copy),
          Icon(Icons.file_copy_outlined),
          Icon(Icons.person),
          Icon(Icons.lens_outlined),
          Icon(Icons.settings),
        ],
        onTap: (index) {
          setState(() {
            pageindex = index;
          });
        },
        index: pageindex,
      ),
      body: pages[pageindex],
    );
  }
}

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FilesController controller =
      Get.put<FilesController>(FilesController());
  TextEditingController searchController = TextEditingController();
  TextEditingController newTitleController = TextEditingController();
  TextEditingController newDescriptionController = TextEditingController();
  List<FileList> filteredFiles = [];
  FolderModel? selectedFolder;

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      filteredFiles = List.from(controller.files?.value ?? []);
    } else {
      filteredFiles = controller.files?.value
              ?.where((file) =>
                  file.tittle!.toLowerCase().contains(query.toLowerCase()) ||
                  file.description!.toLowerCase().contains(query.toLowerCase()))
              .toList() ??
          [];
    }
    setState(() {});
  }

  Future<void> showUpdateTitleDialog(
      String currentTitle, String currentDescription) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Title and Description'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newTitleController,
                  decoration: InputDecoration(
                    hintText: currentTitle,
                  ),
                ),
                TextField(
                  controller: newDescriptionController,
                  decoration: InputDecoration(
                    hintText: currentDescription,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        String newTitle = newTitleController.text.trim();
                        String newDescription =
                            newDescriptionController.text.trim();
                        if (newTitle.isNotEmpty && newDescription.isNotEmpty) {
                          // Call the function to update the title
                          updateFileTitle(currentTitle, newTitle,
                              currentDescription, newDescription);
                          final snackBar = SnackBar(
                            content: Center(
                              child: Text(
                                  'Successfully update title and description'),
                            ),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 3),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          /*
                    Fluttertoast.showToast(
                        msg: "Successfully update title and description",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                        */
                          Navigator.of(context).pop();
                        } else {
                          final snackBar = SnackBar(
                            content: Center(
                              child: Text(
                                'Title or description is empty',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          /*
                    Fluttertoast.showToast(
                        msg: "Title or description is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                        */
                        }
                      },
                      child: Text('Update'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateFileTitle(String currentTitle, String newTitle,
      String currentDescription, String newDescription) {
    try {
      // Assuming DataStorage().updateFileTittle is the correct function
      DataStorage().updateFileTittle(
          currentTitle, newTitle, currentDescription, newDescription);
    } catch (e) {
      print('Error updating file title: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    filteredFiles = List.from(controller.files?.value ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
        ),
        top_nav(
          tittle: "ALL DOCUMENTS",
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Add_document()));
                },
                child: Text("Add Document"),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              // Call a method to perform search based on the value
              // You can use setState() or any other state management approach
              performSearch(value);
            },
            decoration: InputDecoration(
              hintText: "Search Document",
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.files != null &&
                controller.files!.value.isNotEmpty) {
              // Removed unnecessary null check
              return ListView.builder(
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("File Title: ${filteredFiles[index].tittle}"),
                      subtitle: Text(
                          "File Description: ${filteredFiles[index].description}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                _launchURL(filteredFiles[index]
                                    .url!); // Added null check for url
                              },
                              icon: const Icon(Icons.find_in_page_rounded)),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Select Folder'),
                                    content: FutureBuilder<List<FolderModel>>(
                                      future:
                                          FolderCollection().getFoldersList(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Text("No folders found.");
                                        } else {
                                          return DropdownButtonFormField<
                                              FolderModel>(
                                            value: selectedFolder,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedFolder = newValue;
                                              });
                                            },
                                            items: snapshot.data!.map((folder) {
                                              return DropdownMenuItem<
                                                  FolderModel>(
                                                value: folder,
                                                child: Text(folder.folder),
                                              );
                                            }).toList(),
                                          );
                                        }
                                      },
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (selectedFolder == null) {
                                            print("Selected folder is null");
                                            final snackBar = SnackBar(
                                              content: Center(
                                                child: Text(
                                                  'Selected folder is null',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            /*
                                            Fluttertoast.showToast(
                                                msg: "Selected folder is null",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                                */
                                            return;
                                          }

                                          try {
                                            await DataStorage().updateFileField(
                                              filteredFiles[index].tittle!,
                                              'folder',
                                              selectedFolder!.folder!,
                                            );
                                            print("Changed successfully");
                                            final snackBar = SnackBar(
                                              content: Center(
                                                child: Text(
                                                    'Changed successfully'),
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 3),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            /*
                                            Fluttertoast.showToast(
                                                msg: "Changed successfully",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                                */
                                            print(selectedFolder!.folder);
                                            Fluttertoast.showToast(
                                                msg: (selectedFolder!.folder),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          } catch (e) {
                                            print(
                                                'Error updating folder field: $e');
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Error updating folder field",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.drive_file_move),
                          ),
                          IconButton(
                            onPressed: () {
                              showUpdateTitleDialog(
                                  filteredFiles[index].tittle!,
                                  filteredFiles[index]
                                      .description!); // Added null check for tittle
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                              onPressed: () {
                                /*
                                controller.deleteFiles(filteredFiles[index]
                                    .tittle!);*/
                                // Added null check for tittle
                                controller.showDeleteConfirmation(
                                    filteredFiles[index].tittle!);
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Text("Please wait"); // Added missing semicolon
            }
          }),
        ),
      ],
    );
  }
}
