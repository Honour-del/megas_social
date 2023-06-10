import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';



class EmailSett extends ConsumerStatefulWidget {

  EmailSett({Key? key}) : super(key: key);
  @override
  _EmailSettState createState() => _EmailSettState();
}

class _EmailSettState extends ConsumerState<EmailSett> {
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
      setState(() {
        _newPass.text.trim().length < 3 ||
            _newPass.text.isEmpty
            ? passwordValid = false
            : passwordValid = true;
      });

      if (passwordValid) {
        // usersReference.doc(widget.currentUserId).update({
        //   'displayName': _newPass.text,
        // });
        print(_newPass.text);
        showSnackBar(context, text: 'Profile updated!');
      }
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
        appBar: appBar(context, 'Change email', false, true, widget: SizedBox.shrink() ),
        body: Container(
          child: SingleChildScrollView(child:
          Column(
            children: [
              textC(),
              textN(),
              FlatButtonCustom(onTap: (){}, label: "Change email"),
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
