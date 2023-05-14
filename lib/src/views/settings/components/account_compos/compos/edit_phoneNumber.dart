import 'package:flutter/material.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';



class PhoneSetting extends StatefulWidget {

  PhoneSetting({Key? key}) : super(key: key);
  @override
  _PhoneSettState createState() => _PhoneSettState();
}

class _PhoneSettState extends State<PhoneSetting> {
  // Users user;
  bool passwordValid = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _currentPass = TextEditingController();
  TextEditingController _newPass = TextEditingController();
  // TextEditingController _confirmNewPass = TextEditingController();
  // final TextStyle stx = GoogleFonts.convergence(color: BLACK_COLOR, fontWeight: FontWeight.bold);
  // final TextStyle stxU = GoogleFonts.convergence(color: DARK_RED, fontWeight: FontWeight.bold);
  // final TextStyle stxS = GoogleFonts.convergence(color: BLACK_COLOR, fontWeight: FontWeight.bold, fontSize: 30);

  @override
  void initState() {
    super.initState();

  }


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
    //   // ignore: deprecated_member_use
    //   _scaffoldKey.currentState.showSnackBar(snackbar);
    // }
  }

  textC(){
    return Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        children: [
          Text("Current Phone", style: TextStyle(color: Colors.black),),
          TextField(
            controller: _currentPass,
            decoration: InputDecoration(
              labelText: "Current phone number",
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
          Text("New Phone", style: TextStyle(color: Colors.black),),
          TextField(
            controller: _newPass,
            decoration: InputDecoration(
              labelText: "New phone number",
            ),
          )
        ],
      ),
    );
  }





  //go to forgot password page
  onPressed(){
   // Navigator.of(context).push(BouncyPageRoute(widget: ForgetPasswordPage()));
  }

  passReset(){
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(context, 'Change Number', false, true ),
      body: Container(
        child: SingleChildScrollView(child:
        Column(
          children: [
            textC(),
            textN(),
            FlatButton(onTap: (){}, label: "Update Number"),
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
