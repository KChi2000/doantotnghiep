import 'package:doantotnghiep/bloc/ChangeMessageStatus/change_message_status_cubit.dart';
import 'package:doantotnghiep/bloc/Changetab/changetab_cubit.dart';
import 'package:doantotnghiep/bloc/GroupInfoCubit/group_info_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/JoinStatus/join_status_cubit.dart';
import 'package:doantotnghiep/bloc/MakeAVideoCall/make_a_video_call_cubit.dart';
import 'package:doantotnghiep/bloc/MessageCubit/message_cubit_cubit.dart';
import 'package:doantotnghiep/bloc/SendMessage/send_message_cubit.dart';
import 'package:doantotnghiep/bloc/checkCode.dart/check_code_cubit.dart';
import 'package:doantotnghiep/bloc/checkLogged/check_logged_cubit.dart';
import 'package:doantotnghiep/bloc/getChatMessage/get_chat_message_cubit.dart';
import 'package:doantotnghiep/bloc/getInviteId/get_invite_id_cubit.dart';
import 'package:doantotnghiep/bloc/getUserGroup/get_user_group_cubit.dart';
import 'dart:async';
import 'package:doantotnghiep/bloc/joinToGroup.dart/join_to_group_cubit.dart';
import 'package:doantotnghiep/bloc/login/login_cubit.dart';
import 'package:doantotnghiep/bloc/register/register_cubit.dart';
import 'package:doantotnghiep/bloc/showBoxInviteId/show_box_invite_id_cubit.dart';
import 'package:doantotnghiep/components/pickImage/pick_image_cubit.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:doantotnghiep/screens/DisplayPage.dart';
import 'package:doantotnghiep/screens/auth/Login.dart';
import 'package:doantotnghiep/screens/Tracking.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    checkUserLoggedIn();
    super.initState();
  }

  void checkUserLoggedIn() async {
    context.read<CheckLoggedCubit>().checkUserIsLogged();
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
      ],
      child: MaterialApp(
        localizationsDelegates: [
             GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [Locale('vi', 'VN')],
            locale: Locale('vi', 'VN'),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.pink,
        ),
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
