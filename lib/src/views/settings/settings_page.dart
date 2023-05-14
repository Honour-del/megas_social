import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:megas/app_main.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/list_tiles.dart';
import 'package:megas/src/views/profile/profile_page.dart';
import 'package:megas/src/views/settings/components/about.dart';
import 'package:megas/src/views/settings/components/accounts.dart';
import 'package:megas/src/views/settings/components/help.dart';
import 'package:megas/src/views/settings/components/invite_friends.dart';
import 'package:megas/src/views/settings/components/notifications.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Settings', false, true ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: getProportionateScreenHeight(3),),
            Tiles(title: "Accounts", subtitle: '', onTap: (){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                popcontext(context);
                push(context, const Accounts());
              });
            }, trailing: const Icon(Icons.arrow_forward_ios_rounded),),
            Tiles(title: "Notifications",
              subtitle: '',
              onTap: (){
              push(context, Notifications());
            }, trailing: const Icon(Icons.arrow_forward_ios_rounded),),
            Tiles(title: "Transactions", subtitle: '', onTap: (){}, trailing: const Icon(Icons.arrow_forward_ios_rounded),),
            Tiles(title: "About", subtitle: '', onTap: (){
              push(context, AboutScreen());
            }, trailing: const Icon(Icons.arrow_forward_ios_rounded),),
            Tiles(title: "Invite Friends", subtitle: '', onTap: (){
              push(context, InviteFriends());
            }, trailing: const Icon(Icons.arrow_forward_ios_rounded),),
          ],
        ),
      ),
    );
  }
}
