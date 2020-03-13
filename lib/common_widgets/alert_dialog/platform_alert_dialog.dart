import 'dart:io';

import 'package:authentification/common_widgets/alert_dialog/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class that will be the alertDialog depending on the platform hence extends platform widget
class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;

  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.defaultActionText,
      this.cancelActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  // show function that runs rott show functions , eight ios or android
  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this, // this means that this class will be run // probbably (lol)
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => this);
  }

 // the build methods for each differrent platform
 
  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context), // the buttons that will be displayed on the alert dialog
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {

    final actions = <Widget>[];
    if (cancelActionText != null) { // since cancel action text is not required, if it will be used then an action will be added to the alert dialog
      actions.add(PlatformAlertDialogAction(
          child: Text(cancelActionText),
          callBack: () {
            Navigator.pop(context, false); // the bool will return the value hence can be used
          }));
    }

    actions.add(PlatformAlertDialogAction( // this will be the default action, hence default action text is requied
        child: Text(defaultActionText),
        callBack: () {
          Navigator.pop(context, true);
        }));

    return actions;
  }
}

// the class is the actual action , meaning a button in this case
class PlatformAlertDialogAction extends PlatformWidget {
  final Widget child;
  final Function callBack;

  PlatformAlertDialogAction({this.child,this.callBack});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(child: child, onPressed: callBack);
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(onPressed: callBack, child: child);
  }
}
