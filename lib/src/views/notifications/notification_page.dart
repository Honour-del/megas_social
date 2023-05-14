import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megas/app_main.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/custom_widgets/app_bar.dart';
// import 'package:megas/src/controllers/notification.dart';
import 'package:megas/src/services/notification/notification_impl.dart';
import 'package:megas/src/views/notifications/components/notification_card.dart';
import 'package:megas/src/views/settings/header_widget.dart';



enum myEnum{New, Old}


class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    // final notification = ref.watch(notificationProvider);
    final notificationStream = ref.watch(streamNotification.stream);
    return Scaffold(
      appBar: appBar(context, "Notifications", false, false),
      body: RefreshIndicator(
        onRefresh: ()async{
          await ref.refresh(streamNotification.stream);
        },
        child: StreamBuilder(
          stream: notificationStream,
            builder: (context, snapshot){
            if(!snapshot.hasData){
              return kProgressIndicator;
            }if(snapshot.data!.isEmpty){
              print("pushing empty notification");
              KNotificationController.createNewNotification(
                title: "element.name",
                body: "element.body",
                bigPicture: "element.avatarUrl",
              );
              print("pushed empty notification");
              return Center(child: Text('No notifications yet'),);
            }
            final now = DateTime.now();
            final newNotifications = snapshot.data?.where((n) => now.difference(n.timeAt).inHours <= 24).toList();
            final oldNotifications = snapshot.data?.where((n) => now.difference(n.timeAt).inHours > 24).toList();
            snapshot.data?.forEach((element) {
              KNotificationController.createNewNotification(
                title: element.name,
                body: element.body,
                bigPicture: element.avatarUrl,
              );
              print("pushing notification");
            });
            print("notification pushed");
            return Column(
              children: [
                HeaderWidget('New'),
                ...newNotifications!.map((e) => NotificationCard(note: e,)).toList(),

                HeaderWidget('Old'),
                ...oldNotifications!.map((e) => NotificationCard(note: e,)).toList(),
              ],
            );
          }
        ),
      ),
    );
  }
}




// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key,});
//
//   @override
//   State<NotificationPage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<NotificationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(context, "Notifications", false, false),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Push the buttons below to create new notifications',
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(width: 20),
//                   FloatingActionButton(
//                     heroTag: '1',
//                     onPressed: () => KNotificationController.createNewNotification(),
//                     tooltip: 'Create New notification',
//                     child: const Icon(Icons.outgoing_mail),
//                   ),
//                   const SizedBox(width: 10),
//                   FloatingActionButton(
//                     heroTag: '2',
//                     onPressed: () => KNotificationController.scheduleNewNotification(),
//                     tooltip: 'Schedule New notification',
//                     child: const Icon(Icons.access_time_outlined),
//                   ),
//                   const SizedBox(width: 10),
//                   FloatingActionButton(
//                     heroTag: '3',
//                     onPressed: () => KNotificationController.resetBadgeCounter(),
//                     tooltip: 'Reset badge counter',
//                     child: const Icon(Icons.exposure_zero),
//                   ),
//                   const SizedBox(width: 10),
//                   FloatingActionButton(
//                     heroTag: '4',
//                     onPressed: () => KNotificationController.cancelNotifications(),
//                     tooltip: 'Cancel all notifications',
//                     child: const Icon(Icons.delete_forever),
//                   ),
//                 ],
//               ),
//             ), // This trailing comma makes auto-formatting nicer for build methods.
//           ],
//         ),
//       ),
//     );
//   }
// }















//
//
// class Notifications extends StatefulWidget {
//   const Notifications({Key? key}) : super(key: key);
//
//   @override
//   _NotificationsState createState() => _NotificationsState();
// }
//
// class _NotificationsState extends State<Notifications> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: appBar(context, 'Notification', false, true ),
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Flexible(
//               fit: FlexFit.loose,
//               child: SizedBox(
//                 height: getProportionateScreenHeight(93),
//               )),
//           Padding(
//             padding: EdgeInsets.only(
//               left: getProportionateScreenWidth(9),
//               right: getProportionateScreenWidth(9),
//             ),
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                   horizontal: getProportionateScreenWidth(18.0)),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Flexible(
//                       fit: FlexFit.loose,
//                       child: SizedBox(
//                         height: getProportionateScreenHeight(49),
//                       )),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const Text("Pop up"),
//                       SizedBox(width: getProportionateScreenWidth(25.0)),
//                       const Text("Email"),
//                     ],
//                   ),
//                   const CustomDivider(),
//                   Column(
//                       children: List.generate(
//                           3,
//                               (index) => Column(children: [
//                             NotificationTile(
//                                 index: index),
//                             const CustomDivider(),
//                           ]))),
//                   Flexible(
//                       fit: FlexFit.loose,
//                       child: SizedBox(
//                         height: getProportionateScreenHeight(75),
//                       )),
//                   FlatButton(label: "Save", onTap: () { },),
//                   SizedBox(
//                     height: getProportionateScreenHeight(50.0),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NotificationTile extends StatefulWidget {
//   const NotificationTile({
//     Key? key,
//
//     this.index,
//   }) : super(key: key);
//   final int? index;
//
//   @override
//   _NotificationTileState createState() => _NotificationTileState();
// }
//
// class _NotificationTileState extends State<NotificationTile> {
//   List<bool> popUpTapped = [false, false, false];
//   List<bool> emailTapped = [false, false, false];
//   List<String> label = [
//     "Invoice status",
//     "Invoice reminder",
//     "Payment Status"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
//       child: Row(children: [
//         Text(label[widget.index!], style: TextStyle(fontSize: getFontSize(18))),
//         const Spacer(),
//         InkWell(
//           onTap: () {
//             setState(() {
//               popUpTapped[widget.index!] = !popUpTapped[widget.index!];
//             });
//           },
//           child: Image.asset(
//             "assets/images/popup.png",
//             color: popUpTapped[widget.index!] ? primary_color : null,
//           ),
//         ),
//         SizedBox(width: getProportionateScreenWidth(40.0)),
//         InkWell(
//           onTap: () {
//             setState(() {
//               emailTapped[widget.index!] = !emailTapped[widget.index!];
//             });
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: emailTapped[widget.index!] ? primary_color : Colors.white,
//               shape: BoxShape.circle,
//             ),
//             child: Image.asset(
//               "assets/images/email.png",
//               color: emailTapped[widget.index!] ? Colors.white : null,
//             ),
//           ),
//         ),
//       ],),);
//   }
// }
//
//
// class CustomDivider extends StatelessWidget {
//   const CustomDivider({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.only(
//             left: getProportionateScreenWidth(10),
//             top: getProportionateScreenHeight(0),
//             right: getProportionateScreenWidth(10)),
//         child: const Divider());
//   }
// }


