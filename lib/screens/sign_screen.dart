import 'package:authentification/common_widgets/alert_dialog/platform_alert_dialog.dart';
import 'package:authentification/common_widgets/custom_buttons/social_media_button.dart';
import 'package:authentification/screens/email_signIn/email_signIn_screen.dart';
import 'package:authentification/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignScreen extends StatelessWidget {


  // the function that sign anonymously , context passed in so in function can be used in build
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signInAnonymously();
      // when exception return a custom alert dialog depending on platform (ios-cupertino...)

    } on PlatformException catch (e) {
      PlatformAlertDialog(
        // the content in the alert dialog is raw, make sure to change them for better user experience
              title: 'Oops', content: e.message, defaultActionText: 'Ok')
          .show(context); // function that actually runs the alert dialog , and can return a bool
    }
  }

  // google sign in
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      PlatformAlertDialog(
              title: 'Oops', content: e.message, defaultActionText: 'Ok')
          .show(context);
    }
  }

  // facebook sign in
  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signInWithFacebook();
    } on PlatformException catch (e) {
      PlatformAlertDialog(
              title: 'Ops', content: e.message, defaultActionText: 'Ok')
          .show(context);
    }
  }

 // this directs to the signIn form to the other screen hence a Navigator has been used
  void _goToSignInForm(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EmailSignInForm()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SignScreen')),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // custom made buttons that extends the customRaisedButton class to inherite and add properties
              SocialMediaButton(
                imageUrl: 'images/anonym-logo.png',
                color: Colors.grey,
                textColor: Colors.white,
                onPressed: () => _signInAnonymously(context),
                text: 'Sign Anonymously',
              ),
              SocialMediaButton(
                imageUrl: 'images/google-logo.png',
                text: 'Sign In With Google',
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () => _signInWithGoogle(context),
              ),
              SocialMediaButton(
                imageUrl: 'images/facebook-logo.png',
                text: 'Sign In With Facebook',
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => _signInWithFacebook(context),
              ),
              SocialMediaButton(
                imageUrl: 'images/email-logo.png',
                color: Colors.pink[200],
                textColor: Colors.white,
                onPressed: () => _goToSignInForm(context),
                text: 'Sign with email',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
