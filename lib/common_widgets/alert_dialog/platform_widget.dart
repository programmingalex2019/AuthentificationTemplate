import 'dart:io';
import 'package:flutter/material.dart';


// this abstract class actually checks if platform is android or ios, 
// functions that extended from it only make the functionality of the two functions ,
// the actuall buid runs from here
abstract class PlatformWidget extends StatelessWidget {

  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);


  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS) {
      return buildCupertinoWidget(context);
    }else {
      return buildMaterialWidget(context);
    }
  }
}