import 'package:doantotnghiep/bloc/noticeCalling/notice_calling_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/screens/Chat/IncomingCall.dart';
import 'package:doantotnghiep/screens/Profile.dart';
import 'package:doantotnghiep/screens/Map.dart';
import 'package:doantotnghiep/screens/Chat/connectToFriend.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bloc/Changetab/changetab_cubit.dart';

class DisplayPage extends StatefulWidget {
  DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<Widget> listPage = [Tracking(), ConnectToFriend(), Profile()];
  late FirebaseMessaging firebaseMessaging;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inittial();
  }

  void inittial() async {
    firebaseMessaging = FirebaseMessaging.instance;
    NotificationSettings settings = await firebaseMessaging.requestPermission();
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted the permission ');
      await firebaseMessaging.getToken().then((value) => print(value));
      FirebaseMessaging.onMessage.listen((message) {
        print('Notification coming: ${message.notification!.body.toString()}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeCallingCubit, bool>(
      builder: (context, notice) {
        return Stack(
          children: [
            BlocConsumer<ChangetabCubit, ChangetabState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                    body: listPage.elementAt(state.index),
                    bottomNavigationBar: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 0.05),
                        ],
                      ),
                      child: BottomNavigationBar(
                        elevation: 10,
                        items: [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.map_outlined),
                            label: 'Map',
                            backgroundColor: Colors.red,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.chat),
                            label: 'Chat',
                            backgroundColor: Colors.green,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person),
                            label: 'Profile',
                            backgroundColor: Colors.green,
                          ),
                        ],
                        currentIndex: state.index,
                        // selectedItemColor: Colors.amber[800],
                        onTap: (value) {
                          context.read<ChangetabCubit>().change(value);
                        },
                      ),
                    ));
              },
            ),
          // notice?  noticeIfCalling():SizedBox()
          ],
        );
      },
    );
  }
}

class noticeIfCalling extends StatelessWidget {
  const noticeIfCalling({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: UnconstrainedBox(
        child: GestureDetector(
          onTap: () {
            navigatePush(context, IncomingCall());
          },
          child: Container(
            constraints: BoxConstraints(maxHeight: 110),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: screenwidth - 20,
            // height: 100,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          child: Text(
                            'A',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'robotomedium',
                                decoration: TextDecoration.none,
                                fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nhóm Abcs',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'robotomedium',
                                  decoration: TextDecoration.none,
                                  fontSize: 20),
                            ),
                            Text(
                              'đang có cuộc gọi video',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'roboto',
                                  decoration: TextDecoration.none,
                                  fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 60,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red,padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () {
                              FlutterRingtonePlayer.stop();
                               context.read<NoticeCallingCubit>().notificationCalling(false);
                            }, child: Text('TỪ CHỐI',style: TextStyle( fontFamily: 'robotomedium',color: Colors.white),)),
                            SizedBox(width: 15,),
                            ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green,padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () {}, child: Text('TRẢ LỜI',style: TextStyle( fontFamily: 'robotomedium',color: Colors.white),))
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
