import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';
class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60,),
          top_nav(tittle: "DOCUMENT CATEGORIES",),
          SizedBox(height: 20,),

        ],
      ),
    );
  }
}
