
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/src/views/settings/components/account_compos/change_password.dart';
import 'package:megas/src/views/settings/components/account_compos/compos/event.dart';
import 'package:megas/src/views/settings/components/account_compos/compos/edit_email.dart';
import 'package:megas/src/views/settings/components/account_compos/compos/edit_phoneNumber.dart';

class Account extends StatefulWidget {

  Account({Key? key}) : super(key: key);
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String userName = '';
  String phoneNumber = '';
  String email = '';
  bool dataIsThere = false;

  @override
  void initState() {
    super.initState();
    //getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,////80
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: primary_color),
        // leading: Text('yes'),
        shadowColor: Colors.transparent,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              // top: 30,
                left: 12,
                right: 12
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){popcontext(context);}, icon: FaIcon(FontAwesomeIcons.arrowLeft, color: primary_color)),
                SizedBox(width: getProportionateScreenWidth(58),),
                Text(
                  "Account info",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      // fontFamily: "MISTRAL",
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),

                SizedBox(width: getProportionateScreenWidth(78),),
                SizedBox.shrink()
                // SizedBox(width: getProportionateScreenWidth(12),),
              ],
            ),
          ),
        ),
      ),
      body:  !dataIsThere == true ? Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Login and security", style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              color: Colors.black26,
            ),
            Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Phone",style:  Theme.of(context).textTheme.titleMedium,),
                      subtitle: Text("$phoneNumber",),
                      onTap: () => push(context, PhoneSetting()),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Email",style:  Theme.of(context).textTheme.titleMedium,),
                      subtitle: Text("$email",),
                      onTap: () => push(context, EmailSett()),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Password",style:  Theme.of(context).textTheme.titleMedium,),
                      subtitle: Text("*********"),
                      onTap: () => push(context, ChangePassword()),
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Event",style:  Theme.of(context).textTheme.titleMedium),
                      subtitle: Text("You can set reminder and keep other important things here",style:  Theme.of(context).textTheme.bodyMedium),
                      onTap: () => push(context, Events()),
                    ),
                    Divider(),
                  ],
                )
            ),
            SizedBox.shrink()
            // TextButton(onPressed: (){},
            //     child: Text("Delete Account")),
          ],
        ),
      ) : Center(child: kProgressIndicator,),
    );
  }
}