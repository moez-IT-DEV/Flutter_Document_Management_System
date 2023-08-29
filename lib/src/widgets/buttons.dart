import 'package:dms/src/pages/add_document.dart';
import 'package:flutter/material.dart';

class buttons extends StatelessWidget {
  const buttons({Key? key, this.text, this.navigation}) : super(key: key);
  final text;
  final navigation;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navigation));
      },
      child: Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          color: Color(0xff1e72b0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class buttonssave extends StatelessWidget {
  const buttonssave({Key? key, this.text, required this.tapAction})
      : super(key: key);
  final text;
  final VoidCallback tapAction;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        tapAction();
      },
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 13,
            ),
            Icon(
              Icons.save_rounded,
              color: Colors.white,
              size: 25,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(
              text,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            )),
          ],
        ),
      ),
    );
  }
}

class buttonscancle extends StatelessWidget {
  const buttonscancle({Key? key, this.text}) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel,
              color: Colors.white,
              size: 25,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
