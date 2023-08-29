import 'package:dms/src/pages/homepage.dart';
import 'package:dms/src/services/auth_sevices.dart';
import 'package:dms/src/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final _key = GlobalKey<FormState>();
  final AuthenticationServices _auth = AuthenticationServices();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController password = TextEditingController();
  void signInUser() async {
    dynamic authResult =
        await _auth.loginuser(emailcontroller.text, password.text);
    if (authResult == null) {
      emailcontroller.clear();
      password.clear();
      print('Sign in error. could not be able to login');
      final snackBar = SnackBar(
        content: Center(
          child: Text(
            'Sign in error. could not be able to login',
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
          msg: "Sign in error. could not be able to login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
          */
    } else {
      emailcontroller.clear();
      password.clear();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => allDocuments()));
      print(emailcontroller.text);
      final snackBar = SnackBar(
        content: Center(
          child: Text('Welcome to our platform Z-doc'),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  "assets/images/znet.png",
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Platform Z-doc",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Enter email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                // Add this variable to track password visibility

                TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText:
                      !isPasswordVisible, // Set obscureText based on password visibility
                  decoration: InputDecoration(
                    labelText: "Enter Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPasswordVisible =
                              !isPasswordVisible; // Toggle password visibility
                        });
                      },
                      child: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("Forget Password?"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.green],
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      signInUser();
                    },
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Icon(
                  Icons.fingerprint,
                  size: 60,
                  color: Colors.teal,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 30,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
