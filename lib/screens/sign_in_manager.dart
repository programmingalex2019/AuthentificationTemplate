import 'dart:async';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/services/auth.dart';
import 'package:flutter/foundation.dart';

class SignInManager {

  
  SignInManager({@required this.auth, @required this.isLoading});
  
  final ValueNotifier<bool> isLoading;
  final Auth auth;

  Future<void> _signInWith(Future<User> Function() signInWithFunction) async {

    try {     
      isLoading.value = true;
      return await signInWithFunction();

    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<void> signInAnonymously() => _signInWith(auth.signInAnonymously);
  Future<void> signInWithGoogle() => _signInWith(auth.signInWithGoogle);
  Future<void> signInWithFacebook() =>  _signInWith(auth.signInWithFacebook);


}