import 'package:flutter/material.dart';

import '../constant.dart';
import '../model/User.dart';

class infoItem extends StatelessWidget {
   infoItem({
    required this.title,
    required this.value
  });
  String title;
  String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: screenwidth,
      child: Row(
        children: [
           SizedBox(
            width: 100,
             child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
                     ),
           ),
          // SizedBox(width: 25,),
          Text(
            value,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
