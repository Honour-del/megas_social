
import 'package:flutter/material.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/list_tiles.dart';
///  *********************************************
///     NOTIFICATION PAGE
///  *********************************************
class Notifications extends StatefulWidget {
  const Notifications({Key? key,
    // required this.receivedAction
  })
      : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  bool switchValue = false;
  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context, "Notifications", false, false, widget: SizedBox.shrink()),
      body: Tiles(title: "ON/OFF Push notifications", onTap: (){
        // NotificationUtils.redirectToPermissionsPage();
      },
        trailing: Switch(
            value: switchValue,
            onChanged: (value){
              setState(() {
                switchValue = value;
              });
            },
        ),
      ),
    );
  }
}
