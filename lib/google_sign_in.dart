import 'package:etraffic/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(context) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage())));

    notifyListeners();
  }

  Future logout() async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null && user.providerData[0].providerId == 'google.com') {
      await googleSignIn.disconnect();
    }
    FirebaseAuth.instance.signOut();
  }
}
