import 'package:authentification/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {

  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> registerWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  User getUserFromFirebase(FirebaseUser firebaseUser);
  Stream<User> get userAuthState;
}

class Auth implements AuthBase {

  FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  User getUserFromFirebase(FirebaseUser firebaseUser) {
    if (firebaseUser == null) {
      return null;
    } else {
      return User(uid: firebaseUser.uid);
    }
  }


  @override
  Future<User> signInAnonymously() async {

    
    final AuthResult authResult = await _auth.signInAnonymously();
    return getUserFromFirebase(authResult.user);

    
  }

  @override
  Future<User> signInWithGoogle() async {
    
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null) {

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      if(googleSignInAuthentication.accessToken != null && googleSignInAuthentication.idToken != null) {

        final AuthCredential authCredential = GoogleAuthProvider.getCredential
        (idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

        final AuthResult authResult = await _auth.signInWithCredential(authCredential);
        final FirebaseUser firebaseUser = authResult.user;
        return getUserFromFirebase(firebaseUser);

      }else {
        throw PlatformException(code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'ERROR MISSING GOOGLE AUTH TOKEN');
      }

    }else {
      throw PlatformException(code: 'ERROR_ABORTED_BY_USER',
      message: 'sign in was canceled');
    }
  
  }

  @override
  Future<User> signInWithFacebook() async{

    final FacebookLogin facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['public_profile']);

    if(result.accessToken != null) {
      
      final AuthResult authResult = await _auth.signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token
      ));
      return getUserFromFirebase(authResult.user);

    }else {
      throw PlatformException(code: 'ERROR_ABORTED_BY_USER',
      message: 'sign in was canceled');
    }
  }

  @override
  Future<User> registerWithEmailAndPassword(String email, String password) async {
    
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return getUserFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async{
    
    AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return getUserFromFirebase(authResult.user);
  }

  

  @override
  Stream<User> get userAuthState => _auth.onAuthStateChanged
      .map((FirebaseUser firebaseUser) => getUserFromFirebase(firebaseUser));

  @override
  Future<void> signOut() async {

    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    
    await _auth.signOut();
  }

  

  

  
}
