import 'package:flutter/material.dart';

class top_nav extends StatelessWidget {
  const top_nav({
    super.key,
    this.tittle,
  });
  final tittle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.blue, Colors.green]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 90.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tittle,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
