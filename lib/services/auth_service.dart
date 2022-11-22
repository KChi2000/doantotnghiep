import 'package:doantotnghiep/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  Future registerWithEmail(String fullName, String email, String pass) async {
    try {
    User user=  (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass)) as User;
    DatabaseService databaseService = DatabaseService(uid: user.uid);
    if(user !=null){
    await  databaseService.addUserData(fullName, email);
      return true;
    }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }
}
