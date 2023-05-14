import 'package:flutter/material.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';



class EmailSett extends StatefulWidget {

  EmailSett({Key? key}) : super(key: key);
  @override
  _EmailSettState createState() => _EmailSettState();
}

class _EmailSettState extends State<EmailSett> {
  @override
  void initState() {
    super.initState();
  }

    bool passwordValid = true;
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController _currentPass = TextEditingController();
    TextEditingController _newPass = TextEditingController();
    // TextEditingController _confirmNewPass = TextEditingController();

    updateProfileData() {
      // setState(() {
      //   _newPass.text.trim().length < 3 ||
      //       _newPass.text.isEmpty
      //       ? passwordValid = false
      //       : passwordValid = true;
      // });
      //
      // if (passwordValid) {
      //   usersReference.doc(widget.currentUserId).update({
      //     'displayName': _newPass.text,
      //   });
      //   print(_newPass.text);
      //   SnackBar snackbar = SnackBar(content: Text('Profile updated !'));
      //   _scaffoldKey.currentState.showSnackBar(snackbar);
      // }
    }

    textC(){
      return Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Text("Current email", style: TextStyle(color: Colors.black),),
            TextField(
              controller: _currentPass,
              decoration: InputDecoration(
                labelText: "Current email",
              ),
            )
          ],
        ),
      );
    }

    textN(){
      return Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Text("New email", style: TextStyle(color: Colors.black),),
            TextField(
              controller: _newPass,
              decoration: InputDecoration(
                labelText: "New email",
              ),
            )
          ],
        ),
      );
    }





    passReset(){
      return Scaffold(
        key: _scaffoldKey,
        appBar: appBar(context, 'Change email', false, true ),
        body: Container(
          child: SingleChildScrollView(child:
          Column(
            children: [
              textC(),
              textN(),
              FlatButton(onTap: (){}, label: "Change email"),
            ],
          )
          ),
        ),
      );
    }
    @override
    Widget build(BuildContext context) {
      return passReset();
    }
}
