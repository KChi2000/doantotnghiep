import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/screens/auth/Login.dart';
import 'package:doantotnghiep/screens/Tracking.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var uidStored;
  @override
  void initState() {
    // TODO: implement initState
    checkUserLoggedIn();
    super.initState();
  }

  void checkUserLoggedIn() async {
    uidStored = await HelperFunctions.getLoggedUserUid();
    print(uidStored);
    if (uidStored != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.pink,
      ),
      home: uidStored != null ? Tracking() : Login(),
    );
  }
}
