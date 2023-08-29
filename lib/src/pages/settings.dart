import 'package:dms/src/pages/loginpage.dart';
import 'package:dms/src/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../database/User_repository.dart';
import '../services/auth_sevices.dart';
import '../widgets/nav_bar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AuthenticationServices _authenticationServices = AuthenticationServices();
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  fetchUsers() async {
    Map<String, dynamic>? result = await UserCollection().getUsersDetails();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 60,
          ),
          top_nav(
            tittle: "SETTINGS",
          ),
          IconButton(
            onPressed: () async {
              await _authenticationServices.SignOut().then((result) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => loginpage()));
              });
            },
            icon: Icon(Icons.logout, size: 35),
          ),
          Text("Sign Out",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
          SizedBox(height: 20),
          Expanded(
            child: userDetails != null
                ? ListTile(
                    title: Text(userDetails!['Name'] ?? ''),
                    subtitle: Text(userDetails!['Email'] ?? ''),
                  )
                : Container(
                    height: 10,
                    width: 10,
                    child: Center(child: CircularProgressIndicator())),
          ),
        ],
      ),
    );
  }
}
