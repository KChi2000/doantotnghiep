import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';

import 'package:doantotnghiep/bloc/getNumberInformation/get_number_information_cubit.dart';
import 'package:doantotnghiep/bloc/noticeCalling/notice_calling_cubit.dart';
import 'package:doantotnghiep/components/navigate.dart';
import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/main.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/model/User.dart';
import 'package:doantotnghiep/screens/Chat/IncomingCall.dart';
import 'package:doantotnghiep/screens/Chat/SearchGroup.dart';
import 'package:doantotnghiep/screens/Chat/chatDetail.dart';
import 'package:doantotnghiep/screens/Profile.dart';
import 'package:doantotnghiep/screens/Map.dart';
import 'package:doantotnghiep/screens/Chat/connectToFriend.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../bloc/Changetab/changetab_cubit.dart';
import '../bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import '../bloc/getPicGroupMember/check_can_display_notification_cubit.dart';
import '../bloc/getUserGroup/get_user_group_cubit.dart';
import '../helper/location_notofications.dart';
import 'Chat/CallAudio.dart';
import 'Chat/CallVideo.dart';

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
    super.initState();
    listenerEvent(context);
    inittial();
    messageFireBase();
    context.read<GetUserGroupCubit>().getUerGroup();
    FirebaseMessaging.instance.getToken().then(
      (token) {
        if (token != Userinfo.userSingleton.registrationId) {
          DatabaseService(uid: Userinfo.userSingleton.uid)
              .updateRegistrationId(token!);
        }
      },
    );
  }

  messageFireBase() {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      print(
          'FB message when app terminated:\n${value?.notification?.title} ${value?.notification?.body}');
      if (value != null) {
        navigatorKey.currentState!.context.read<ChangetabCubit>().change(1);
        GroupInfo groupdata = GroupInfo.fromMap(value.data['group']);
        print('data got: ${groupdata.groupName}');
        navigatePush(
            navigatorKey.currentState!.context, chatDetail(group: groupdata));
      }
    });
    FirebaseMessaging.onMessage.listen((value) {
      if (mounted) {
        print(
            'FB message in foreground: can display notification: ${context.read<CheckCanDisplayNotificationCubit>().state}\n${value.notification!.title} ${value.notification!.body}');
        LocalNotificationService.showNotificationOnForeground(value);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((value) async {
      if (value != null) {
        print(
            'FB message in background: ${value.notification!.title} ${value.data['group']}');
        navigatorKey.currentState!.context.read<ChangetabCubit>().change(1);

        GroupInfo groupdata = GroupInfo.fromMap(value.data['group']);
        print('data got: ${groupdata.groupName}');
        navigatePush(
            navigatorKey.currentState!.context, chatDetail(group: groupdata));
      }
    });
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
            BlocBuilder<ChangetabCubit, ChangetabState>(
              builder: (context, changeTab) {
                return Scaffold(
                    body: listPage.elementAt(changeTab.index),
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
                            icon: Badge(
                              child: Icon(Icons.chat),
                              backgroundColor: Color.fromARGB(255, 244, 25, 9),
                              label: BlocBuilder<GroupInfoCubitCubit,
                                  GroupInfoCubitState>(
                                builder: (context, state) {
                                  if (state is GroupInfoCubitLoaded) {
                                    context
                                        .read<GetNumberInformationCubit>()
                                        .getNumberOfNotification(
                                            state.groupinfo!);
                                    return BlocBuilder<
                                        GetNumberInformationCubit,
                                        GetNumberInformationState>(
                                      builder: (context, state) {
                                        FlutterAppBadger.updateBadgeCount(
                                            state.number);
                                        return Text(
                                          '${state.number}',
                                          style: TextStyle(color: Colors.white),
                                        );
                                      },
                                    );
                                  }
                                  return Text(
                                    '0',
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            label: 'Chat',
                            backgroundColor: Colors.green,
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person),
                            label: 'Profile',
                            backgroundColor: Colors.green,
                          ),
                        ],
                        currentIndex: changeTab.index,
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

  Future<void> listenerEvent(context) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        if (!mounted) return;
        switch (event!.event) {
          case Event.ACTION_CALL_INCOMING:
            print('ACTION_CALL_INCOMING');
            break;
          case Event.ACTION_CALL_START:
            Map<String, dynamic> data = event.body;
            print('ACTION_CALL_START ${data}');
            await FlutterCallkitIncoming.showCallkitIncoming(CallKitParams(
                id: data['id'],
                nameCaller: data['nameCaller'],
                avatar: data['avatar'],
                handle: data['number'],
                duration: 30000,
                textAccept: data['textAccept'],
                textDecline: data['textDecline'],
                textMissedCall: data['textMissedCall'],
                textCallback: data['textCallback'],
                android: AndroidParams(
                    isCustomNotification: true,
                    isCustomSmallExNotification: false,
                    isShowMissedCallNotification: true,
                    ringtonePath: 'system_ringtone_default',
                    backgroundColor: '#0955fa',
                    actionColor: '#4CAF50')));
            print('ACTION_CALL_END ${data}');
            break;
          case Event.ACTION_CALL_ACCEPT:
            print(
                'ACTION_CALL_ACCEPT ${(event.body as Map<String, dynamic>)['id'].toString().substring(5)}');
            (event.body as Map<String, dynamic>)['id']
                        .toString()
                        .substring(0, 5) ==
                    'video'
                ? Future.delayed(Duration.zero, () {
                    navigatePush(
                        context,
                        CallVideo(
                          groupid: (event.body as Map<String, dynamic>)['id']
                              .toString()
                              .substring(5),
                          grname: (event.body
                              as Map<String, dynamic>)['nameCaller'],
                          answere: true,
                        ));
                  })
                : Future.delayed(Duration.zero, () {
                    navigatePush(
                        context,
                        CallAudio(
                          groupid: (event.body as Map<String, dynamic>)['id']
                              .toString()
                              .substring(5),
                          grname: (event.body
                              as Map<String, dynamic>)['nameCaller'],
                          answere: true,
                        ));
                  });

            break;
          case Event.ACTION_CALL_DECLINE:
            print('ACTION_CALL_DECLINE');
            break;
          case Event.ACTION_CALL_ENDED:
            print('ACTION_CALL_ENDED');
            break;
          case Event.ACTION_CALL_TIMEOUT:
            // TODO: missed an incoming call
            break;
          case Event.ACTION_CALL_CALLBACK:
            // TODO: only Android - click action `Call back` from missed call notification
            break;
          case Event.ACTION_CALL_TOGGLE_HOLD:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_MUTE:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_DMTF:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_GROUP:
            // TODO: only iOS
            break;
          case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
            // TODO: only iOS
            break;
        }
      });
    } on Exception {}
  }
}

Callparam(String grid, String grname, String typeOfcall) {
  return CallKitParams(
    id: '$typeOfcall$grid',
    nameCaller: 'Nhóm $grname',
    appName: 'Cùng Phượt',
    avatar: 'assets/images/Cùng Phượt.png',
    handle: 'đang gọi $typeOfcall',
    type: 0,
    duration: 30000,
    textAccept: 'Trả lời',
    textDecline: 'Từ chối',
    textMissedCall: 'Cuộc gọi nhỡ',
    textCallback: 'Gọi lại',
    extra: <String, dynamic>{'userId': '${Userinfo.userSingleton.uid}'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: AndroidParams(
      isCustomNotification: true,
      // isShowLogo: true,
      isShowCallback: true,
      isShowMissedCallNotification: true,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      actionColor: '#4CAF50',
    ),
    ios: IOSParams(
      iconName: 'Cùng Phượt',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
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
                color: Colors.grey, borderRadius: BorderRadius.circular(15)),
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
                        SizedBox(
                          width: 60,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () {
                              FlutterRingtonePlayer.stop();
                              context
                                  .read<NoticeCallingCubit>()
                                  .notificationCalling(false);
                            },
                            child: Text(
                              'TỪ CHỐI',
                              style: TextStyle(
                                  fontFamily: 'robotomedium',
                                  color: Colors.white),
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () {},
                            child: Text(
                              'TRẢ LỜI',
                              style: TextStyle(
                                  fontFamily: 'robotomedium',
                                  color: Colors.white),
                            ))
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
