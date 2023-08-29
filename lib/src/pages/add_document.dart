import 'dart:io';

import 'package:dms/src/database/FirebaseStorage.dart';
import 'package:dms/src/services/folderService.dart';
import 'package:dms/src/model/foldermodel.dart';
import 'package:dms/src/widgets/buttons.dart';
import 'package:dms/src/widgets/text.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' show Font;

import '../database/User_repository.dart';

class Add_document extends StatefulWidget {
  const Add_document({Key? key}) : super(key: key);

  @override
  State<Add_document> createState() => _Add_documentState();
}

class _Add_documentState extends State<Add_document> {
  String selectedoption = "";
  List<FolderModel> itemsList =
      []; // Add this line to declare the itemsList variable

  Map<String, dynamic> userDetails = {};
  DateTime date = DateTime.now();
  TextEditingController filetittle = TextEditingController();
  TextEditingController description = TextEditingController();
  FilePickerResult? result;
  String? filename;
  PlatformFile? pickedfile;
  bool isloding = false;
  File? filetodisplay;
  String name = "";
  PlatformFile? convertToFilePicker(File file) {
    return PlatformFile(
      path: file.path,
      name: file.path.split('/').last,
      size: file.lengthSync(),
      bytes: file.readAsBytesSync(),
    );
  }

  getImagecam() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    var imagePath = Path.join(
      (await getApplicationSupportDirectory()).path,
      "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}",
    );

    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning',
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      filename = imagePath.split('/').last;
      pickedfile = convertToFilePicker(File(imagePath));
      filetodisplay = File(pickedfile!.path!);
    });
  }

  void pickfile() async {
    try {
      setState(() {
        isloding = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null) {
        filename = result!.files.first.name;
        pickedfile = result!.files.first;
        filetodisplay = File(pickedfile!.path.toString());
      }
      setState(() {
        isloding = false;
      });
    } catch (e) {}
  }

  Future uploadfile() async {
    if (filetittle.text.isEmpty) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'title is empty',
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
          msg: "title is null",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
          */

      return;
    }
    if (description.text.isEmpty) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'description is empty',
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
          msg: "description is null",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
          */

      return;
    }
    if (filetodisplay == null) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'null file',
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
          msg: "null file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
          */

      return;
    }
    Fluttertoast.showToast(
        msg: "Unable to fetch data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);

    final fileName = Path.basename(filetodisplay!.path);
    final destination = 'files/$filename';
    var task = DataStorage.uploadFile(destination, filetodisplay!);
    if (task == null) return;

    fetchUsers();
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await DataStorage().savefiles(filetittle.text, description.text,
        urlDownload, date.toString(), name, selectedoption);
    final snackBar = SnackBar(
      content: Center(
        child: Text('Saved successfully'),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    /*
    Fluttertoast.showToast(
        msg: "Saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
        */
    Navigator.pop(context);
    filetittle.clear();
    description.clear();
  }

  Future<void> saveFromEdge() async {
    if (filetittle.text.isEmpty) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'title is empty',
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
          msg: "title is null",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
*/
      return;
    }
    if (description.text.isEmpty) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'description is empty',
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
          msg: "description is null",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
*/
      return;
    }
    if (filetodisplay == null) {
      print("null file");
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'null picture',
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
          msg: "null picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
*/
      return;
    }

    Fluttertoast.showToast(
        msg: "Unable to fetch data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);

    final fileName = Path.basename(filetodisplay!.path);
    final destination = 'files/$fileName';

    var uploadTask = DataStorage.uploadFile(destination, filetodisplay!);
    if (uploadTask == null) return;
    fetchUsers();

    // Wait for the upload task to complete
    final snapshot = await uploadTask.whenComplete(() {});

    // Get the download URL of the uploaded document
    final urlDownload = await snapshot.ref.getDownloadURL();

    // Extract other data needed for saving to Firestore
    final tittleText = filetittle.text ?? '';
    final descriptionText = description.text ?? '';

    // Save the document details to Firestore
    await DataStorage().savefiles(tittleText, descriptionText, urlDownload,
        date.toString(), name, selectedoption);
    print("clicked");
    final snackBar = SnackBar(
      content: Center(
        child: Text('Saved successfully'),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    /*
    Fluttertoast.showToast(
        msg: "Saved successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
        */
    Navigator.pop(context);
    // Clear input fields or perform any necessary UI updates here
    filetittle.clear();
    description.clear();
  }

  fetchUsers() async {
    Map<String, dynamic> result = await UserCollection().getUsersDetails();
    if (result == null) {
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
        userDetails = result;
        name = userDetails['Name'];
      });
    }
  }

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
        if (!itemsList.contains(selectedoption)) {
          // If the selected option is not present in the fetched items, reset it
          selectedoption = itemsList.isNotEmpty ? itemsList[0].folder : "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Add Document",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 40,
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            tittle(
              tittletext: "Document Title",
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: texinput(
                obsecure: false,
                controller: filetittle,
              ),
            ),
            tittle(
              tittletext: "Description",
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: texinput(
                obsecure: false,
                controller: description,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: DropdownButtonFormField(
                items: itemsList
                    .map<DropdownMenuItem<String>>((FolderModel folder) {
                  return DropdownMenuItem<String>(
                    value: folder.folder,
                    child: Text(folder.folder),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedoption = newValue!;
                  });
                },
                value: selectedoption,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.4),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    pickfile();
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.green],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Choose File",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    getImagecam();
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.green],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Edge Detection",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (pickedfile != null)
              Text(filename!)
            else
              Text("No file selected"),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonssave(text: "Save", tapAction: uploadfile),
                // buttonssave(text: "Save edge", tapAction: saveFromEdge),
                buttonscancle(
                  text: "Cancel",
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class tittle extends StatelessWidget {
  const tittle({
    super.key,
    this.tittletext,
  });
  final tittletext;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            tittletext,
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
