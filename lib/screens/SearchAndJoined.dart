import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchAndJoined extends StatelessWidget {
  SearchAndJoined({super.key});
  var codeCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tham gia bằng mã'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: TextButton(onPressed: () {}, child: Text('Tham gia')),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: codeCon,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: 'Ví dụ: e4fH5s'),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6)
                      ],
                      onChanged: (value) {
                        
                      },
                ),
              )
            ],
          )),
    );
  }
}
