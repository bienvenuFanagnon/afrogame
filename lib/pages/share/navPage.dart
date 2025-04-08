

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void goToPage(BuildContext context, Widget destinationPage, {bool withReplace = false}) {
  int dureeAnimationFast = 100;

  withReplace
      ?Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: destinationPage,
          duration: Duration(milliseconds: dureeAnimationFast
          )
      )
  )
      :Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: destinationPage,
          duration: Duration(milliseconds: dureeAnimationFast))
  );

}
