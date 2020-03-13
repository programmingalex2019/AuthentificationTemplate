import 'package:authentification/common_widgets/custom_buttons/custom_raised_button.dart';
import 'package:flutter/material.dart';

class SocialMediaButton extends CustomRaisedButton {
  SocialMediaButton({
    @required String imageUrl,
    @required String text,
    Color color,
    Color textColor,
    Function onPressed,
  })  : assert(imageUrl != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imageUrl),
              )),
              Expanded(
                flex: 3,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 16.0),
                ),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
