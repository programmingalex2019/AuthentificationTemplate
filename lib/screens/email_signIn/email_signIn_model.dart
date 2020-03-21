

import 'package:authentification/services/validation.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidationFunctionality{

  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool submitted;
  final bool isLoading;

 // default valuse for model that is first presented - initial value in the streamBuilder
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.submitted = false,
      this.isLoading = false});


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

  // method to create a copy of a model, rather than updating it
  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {

    return EmailSignInModel( // the new copy 
        email: email ?? this.email, // if not provided keep the default one but still make a new copy of the model.
        password: password ?? this.password,
        formType: formType ?? this.formType,
        submitted: submitted ?? this.submitted,
        isLoading: isLoading ?? this.isLoading);
  }
}
