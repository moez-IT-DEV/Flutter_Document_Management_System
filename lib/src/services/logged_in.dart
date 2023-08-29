import 'package:dms/src/pages/homepage.dart';
import 'package:dms/src/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckState extends StatefulWidget {
  const CheckState({Key? key}) : super(key: key);

   @override
  State<CheckState> createState() => _CheckStateState();
}

class _CheckStateState extends State<CheckState> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return allDocuments();
              }
              else{
                return loginpage();
              }
        }),
      ),
    );
  }
}

