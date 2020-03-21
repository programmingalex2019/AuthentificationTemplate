import 'dart:async';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/services/auth.dart';
import 'package:flutter/foundation.dart';

class SignInBloc {

  final Auth auth;
  SignInBloc({@required this.auth});

  final StreamController<bool> _streamController = StreamController<bool>();

  Stream<bool> get isLoadingStream  => _streamController.stream;

  void dispose()  => _streamController.close();

  void _updateStreamState(bool state)  =>  _streamController.add(state);

  Future<void> _signInWith(Future<User> Function() signInWithFunction) async {

    try {     
      _updateStreamState(true);
      return await signInWithFunction();

    } catch (e) {
      _updateStreamState(false);
      rethrow;
    }
  }

  Future<void> signInAnonymously() => _signInWith(auth.signInAnonymously);
  Future<void> signInWithGoogle() => _signInWith(auth.signInWithGoogle);
  Future<void> signInWithFacebook() =>  _signInWith(auth.signInWithFacebook);


}