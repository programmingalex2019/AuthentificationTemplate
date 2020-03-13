import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  final Widget child;
  final Color color;
  final double borderRadius;
  final Function onPressed;
  final double height;

  CustomRaisedButton(
      {this.child,
      this.color,
      this.borderRadius: 12.0,
      this.onPressed,
      this.height: 65.0}) : assert(borderRadius != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height,
        child: RaisedButton(
          onPressed: onPressed,
          elevation: 4.0,
          disabledColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          color: color,
          child: child,
        ),
      ),
    );
  }
}