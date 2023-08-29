import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms/src/model/foldermodel.dart';

import 'auth_sevices.dart';
class FolderCollection {
  AuthenticationServices auth = AuthenticationServices();
  final CollectionReference foldersCollection =
  FirebaseFirestore.instance.collection("Folders");

  Future<void> createFolderData(String folderName) async {
    try {
      await foldersCollection.add({
        'Folder': folderName,
      });
    } catch (e) {
      print('Error creating folder data: $e');
      // Handle error here, such as showing an error message.
    }
  }
  Future<List<FolderModel>> getFoldersList() async {
    List<FolderModel> folderList = [];

    try {
      QuerySnapshot querySnapshot = await foldersCollection.get();

      folderList = querySnapshot.docs.map((document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return FolderModel(folder: data['Folder'] ?? ''); // Handle the possibility of a null value
      }).toList();

      return folderList;
    } catch (e) {
      print('Error getting folders list: $e');
      // Handle error here, such as showing an error message.
      return [];
    }
  }

  Future<Map<String, dynamic>> getFolderDetails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Folders')
          .limit(1)
          .get();

      if (querySnapshot.docs.length > 0) {
        Map<String, dynamic> data =
        querySnapshot.docs[0].data() as Map<String, dynamic>;
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting folder details: $e');
      // Handle error here, such as showing an error message.
      return {};
    }
  }
  Future<void> deleteFolder(String title) async {
    try {
      QuerySnapshot querySnapshot = await foldersCollection
          .where('Folder', isEqualTo: title)
          .get();

      querySnapshot.docs.forEach((document) async {
        await document.reference.delete();
      });
    } catch (e) {
      print('Error deleting folder: $e');
      // Handle error here, such as showing an error message.
    }
  }
  Future<void> renameFolder(String oldTitle, String newTitle) async {
    try {
      // Update the folder title in the Firestore collection
      await foldersCollection
          .where('Folder', isEqualTo: oldTitle)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((document) {
          document.reference.update({'Folder': newTitle});
        });
      });

      // Fetch the updated list of folders
      await getFoldersList();
    } catch (e) {
      print('Error renaming folder: $e');
      // Handle error here, such as showing an error message.
    }
  }
}
