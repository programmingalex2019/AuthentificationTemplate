import 'package:authentification/common_widgets/alert_dialog/platform_alert_dialog.dart';
import 'package:authentification/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {


   // sign out function that signs out user 

  Future<void> _signOut(BuildContext context) async {
    
      final auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut();
    

  }

  // function that make sure user wants to sign out and if yes then runs above function

  Future<void> _confirmSignOut(BuildContext context) async {
    
    // alert dialog that askf if sure or not 
    final confirmAlertDialog = await  PlatformAlertDialog(
        title: 'SignOut',
        content: 'Are you sure',
        defaultActionText: 'Yes',
        cancelActionText: 'No').show(context); // show will return true or false 

    // if bool from show function above return true, then user will be signed out and redirected to the signScreen page
    if(confirmAlertDialog == true) {
      _signOut(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
