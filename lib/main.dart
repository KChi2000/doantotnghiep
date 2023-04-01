import 'dart:convert';

import 'package:doantotnghiep/bloc/ChangeMessageStatus/change_message_status_cubit.dart';
import 'package:doantotnghiep/bloc/Changetab/changetab_cubit.dart';
import 'package:doantotnghiep/bloc/FetchLocation/fetch_location_cubit.dart';
import 'package:doantotnghiep/bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/JoinStatus/join_status_cubit.dart';
import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/bloc/MessageCubit/message_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/SendMessage/send_message_cubit.dart';
import 'package:doantotnghiep/bloc/TimKiemGroup/tim_kiem_group_cubit.dart';
import 'package:doantotnghiep/bloc/canCreateGroup/can_create_group_cubit.dart';
import 'package:doantotnghiep/bloc/checkCode.dart/check_code_cubit.dart';
import 'package:doantotnghiep/bloc/checkLogged/check_logged_cubit.dart';
import 'package:doantotnghiep/bloc/countToBuild/count_to_build_cubit.dart';
import 'package:doantotnghiep/bloc/countToRebuild/count_to_rebuild_cubit.dart';
import 'package:doantotnghiep/bloc/createGroup/create_group_cubit.dart';
import 'package:doantotnghiep/bloc/fetchImage/fetch_image_cubit.dart';
import 'package:doantotnghiep/bloc/fetchLocationToShow/fetch_location_to_show_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/bloc/getInviteId/get_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/getNumberInformation/get_number_information_cubit.dart';
import 'package:doantotnghiep/bloc/getPicGroupMember/get_pic_group_member_cubit.dart';
import 'package:doantotnghiep/bloc/getProfile/get_profile_cubit.dart';
import 'package:doantotnghiep/bloc/getUserGroup/get_user_group_cubit.dart';
import 'dart:async';
import 'package:doantotnghiep/bloc/joinToGroup.dart/join_to_group_cubit.dart';
import 'package:doantotnghiep/bloc/login/login_cubit.dart';
import 'package:doantotnghiep/bloc/noticeCalling/notice_calling_cubit.dart';
import 'package:doantotnghiep/bloc/onHaveRemoteRender/on_have_remote_render_cubit.dart';
import 'package:doantotnghiep/bloc/pushNotification/push_notification_cubit.dart';
import 'package:doantotnghiep/bloc/register/register_cubit.dart';
import 'package:doantotnghiep/bloc/resetEmail/reset_email_cubit.dart';
import 'package:doantotnghiep/bloc/showBoxInviteId/show_box_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/toggleCM/toggle_cm_cubit.dart';

import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:doantotnghiep/model/Message.dart';
import 'package:doantotnghiep/screens/Chat/CallVideo.dart';
import 'package:doantotnghiep/screens/Chat/chatDetail.dart';

import 'package:doantotnghiep/screens/DisplayPage.dart';
import 'package:doantotnghiep/screens/auth/Login.dart';
import 'package:doantotnghiep/screens/Map.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

