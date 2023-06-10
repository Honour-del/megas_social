

import 'package:flutter/material.dart';



  push(BuildContext context, Widget page){
   Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  popcontext(BuildContext context){
    Navigator.pop(context);
  }

  pushAndRemove(BuildContext context, Widget page){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => page), (route) => false);
  }

  pushreplacement(BuildContext context, Widget page){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }






class BouncyPageRoute extends PageRouteBuilder{
  final Widget widget;

  BouncyPageRoute({ required
  this.widget}): super(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context,Animation<double> animation,Animation<double>  secAnimation, Widget child){
        animation = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return ScaleTransition(scale: animation,
          alignment: Alignment.center,
          child: child,
        );
      },
      pageBuilder: (BuildContext context,Animation<double> animation,Animation<double>  secAnimation ){
        return widget;
      }
  );
}