import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dms/src/model/usermodel.dart';
import 'package:dms/src/services/auth_sevices.dart';

class UserCollection {
  AuthenticationServices auth = AuthenticationServices();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("Users");

  Future<void> createUserData(
      String name, String role, String mobile, String email, String uid) async {
    try {
      await usersCollection.add({
        'Name': name,
        'Role': role,
        'Number': mobile,
        'Email': email,
        'UId': uid
      });
    } catch (e) {
      print('Error creating user data: $e');
      // Handle error here, such as showing an error message.
    }
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      querySnapshot.docs.forEach((document) {
        itemsList.add(document.data());
      });

      return itemsList;
    } catch (e) {
      print('Error getting users list: $e');
      // Handle error here, such as showing an error message.
      return [];
    }
  }

  Future<Map<String, dynamic>> getUsersDetails() async {
    String uid = auth.getCurrentUser()!.uid;

    try {
      print(uid);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('UId', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.length > 0) {
        return querySnapshot.docs[0].data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting users list: $e');
      // Handle error here, such as showing an error message.
      return {};
    }
  }

  Future<void> deleteUsers(String uid) async {
    try {
      QuerySnapshot snapshot =
          await usersCollection.where('UId', isEqualTo: uid).get();
      List<DocumentSnapshot> documents = snapshot.docs;

      for (DocumentSnapshot document in documents) {
        await document.reference.delete();
      }
    } catch (e) {
      print('Error deleting user data: $e');
      // Handle error here, such as showing an error message.
    }
  }

  Future<void> updateUserData(String uid, UserModel updatedUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update(updatedUser.toJson());
    } catch (e) {
      print('Error updating user data: $e');
      // Handle error here, such as showing an error message.
    }
  }
}
