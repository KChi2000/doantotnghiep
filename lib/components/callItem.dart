import 'package:doantotnghiep/components/itemImage.dart';
import 'package:flutter/material.dart';

import '../model/Message.dart';
import '../model/User.dart';

Widget callItem(List<Message> list, List<Userinfo> listUser,int index, IconData icon, context) {
  return UnconstrainedBox(
    alignment: Userinfo.userSingleton.uid ==
            list[index].sender.toString().substring(
                  list[index].sender.toString().length - 28,
                )
        ? Alignment.topRight
        : Alignment.topLeft,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 5,),
        Userinfo.userSingleton.uid ==
                list[index].sender.toString().substring(
                      list[index].sender.toString().length - 28,
                    )
            ? SizedBox()
            : itemImage(list[index].sender, listUser,context),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Userinfo.userSingleton.uid ==
                    list[index].sender.toString().substring(
                          list[index].sender.toString().length - 28,
                        )
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 3),
                    child: Text(
                        '${list[index].sender.toString().substring(0, list[index].sender.toString().length - 29)}'),
                  ),
            Container(
              width: 200,
              margin: Userinfo.userSingleton.uid ==
                      list[index].sender.toString().substring(
                            list[index].sender.toString().length - 28,
                          )
                  ? EdgeInsets.only(right: 15, bottom: 15)
                  : EdgeInsets.only(left: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.pink,
                      child: Icon(
                        icon,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  list[index].contentMessage == 'Cuộc gọi video đã kết thúc' ||
                          list[index].contentMessage ==
                              'Cuộc gọi audio đã kết thúc'
                      ? Flexible(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${list[index].contentMessage}',
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'robotobold',
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: '\nLúc ${list[index].displaytime}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'roboto',
                                    color: Colors.black),
                              )
                            ]),
                          ),
                        )
                      : Flexible(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: Userinfo.userSingleton.uid ==
                                        list[index].sender.toString().substring(
                                              list[index]
                                                      .sender
                                                      .toString()
                                                      .length -
                                                  28,
                                            )
                                    ? 'Bạn${list[index].contentMessage}'
                                    : '${list[index].sender.toString().substring(0, list[index].sender.toString().length - 29)} ${list[index].contentMessage}',
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'robotobold',
                                    color: Colors.black),
                              ),
                              TextSpan(
                                text: '\nLúc ${list[index].displaytime}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'roboto',
                                    color: Colors.black),
                              )
                            ]),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
