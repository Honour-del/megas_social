import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:megas/core/utils/constants/color_to_hex.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/list_tiles.dart';
import 'package:megas/src/views/settings/components/account_compos/account_information.dart';

import 'account_compos/change_password.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(context, 'Your account', false, true ),
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
                  "Your account",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      // fontFamily: "MISTRAL",
                      // fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),

                SizedBox(width: getProportionateScreenWidth(75),),
                SizedBox.shrink()
                // SizedBox(width: getProportionateScreenWidth(12),),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: getProportionateScreenHeight(30),),
            Tiles(title: "Account's information",
              subtitle: "Check and edit your account information",
              onTap: (){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // popcontext(context);
                push(context, Account());
              });
            }, trailing: const Icon(Icons.arrow_forward_ios_rounded),),
            Tiles(title: "Change password",
              subtitle: "Change your password",
              onTap: (){
                push(context, const ChangePassword());
            }, trailing: const Icon(Icons.arrow_forward_ios_rounded),),
          ],
        ),
      ),
    );
  }
}