import 'NetworkProvider/Networkprovider.dart';
import 'bloc/getPicGroupMember/check_can_display_notification_cubit.dart';
import 'bloc/pickImage/pick_image_cubit.dart';
import 'components/navigate.dart';
import 'helper/location_notofications.dart';
import 'model/User.dart';
import 'screens/Chat/CallAudio.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  // GroupInfo group = GroupInfo.fromJson(message.data['data'] as Map<String,dynamic>);

  // print(
  //     'FB message from background: ${map}');
  Map<String, dynamic> map = message.data;
  var params = CallKitParams(
      id: '${map['groupId']}',
      nameCaller: 'Nhóm ${map['GroupName']}',
      avatar: 'xdsdfs',
      handle: 'đang gọi ${message.notification!.body}',
      duration: 30000,
      textAccept: 'TRẢ LỜI',
      textDecline: 'TỪ CHỐI',
      textMissedCall: 'Cuộc gọi nhỡ',
      textCallback: 'GỌI LẠI',
      android: AndroidParams(
          isCustomNotification: true,
          isCustomSmallExNotification: false,
          isShowMissedCallNotification: true,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          actionColor: '#4CAF50'));
  await FlutterCallkitIncoming.startCall(params);
  await FlutterCallkitIncoming.showCallkitIncoming(params);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  Stream<String> fcmStream = FirebaseMessaging.instance.onTokenRefresh;
  fcmStream.listen((token) {
    print('FBM token was changed and applied to the db');
    DatabaseService(uid: Userinfo.userSingleton.uid)
        .updateRegistrationId(token);
  });
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckLoggedCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (context) => CheckCodeCubit(),
        ),
        BlocProvider(
          create: (context) => JoindStatusCubit(),
        ),
        BlocProvider(
          create: (context) => JoinToGroupCubit(),
        ),
        BlocProvider(
          create: (context) => ShowBoxInviteIdCubit(),
        ),
        BlocProvider(
          create: (context) => GetInviteIdCubit(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => GetChatMessageCubit(),
        ),
        BlocProvider(
          create: (context) => GetUserGroupCubit(),
        ),
        BlocProvider(
          create: (context) => GroupInfoCubitCubit(),
        ),
        BlocProvider(
          create: (context) =>
              CountToBuildCubit(context.read<GroupInfoCubitCubit>()),
        ),
        BlocProvider(
          create: (context) => CountToRebuildCubit(),
        ),
        BlocProvider(
          create: (context) => MessageCubitCubit(),
        ),
        BlocProvider(
          create: (context) => ChangetabCubit(),
        ),
        BlocProvider(
          create: (context) => PickImageCubit(),
        ),
        BlocProvider(
          create: (context) => SendMessageCubit(),
        ),
        BlocProvider(
          create: (context) => ChangeMessageStatusCubit(),
        ),
        BlocProvider(
          create: (context) => MakeAVideoCallCubit(),
        ),
        BlocProvider(
          create: (context) => TimKiemGroupCubit(),
        ),
        BlocProvider(
          create: (context) => FetchLocationCubit(),
        ),
        BlocProvider(
          create: (context) => FetchLocationToShowCubit(),
        ),
        BlocProvider(
          create: (context) => GetPicGroupMemberCubit(),
        ),
        BlocProvider(
          create: (context) => GetProfileCubit(),
        ),
        BlocProvider(
          create: (context) => FetchImageCubit(),
        ),
        BlocProvider(
          create: (context) => ResetEmailCubit(),
        ),
        BlocProvider(
          create: (context) => ToggleCmCubit(),
        ),
        BlocProvider(
          create: (context) => CreateGroupCubit(),
        ),
        BlocProvider(
          create: (context) => CanCreateGroupCubit(),
        ),
        BlocProvider(
          create: (context) => OnHaveRemoteRenderCubit(),
        ),
        BlocProvider(
          create: (context) => NoticeCallingCubit(),
        ),
        BlocProvider(
          create: (context) => GetNumberInformationCubit(),
        ),
        BlocProvider(
          create: (context) => PushNotificationCubit(),
        ),
        BlocProvider(
          create: (context) => CheckCanDisplayNotificationCubit(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    checkUserLoggedIn();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void checkUserLoggedIn() async {
    context.read<CheckLoggedCubit>().checkUserIsLogged();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      // navigatorObservers: [routeObserver],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      color: Colors.pink,
      supportedLocales: [Locale('vi', 'VN')],
      locale: Locale('vi', 'VN'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Colors.pink,
              onPrimary: Colors.pink,
              secondary: Colors.white,
              onSecondary: Colors.black,
              error: Colors.pink,
              onError: Colors.pink,
              background: Colors.white,
              onBackground: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black),
          cardColor: Colors.pink,
          primaryColor: Colors.pink),
      home: BlocBuilder<CheckLoggedCubit, CheckLoggedState>(
        builder: (context, state) {
          if (state.uid.isNotEmpty) {
            return Stack(
              children: [
                BlocBuilder<GetUserGroupCubit, GetUserGroupState>(
                  builder: (context, state) {
                    return StreamBuilder<dynamic>(
                        stream: state.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            context
                                .read<GroupInfoCubitCubit>()
                                .updateGroup(snapshot.data);
                          }
                          return BlocListener<GroupInfoCubitCubit,
                              GroupInfoCubitState>(
                            listener: (context, state) {
                              if (state is GroupInfoCubitLoaded) {
                                state.groupinfo!.forEach((element) async {
                                  if (element.recentMessageSender
                                          .toString()
                                          .isNotEmpty &&
                                      element.recentMessageSender.toString() !=
                                          null) {
                                    if (element.callStatus == 'call end') {
                                      await FlutterCallkitIncoming.endCall(
                                          '${element.groupId}');
                                    }
                                  }
                                });
                              }
                            },
                            child: DisplayPage(),
                          );
                        });
                  },
                ),
              ],
            );
          }
          return Login();
        },
      ),
    );
  }
}
