import 'package:dms/src/database/User_repository.dart';
import 'package:dms/src/model/usermodel.dart';
import 'package:dms/src/pages/loginpage.dart';
import 'package:dms/src/services/auth_sevices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../widgets/buttons.dart';
import '../widgets/text.dart';
import 'add_document.dart';
import 'package:dms/src/database/User_repository.dart';

class adduser extends StatefulWidget {
  const adduser({Key? key}) : super(key: key);
  @override
  State<adduser> createState() => _adduserState();
}

class _adduserState extends State<adduser> {
  String selectedoption = "Admin";
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();

  final AuthenticationServices auth = AuthenticationServices();
  void registerUser() async {
    String name = namecontroller.text;
    String mobile = mobilecontroller.text;

    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    if (name.isEmpty) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'the name is empty',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    } else if (mobile.isEmpty || mobile.length != 8) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'mobile number is empty or not 8 digits',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    } else if (!(email.isEmail) || email.isEmpty) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'the email is empty or email not contains @ ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    } else if (password.isEmpty) {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'password is empty',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }
    String userid = await auth.registerUser(
        name, mobile, selectedoption, email, password);
    if (userid.isNotEmpty) {
      print("User registered successfully");
      final snackBar = SnackBar(
        content: Center(
          child: Text('User registered successfully'),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(context,
                    MaterialPageRoute(builder: (context) => loginpage()));
    } else {
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'user registration failed',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Add User",
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
                tittletext: "Name",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: texinput(
                  obsecure: false,
                  controller: namecontroller,
                ),
              ),
              tittle(
                tittletext: "Mobile Number",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: texinput(
                  obsecure: false,
                  controller: mobilecontroller,
                ),
              ),
              tittle(
                tittletext: "Email",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: texinput(
                  obsecure: false,
                  controller: emailcontroller,
                ),
              ),
              tittle(
                tittletext: "Password",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: texinput(
                  obsecure: true,
                  controller: passwordcontroller,
                ),
              ),
              tittle(
                tittletext: "Confirm Password",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: texinput(
                  obsecure: true,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                child: DropdownButtonFormField(
                  items: <String>['Admin', 'It', 'guest']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newvalue) {
                    selectedoption = newvalue!;
                  },
                  value: selectedoption,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2)),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.4),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buttonssave(
                    text: "Save",
                    tapAction: registerUser,
                  ),
                  buttonscancle(
                    text: "Cancel",
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
