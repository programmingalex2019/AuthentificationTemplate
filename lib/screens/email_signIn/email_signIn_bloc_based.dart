import 'package:authentification/common_widgets/alert_dialog/platform_exception_alert_dialog.dart';
import 'package:authentification/screens/email_signIn/email_signIn_bloc.dart';
import 'package:authentification/screens/email_signIn/email_signIn_model.dart';
import 'package:authentification/services/auth.dart';
import 'package:authentification/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmailSignInFormBlocBased extends StatefulWidget
    with EmailAndPasswordValidationFunctionality {

  final EmailSignInBloc bloc;

  EmailSignInFormBlocBased({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
          builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc)),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController =
      TextEditingController(); // controlling the email of TextField
  final TextEditingController _passwordController =
      TextEditingController(); // controlling the password of TextField

  // Function to toggle the forms with enums
  _toggleForm(BuildContext context) {
    
    widget.bloc.toggleFormType();

    _emailController.clear(); // once switched form clear text in TextField
    _passwordController.clear(); // once switched form clear text in TextField
  }

  // functions to run sign or register functions from auth class
  Future<void> _submit() async {
    try {
      await widget.bloc.submit();

      Navigator.of(context)
          .pop(); // stream will take us to home page if user != null, hence close email screen with pop

    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: 'Opps', exception: e).show(context);
    }
  }


  @override
  void dispose() {
    _emailController.dispose(); // clearing up textController resources
    _passwordController.dispose(); // clearing up textController resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.emailSignInStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel _model = snapshot.data;
          return _buildContent(_model);
        });
  }

  Widget _buildContent(EmailSignInModel model) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.primaryButtonText),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.visiblePassword,
                autofocus: true,
                maxLines: 1,
                controller: _emailController,
                onChanged: (_email) =>
                    widget.bloc.updateEmail(_email), // everytime text changed update state
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'test@test.com',
                  errorText: model.showEmailErrorText, // if emtpy textField, and submitted clicked error text will be shown
                  enabled: model.isLoading ==
                      false, // when loading false , textField cant be used
                ),
              ),
              TextField(
                controller: _passwordController,
                onChanged: (_password) =>
                    widget.bloc.updatePassword(_password), // everytime text changed update state
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'test1234',
                  errorText: model.showPasswordErrorText, // if emtpy textField, and submitted clicked error text will be shown
                  enabled: model.isLoading ==
                      false, // when loading false , textField cant be used
                ),
              ),
              SizedBox(height: 16.0),
              RaisedButton(
                  onPressed: () => model.isLoading == false ? _submit() : null,
                  child: Text(
                      model.primaryButtonText)), // when loading true , button cant be used
              FlatButton(
                  onPressed: () =>
                      model.isLoading == false ? _toggleForm(context) : null,
                  child: Text(
                    model.secondartyButtonText,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[500]),
                  )), // when loading true , button cant be used
              SizedBox(height: 16.0),
              model.isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(), // depending on loading state , progressIndicator will be shown
            ],
          ),
        ),
      ),
    );
  }
}
