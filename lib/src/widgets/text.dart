import 'package:flutter/material.dart';

class texinput extends StatelessWidget {
  const texinput({Key? key, this.controller, this.hint, this.obsecure})
      : super(key: key);
  final controller;
  final hint;
  final obsecure;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obsecure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          fillColor: Color.fromARGB(139, 252, 252, 251),
          filled: true,
        ),
      ),
    );
  }
}

class searchinput extends StatelessWidget {
  const searchinput({Key? key, this.controller, this.hint, this.obsecure})
      : super(key: key);
  final controller;
  final hint;
  final obsecure;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        obscureText: obsecure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500)),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
      ),
    );
  }
}
/*
class textp extends StatelessWidget {
  const textp({Key? key, this.controller, this.hint, this.obsecure}) : super(key: key);
  final controller;
  final hint;
  final obsecure;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obsecure,
        decoration: InputDecoration(
           prefixIcon: Icon(Icons.lock),
                  suffixIcon: Icon(Icons.remove_red_eye),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          fillColor: Color.fromARGB(139, 252, 252, 251),
          filled: true,
        ),
      ),
    );
  }
}*/