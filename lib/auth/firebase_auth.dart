import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  static final FirebaseAuth _auth=FirebaseAuth.instance;
  static User? get user => _auth.currentUser;


  static Future<bool> login(String email,String password) async{

   final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

   return credential.user!=null;
  }

  static Future<bool> register(String email,String password) async{

    final credential=await _auth.createUserWithEmailAndPassword(email: email, password: password);

    return credential.user!=null;
  }

  static Future<void> logOut()=>_auth.signOut();

  static Future<void> updateDisplayName(String name) =>
    _auth.currentUser!.updateDisplayName(name);

  static Future<void> updatePhotoUrl(String url) =>
      _auth.currentUser!.updatePhotoURL(url);

  static Future<void> updateEmail(String email) {
    return _auth.currentUser!.updateEmail(email);
  }

}