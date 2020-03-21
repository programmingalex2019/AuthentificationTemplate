
import 'dart:async';
import 'package:authentification/screens/email_signIn/email_signIn_model.dart';
import 'package:authentification/services/auth.dart';



class EmailSignInBloc {

  final Auth auth;
  EmailSignInBloc({this.auth});

  final StreamController<EmailSignInModel> _emailSignInStreamController = StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get emailSignInStream => _emailSignInStreamController.stream;

  void dispose() {

    _emailSignInStreamController.close();

  }


  EmailSignInModel _model = EmailSignInModel(); // initial model // last in stream
 
  void updateEmail(String email) => updateModel(email: email);
  void updatePassword(String password) => updateModel(password: password); // this is so no all model gets copied when textfields text changed

  void toggleFormType() {

    final formType = _model.formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register
            : EmailSignInFormType.signIn;

    // when using textediting controllers to reset text, reset the models email and password as well , otherwise wouldnt work
    updateModel(
        submitted: false,
        email: '',
        password: '',
        isLoading: false,
        formType: formType);
  }


  void updateModel({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,

  }) {

    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted
    );


    _emailSignInStreamController.add(_model); // update model and add it to the stream each time, -> new copy of the initial model

  }

  Future<void> submit() async {
    
    updateModel(submitted : true, isLoading: true);
      
    try {
      
      if (_model.formType == EmailSignInFormType.signIn) {
        // depending on formType - specific function will be ran
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.registerWithEmailAndPassword(_model.email, _model.password);
      }

    } catch (e) {
      updateModel(isLoading: false);
      rethrow; 
    } 
    
  }

}