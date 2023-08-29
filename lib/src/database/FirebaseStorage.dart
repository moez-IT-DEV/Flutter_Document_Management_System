import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataStorage {
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection("Files");
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> savefiles(String tittle, String description, String urlDownload,
      String date, String name, String folder) async {
    try {
      await dataCollection.add({
        'tittle': tittle,
        'description': description,
        'url': urlDownload,
        'date': date,
        'user': name,
        'folder': folder,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateFileField(
    String title,
    String fieldName,
    dynamic newValue,
  ) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Files')
          .where('tittle', isEqualTo: title)
          .get();

      querySnapshot.docs.forEach((document) async {
        await document.reference.update({
          'folder': newValue,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> copyFileField(
    String title,
    String description,
    String urlDownload,
    String datee,
    dynamic newValue,
    String name,
    String fieldName,
  ) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Files')
          .where('tittle', isEqualTo: title)
          .get();

      await Future.forEach(querySnapshot.docs,
          (DocumentSnapshot document) async {
        String newTitle = 'Copy ${document['tittle']}';
        await FirebaseFirestore.instance.collection('Files').add({
          'tittle': newTitle,
          'folder': newValue,
          'description': description,
          'url': urlDownload,
          'date': datee,
          'user': name,
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateFileTittle(String currentTittle, String newTittle,
      String currentDescription, String newDescription) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Files')
          .where('tittle', isEqualTo: currentTittle)
          .get();

      querySnapshot.docs.forEach((document) async {
        await document.reference.update({
          'tittle': newTittle,
          'description': newDescription,
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
