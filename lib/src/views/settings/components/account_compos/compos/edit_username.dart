import 'package:flutter/material.dart';


// import 'package:megas_chat/pages/signup.dart';


class UsernameSett extends StatefulWidget {
  @override
  _UsernameSettState createState() => _UsernameSettState();
}


class _UsernameSettState extends State<UsernameSett> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("currentUser.username" + "is your username"),
        ),
      ),
    );
  }
}
