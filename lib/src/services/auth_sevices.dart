import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/src/database/User_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future loginuser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future registerUser(String name, String mobile, String role, String email,
      String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await UserCollection()
          .createUserData(name, role, mobile, email, result.user!.uid);
      return result.user!.uid;
    } catch (e) {
      print(e.toString());
    }
  }

  Future SignOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>?> getNameAndRole(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('Users').doc(userId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String name = data['Name'];
        String role = data['Role'];

        return {
          'name': name,
          'role': role,
        };
      } else {
        return null; // User document does not exist
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
