import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  //keys
  static String userLoggedInKey = 'USERLOGGEDUID';
  static String userNameKey = 'LOGGEDINKEY';
  static String userEmailKey = 'LOGGEDINKEY';
  static String userPicKey = 'PICKEY';
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
   static Future<bool?> saveUserPic(String link)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userPicKey, link);
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
   static Future<String?> getUserPic()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userPicKey);
  }  
}