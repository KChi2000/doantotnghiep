import 'package:doantotnghiep/constant.dart';
import 'package:flutter/material.dart';

class textfield extends StatelessWidget {
  textfield({
    Key? key,
    required this.hint,
    required this.label,
    required this.icon,
    required this.iconcolor,
    required this.emailCon,
    required this.error
  }) : super(key: key);

  TextEditingController emailCon;
  IconData icon;
  String hint;
  String label;
  Color iconcolor;
  String error;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: screenwidth - 100,
        child: TextFormField(
          controller: emailCon,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)),
              isDense: true,
              // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
              hintText: hint,
              label: Text(label),
              prefixIcon: Icon(
                icon,
                color: iconcolor,
              )),
              validator: (value) {
                if(value!.isEmpty || value==null){
                    return error;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
        ));
  }
}
