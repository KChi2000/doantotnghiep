import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  //keys
  static String userLoggedInKey = 'USERLOGGEDUID';
  static String userNameKey = 'LOGGEDINKEY';
  static String userEmailKey = 'LOGGEDINKEY';
  // static Future<bool?> getUserLoggedInStatus()async{
  //   SharedPreferences sf = await SharedPreferences.getInstance();
  //   return sf.getBool(userLoggedInKey);
  // }  
  static Future<bool?> saveLoggedUserUid(String uid)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userLoggedInKey, uid);
  }  
  static Future<bool?> saveLoggedUserName(String name)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, name);
  }  
  static Future<bool?> saveLoggedUserEmail(String email)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, email);
  }  
  static Future<bool?>deleteLoggedUserUid()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.remove(userLoggedInKey);
  }  
   static Future<String?> getLoggedUserUid()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userLoggedInKey);
  }  
    static Future<String?> getLoggedUserName()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }  
}