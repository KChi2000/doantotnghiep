import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  //keys
  static String userLoggedInKey = 'LOGGEDINKEY';
  static String userNameKey = 'LOGGEDINKEY';
  static String userEmailKey = 'LOGGEDINKEY';
  static Future<bool?> getUserLoggedInStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }  
}