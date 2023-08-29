
import 'package:flutter/material.dart';

class homepage_icons extends StatelessWidget {
  const homepage_icons({
    super.key, this.navigation, this.image, this.text,
  });
  final navigation;
  final image;
  final text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>navigation));
      },
      child: Expanded(
        child: Container(
          height: 160,
          width: 100,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                child: Image.asset(image,fit: BoxFit.fill,),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(text,style: TextStyle(fontSize: 18,color: Colors.black)))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
