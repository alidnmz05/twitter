/*
*     -Login
*     -Register
*     -Logout
*     -Delete Account

 */

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //get instance of the auth
  final _auth = FirebaseAuth.instance;
  // get current user & uid
  User? getCurrentUser() => _auth.currentUser;

  String getCurrentUserUid() => _auth.currentUser!.uid;

  //login function
  Future<UserCredential> loginEmailPassword(String email, password) async {
    try {
      //attempt login
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    }

    //catch anny errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //register
  Future<UserCredential> registerEmailPassword(
      String email, password, name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
//logout
