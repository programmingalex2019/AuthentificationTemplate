

import 'package:authentification/services/auth.dart';
import 'package:authentification/services/validation.dart';
import 'package:flutter/cupertino.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModelChangeNotifier with EmailAndPasswordValidationFunctionality, ChangeNotifier{

  final Auth auth;


  String email;
  String password;
  EmailSignInFormType formType;
  bool submitted;
  bool isLoading;

 // default valuse for model that is first presented - initial value in the streamBuilder
  EmailSignInModelChangeNotifier(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false,
      @required this.auth});


  String get primaryButtonText {

    return formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
  }

  String get secondartyButtonText {

    return formType == EmailSignInFormType.signIn
        ? 'Need an account, Register'
        : 'Have an account? Sign in';

  }

  bool get canSubmit {

    return checkIfEmptyValidatorEmail.checkIfEmpty(email) &&
        checkIfEmptyValidatorPassword.checkIfEmpty(password) &&
        !isLoading;

  }

  String get showEmailErrorText  {

    bool showErrorText =  submitted && checkIfEmptyValidatorEmail.checkIfEmpty(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String get showPasswordErrorText  {

    bool showErrorText =  submitted && checkIfEmptyValidatorPassword.checkIfEmpty(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  Future<void> submit() async {
    
    updateWith(submitted : true, isLoading: true);
      
    try {
      
      if (this.formType == EmailSignInFormType.signIn) {
        // depending on formType - specific function will be ran
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.registerWithEmailAndPassword(this.email, this.password);
      }

    } catch (e) {
      updateWith(isLoading: false);
      rethrow; 
    } 
    
  }

  void toggleFormType() {

    final formType = this.formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register
            : EmailSignInFormType.signIn;

    // when using textediting controllers to reset text, reset the models email and password as well , otherwise wouldnt work
    updateWith(
        submitted: false,
        email: '',
        password: '',
        isLoading: false,
        formType: formType);
  }

  // method to create a copy of a model, rather than updating it
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {

    // the new copy 
    this.email = email ?? this.email; // if not provided keep the default one but still make a new copy of the model.
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.submitted = submitted ?? this.submitted;
    this.isLoading = isLoading ?? this.isLoading;

    notifyListeners();

  }
  
}
