

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
