import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/core/utils/constants/consts.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/buttons.dart';



class PhoneSetting extends ConsumerStatefulWidget {

  PhoneSetting({Key? key}) : super(key: key);
  @override
  _PhoneSettState createState() => _PhoneSettState();
}

class _PhoneSettState extends ConsumerState<PhoneSetting> {
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
    setState(() {
      _newPass.text.trim().length < 3 ||
          _newPass.text.isEmpty
          ? passwordValid = false
          : passwordValid = true;
    });

    if (passwordValid) {
      // TODO
      // usersReference.doc(widget.currentUserId).update({
      //   'displayName': _newPass.text,
      // });
      print(_newPass.text);
      // ignore: deprecated_member_use
      showSnackBar(context, text: 'Profile updated!');
    }
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


  passReset(){
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(context, 'Change Number', false, true, widget: SizedBox.shrink() ),
      body: Container(
        child: SingleChildScrollView(child:
        Column(
          children: [
            textC(),
            textN(),
            FlatButtonCustom(onTap: (){
              updateProfileData();
            }, label: "Update Number"),
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
