import 'package:test1/src/database/User_repository.dart';
import 'package:test1/src/pages/add_user.dart';
import 'package:test1/src/widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/nav_bar.dart';

class Userspage extends StatefulWidget {
  Userspage({Key? key}) : super(key: key);

  @override
  State<Userspage> createState() => _UserspageState();
}

class _UserspageState extends State<Userspage> {
  List<Map<String, dynamic>> itemsList = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  fetchUsers() async {
    dynamic result = await UserCollection().getUsersList();
    if (result == null) {
      print("Unable to fetch data");
      Fluttertoast.showToast(
        msg: "Unable to fetch data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        itemsList = List<Map<String, dynamic>>.from(result);
      });
    }
  }

  deleteUser(String uid) async {
    try {
      await UserCollection().deleteUsers(uid);

      Fluttertoast.showToast(
        msg: "User deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      fetchUsers(); // Refresh the user list after deletion
    } catch (e) {
      print('Error deleting user: $e');

      Fluttertoast.showToast(
        msg: "Failed to delete user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: 60),
        top_nav(tittle: "USERS"),
        SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 260),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => adduser()),
                  );
                },
                child: Text("Add User"),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              final user = itemsList[index];
              final name = user['Name'] ?? '';
              final email = user['Email'] ?? '';
              final role = user['Role'] ?? '';
              final uid = user['UId'] ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirmation"),
                          content: Text(
                              "Are you sure you want to delete this user?"),
                          actions: [
                            TextButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Yes"),
                              onPressed: () {
                                deleteUser(uid);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("User Name:"),
                            Expanded(child: Text(name)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Email:"),
                            Expanded(child: Text(email)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Role:"),
                            Expanded(child: Text(role)),
                          ],
                        ),
                        Icon(Icons.delete),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
