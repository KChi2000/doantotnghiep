import 'package:flutter/material.dart';

class itemEditProfile extends StatelessWidget {
  String title;
  Icon icon;
  VoidCallback ontap;
   itemEditProfile({
    Key? key,required this.title,required this.icon,required this.ontap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          icon,
          SizedBox(width: 10,),
          Text(title,style: TextStyle(fontSize: 16),),
        ],
      ),
    );
  }
}