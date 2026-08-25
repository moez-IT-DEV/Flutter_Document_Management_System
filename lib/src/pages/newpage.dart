import 'package:test1/src/api_sevices/services.dart';
import 'package:test1/src/services/folderService.dart';
import 'package:test1/src/model/foldermodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api_sevices/api_services.dart';
import '../database/FirebaseStorage.dart';

class NewPage extends StatefulWidget {
  late final FolderModel folder;

  NewPage({required this.folder});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final FilesController controller =
      Get.put<FilesController>(FilesController());
  FolderModel? selectedFolder;

  List<FileList> filteredFiles = [];
  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Folder Details"),
      ),
      body: FutureBuilder<List<FileList>>(
        future: controller.getFilesCategory(widget.folder.folder),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No files found."),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FileList file = snapshot.data![index];
                return ListTile(
                  title: Text(file.tittle ?? ''),
                  subtitle: Text(file.description ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _launchURL(snapshot.data![index].url!);
                        },
                        icon: Icon(Icons.find_in_page_rounded),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select Folder To Move'),
                                content: FutureBuilder<List<FolderModel>>(
                                  future: FolderCollection().getFoldersList(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
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
                                          return DropdownMenuItem<FolderModel>(
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
                                        return;
                                      }

                                      try {
                                        await DataStorage().updateFileField(
                                          file.tittle!,
                                          'folder',
                                          selectedFolder!.folder!,
                                        );
                                        print("Changed successfully");
                                        final snackBar = SnackBar(
                                          content: Center(
                                            child: Text('Changed successfully'),
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 3),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);

                                        Navigator.pop(context);
                                        print(file.tittle);
                                        print(selectedFolder!.folder);
                                      } catch (e) {
                                        print(
                                            'Error updating folder field: $e');
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Move'),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select Folder To Copy '),
                                content: FutureBuilder<List<FolderModel>>(
                                  future: FolderCollection().getFoldersList(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
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
                                          return DropdownMenuItem<FolderModel>(
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

                                        return;
                                      }

                                      try {
                                        await DataStorage().copyFileField(
                                          file.tittle!,
                                          file.description!,
                                          file.url!,
                                          file.date.toString()!,
                                          selectedFolder!.folder!,
                                          file.user!,
                                          'folder',
                                        );
                                        print("Copy document successfully");
                                        final snackBar = SnackBar(
                                          content: Center(
                                            child: Text(
                                                'Copy document successfully'),
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 3),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);

                                        Navigator.pop(context);
                                      } catch (e) {
                                        print(
                                            'Error updating folder field: $e');
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Copy'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.file_copy),
                      ),
                      IconButton(
                          onPressed: () {
                            /*
                                controller.deleteFiles(filteredFiles[index]
                                    .tittle!);*/
                            // Added null check for tittle
                            controller.showDeleteConfirmation(
                                snapshot.data![index].tittle!);
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
