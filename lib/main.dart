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
import 'package:doantotnghiep/bloc/createGroup/create_group_cubit.dart';
import 'package:doantotnghiep/bloc/fetchImage/fetch_image_cubit.dart';
import 'package:doantotnghiep/bloc/fetchLocationToShow/fetch_location_to_show_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/bloc/getInviteId/get_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/getProfile/get_profile_cubit.dart';
import 'package:doantotnghiep/bloc/getUserGroup/get_user_group_cubit.dart';
import 'dart:async';
import 'package:doantotnghiep/bloc/joinToGroup.dart/join_to_group_cubit.dart';
import 'package:doantotnghiep/bloc/login/login_cubit.dart';
import 'package:doantotnghiep/bloc/register/register_cubit.dart';
import 'package:doantotnghiep/bloc/resetEmail/reset_email_cubit.dart';
import 'package:doantotnghiep/bloc/showBoxInviteId/show_box_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/toggleCM/toggle_cm_cubit.dart';

import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/screens/Chat/CallVideo.dart';

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
import 'package:uuid/uuid.dart';

import 'bloc/pickImage/pick_image_cubit.dart';
import 'model/User.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => CheckLoggedCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final Uuid _uuid;
  String? _currentUuid;

  late final FirebaseMessaging _firebaseMessaging;
  @override
  void initState() {
    // TODO: implement initState
    checkUserLoggedIn();

    WidgetsBinding.instance.addObserver(this);

    super.initState();
    listenerEvent();
  }

  void checkUserLoggedIn() async {
    context.read<CheckLoggedCubit>().checkUserIsLogged();
  }

  Future<void> listenerEvent() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      FlutterCallkitIncoming.onEvent.listen((event) {
        if (!mounted) return;
        switch (event!.event) {
          case Event.ACTION_CALL_INCOMING:
            // TODO: received an incoming call
            break;
          case Event.ACTION_CALL_START:
            // TODO: started an outgoing call
            // TODO: show screen calling in Flutter
            break;
          case Event.ACTION_CALL_ACCEPT:
            // TODO: accepted an incoming call
            // TODO: show screen calling in Flutter
            break;
          case Event.ACTION_CALL_DECLINE:
            // TODO: declined an incoming call
            break;
          case Event.ACTION_CALL_ENDED:
            // TODO: ended an incoming/outgoing call
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      ],
      child: MaterialApp(
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
        // onGenerateRoute: (settings) {
        //   final arguments = settings.arguments;
        //   switch(settings.name){
        //      case '/callScreen':
        //     if (arguments is String) {
        //       // the details page for one specific user
        //       return CallVideo(arguments);
        //     }
        //   }
        // },
        theme: ThemeData(
            // appBarTheme: AppBarTheme(color: Colors.pink),
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
            print('store id: ${state.uid}');
            print('store model name ${Userinfo.userSingleton.name}');
            print('store model name ${Userinfo.userSingleton.uid}');
            if (state.uid.isNotEmpty) {
              return DisplayPage();
            }
            return Login();
          },
        ),
      ),
    );
  }
}
