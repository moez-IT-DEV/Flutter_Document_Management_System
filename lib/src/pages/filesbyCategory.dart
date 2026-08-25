import 'package:test1/src/services/folderService.dart';
import 'package:test1/src/model/foldermodel.dart';
import 'package:test1/src/pages/newpage.dart';
import 'package:test1/src/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../database/FirebaseStorage.dart';

class fileCategory extends StatefulWidget {
  const fileCategory({Key? key}) : super(key: key);

  @override
  State<fileCategory> createState() => _fileCategoryState();
}

class _fileCategoryState extends State<fileCategory> {
  List<FolderModel> itemsList = [];

  TextEditingController folderNameController = TextEditingController();
  TextEditingController newTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFolders();
  }

  fetchFolders() async {
    List<FolderModel> result = await FolderCollection().getFoldersList();
    if (result.isEmpty) {
      print("Unable to fetch data");
      Fluttertoast.showToast(
          msg: "Unable to fetch data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        itemsList = result;
      });
    }
  }

  void updateFileTitle(String currentTitle, String newTitle) {
    try {
      // Assuming DataStorage().updateFileTittle is the correct function
      FolderCollection().renameFolder(currentTitle, newTitle);
    } catch (e) {
      print('Error updating file title: $e');
      Fluttertoast.showToast(
          msg: "Error updating file title",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> showUpdateTitleDialog(String currentTitle) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Name Folder'),
          content: TextField(
            controller: newTitleController,
            decoration: InputDecoration(
              hintText: currentTitle,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newTitle = newTitleController.text.trim();
                if (newTitle.isNotEmpty) {
                  // Call the function to update the title
                  updateFileTitle(currentTitle, newTitle);
                  final snackBar = SnackBar(
                    content: Center(
                      child: Text('successfully updated'),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  /*
                  Fluttertoast.showToast(
                      msg: "successfully updated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0);
                      */
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void openCreateFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Folder"),
        content: TextField(
          controller: folderNameController,
          decoration: InputDecoration(hintText: "Folder Name"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String folderName = folderNameController.text;
              if (folderName.isEmpty) {
                final snackBar = SnackBar(
                  content: Center(
                    child: Text(
                      'Name folder is null',
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
                    msg: "Name folder is null",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0);
*/
                return;
              }
              // Create the new folder
              await FolderCollection().createFolderData(folderName);
              // Fetch the updated list of folders
              await fetchFolders();
              // Clear the text field
              folderNameController.clear();
              // Close the dialog
              Navigator.pop(context);
            },
            child: Text("Create"),
          ),
          TextButton(
            onPressed: () {
              // Clear the text field
              folderNameController.clear();
              // Close the dialog
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deleteFolder(String folderName) async {
    await FolderCollection().deleteFolder(folderName);
    await fetchFolders();
  }

  Future<void> showDeleteConfirmation(String folderName) async {
    bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the Folder?'),
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
      return deleteFolder(folderName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
        ),
        top_nav(
          tittle: "Document Folders",
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
                  // Open the create folder dialog
                  openCreateFolderDialog(context);
                },
                child: Text("Create Folder"),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    // Navigate to a new page and pass the selected folder
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewPage(folder: itemsList[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Card(
                      child: ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showUpdateTitleDialog(
                                      itemsList[index].folder);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  ///delete function
                                  showDeleteConfirmation(
                                      itemsList[index].folder);
                                  //deleteFolder(itemsList[index].folder);
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                        leading: Icon(Icons.folder),
                        title: Text("Folder Name: ${itemsList[index].folder}"),
                      ),
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
