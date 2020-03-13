import 'package:authentification/common_widgets/alert_dialog/platform_exception_alert_dialog.dart';
import 'package:authentification/services/auth.dart';
import 'package:authentification/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum EmailSignInFormType { SignIn, Register } // enum to toggle sign or register forms

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidationFunctionality{

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController(); // controlling the email of TextField
  final TextEditingController _passwordController = TextEditingController(); // controlling the password of TextField

  String get _email => _emailController.text; // getter to access the email input
  String get _password => _passwordController.text; // getter to access the password input

  bool _submitted = false; // state of the submit button
  bool _loading = false; // state of loading after the submit
  

  EmailSignInFormType _formType = EmailSignInFormType.SignIn; // the default form type - signIn

  // Function to toggle the forms with enums
  _toggleForm(BuildContext context) {

    setState(() {
      _formType = _formType == EmailSignInFormType.SignIn ? EmailSignInFormType.Register : EmailSignInFormType.SignIn;
      _submitted = false; // reset to false to display the error text which works only with submitted false
    });

    _emailController.clear(); // once switched form clear text in TextField
    _passwordController.clear(); // once switched form clear text in TextField

  }

  // functions to run sign or register functions from auth class
  Future<void> _submit(BuildContext context) async {

    setState(() {
      _submitted = true; // later error text can be displayed if no text in the fields
      _loading = true; // circular progress indicator will be shown
    });

    final auth = Provider.of<Auth>(context, listen: false); // provider to acces auth class
    try {
      await Future.delayed(Duration(seconds: 1)); // simulating a loading for user
      if(_formType == EmailSignInFormType.SignIn) { // depending on formType - specific function will be ran 
        await auth.signInWithEmailAndPassword(_email, _password);
      }else {
        await auth.registerWithEmailAndPassword(_email, _password);
      }

      Navigator.of(context).pop(); // stream will take us to home page if user != null, hence close email screen with pop

    } on PlatformException catch(e){
      
      PlatformExceptionAlertDialog(title: 'Opps', exception: e).show(context);
      
    } finally {
      setState(() {
        _loading = false; // when all complete set back loading state so progressIndicator stops running
      });
    }

  }

  _updateState() {
    setState(() {}); // function to rebuild widget 
  }

  @override
  void dispose() {
    _emailController.dispose(); // clearing up textController resources
    _passwordController.dispose();// clearing up textController resources
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {

      // different text depending on formType
    final kAppBarText = _formType == EmailSignInFormType.SignIn ? 'Sign In' : 'Register';
    final kMessageIndicationText = _formType == EmailSignInFormType.SignIn ? 'Dont Have an Account?' : 'Already Have an Account?';
    final kSignButtonText = _formType == EmailSignInFormType.SignIn ? 'Sign In' : 'Register';

    // state variables comming from mixin that checks if emai/password are empty
    bool isnotValidEmail = widget.checkIfEmptyValidatorEmail.checkIfEmpty(_email);
    bool isnotValidPassword = widget.checkIfEmptyValidatorPassword.checkIfEmpty(_password);

    return Scaffold(
      appBar: AppBar(
        title: Text(kAppBarText),
      ),
      body: SingleChildScrollView( // scroll view so screen doesnt overload
              child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType:  TextInputType.visiblePassword,
                autofocus: true,
                maxLines: 1,
                controller: _emailController,
                onChanged: (_email) => _updateState(), // everytime text changed update state
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'test@test.com',
                  errorText: isnotValidEmail && _submitted ? widget.invalidEmailErrorText : null, // if emtpy textField, and submitted clicked error text will be shown
                  enabled: _loading == false, // when loading false , textField cant be used
                ),
              ),
              TextField(
                controller: _passwordController,
                onChanged: (_password) => _updateState(), // everytime text changed update state
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'test1234',
                  errorText: isnotValidPassword && _submitted ? widget.invalidPasswordErrorText : null, // if emtpy textField, and submitted clicked error text will be shown
                  enabled: _loading == false, // when loading false , textField cant be used
                ),
              ),
              SizedBox(height: 16.0),
              RaisedButton(onPressed: () => _loading == false ? _submit(context) : null, child: Text(kSignButtonText)), // when loading true , button cant be used
              FlatButton(onPressed: () => _loading == false ? _toggleForm(context) : null, child: Text(kMessageIndicationText, style: TextStyle(fontSize: 16.0, color: Colors.grey[500]),)), // when loading true , button cant be used
              SizedBox(height: 16.0), 
              _loading ? CircularProgressIndicator() : SizedBox(), // depending on loading state , progressIndicator will be shown
            ],
          ),
        ),
      ),
    );
  }
}
