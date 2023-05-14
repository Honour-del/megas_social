import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:megas/core/notifications_core/notifications_util.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
import 'package:megas/core/utils/custom_widgets/list_tiles.dart';
///  *********************************************
///     NOTIFICATION PAGE
///  *********************************************
///
class Notifications extends StatefulWidget {
  const Notifications({Key? key,
    // required this.receivedAction
  })
      : super(key: key);

  // final ReceivedAction receivedAction;

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool delayLEDTests = false;
  double _secondsToWakeUp = 5;
  double _secondsToCallCategory = 5;

  bool globalNotificationsAllowed = false;
  bool schedulesFullControl = false;
  bool isCriticalAlertsEnabled = false;
  bool isPreciseAlarmEnabled = false;
  bool isOverrideDnDEnabled = false;

  Map<NotificationPermission, bool> scheduleChannelPermissions = {};
  Map<NotificationPermission, bool> dangerousPermissionsStatus = {};

  List<NotificationPermission> channelPermissions = [
    NotificationPermission.Alert,
    NotificationPermission.Sound,
    NotificationPermission.Badge,
    NotificationPermission.Light,
    NotificationPermission.Vibration,
    NotificationPermission.CriticalAlert,
    NotificationPermission.FullScreenIntent
  ];

  List<NotificationPermission> dangerousPermissions = [
    NotificationPermission.CriticalAlert,
    NotificationPermission.OverrideDnD,
    NotificationPermission.PreciseAlarms,
  ];

  String packageName = 'me.carda.awesome_notifications_example';

  bool switchValue = false;
  @override

  Widget build(BuildContext context) {
    // bool hasLargeIcon = widget.receivedAction.largeIconImage != null;
    // bool hasBigPicture = widget.receivedAction.bigPictureImage != null;
    double bigPictureSize = MediaQuery.of(context).size.height * .4;
    // double largeIconSize =
    //     MediaQuery.of(context).size.height * (hasBigPicture ? .12 : .2);

    return Scaffold(
      appBar: appBar(context, "Notifications", false, false),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: ListView(
          children: [
            Tiles(title: "ON/OFF Push notifications", onTap: (){
              NotificationUtils.redirectToPermissionsPage();
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
          ],
        ),
      ),
    );
  }
}
