//
// Platform  Firebase App Id
// web       1:33638021256:web:fe068a03a40aa4f629c73d
// android   1:33638021256:android:70edc62951f2913b29c73d
// ios       1:33638021256:ios:74e5c3be3688360c29c73d
// macos     1:33638021256:ios:74e5c3be3688360c29c73d

// server key
// AAAAB9T7eIg:APA91bFotrIsyxoJzFzTzmpX_L_o1Agl2h9Dm4Yu-vFwNup_xfSWbAclV4STkCzNgJkx5w9Od27krolfmfVRtYKhH2qIObb-NW9xwCNorDAlJQHOQKtKxHpmj5YZUPaWV98Ks08zIgqy

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:megas/core/utils/constants/size_config.dart';
import 'package:megas/core/utils/constants/uuid.dart';
import 'package:megas/main.dart';
import 'package:megas/src/services/notification/interface.dart';
import 'package:timezone/timezone.dart' as tz;

 /* a function to extract username from Full name */
String getUsername({
  required String id,
  required String name,
}){
  String username = '';
  if(name.length > 15){ // 15
    name = name.substring(0, 6);
  }
  name = name.split(' ')[0];
  id = id.substring(0, 4).toLowerCase();
  username = '@$name$id';
  return username;
}

scheduleNotification({
  body,
  time,
}){
  final id = uuid.hashCode;
  // var flutterLocalNotificationsPlugin;
  flutterLocalNotificationsPlugin?.zonedSchedule(
    id,
    "The time you set for your event's elapsed",
    "$body",
    tz.TZDateTime.from(time, tz.local),
    NotificationDetails(
      android: AndroidNotificationDetails(
          0.toString(),
          'Events notification',
          priority: Priority.high,
          importance: Importance.max,
          // sound: ,
          setAsGroupSummary: true,
          styleInformation: DefaultStyleInformation(true, true),
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          channelShowBadge: true,
          autoCancel: true,
          icon: '@drawable/ic_launcher'
      ),
      iOS: DarwinNotificationDetails(),
    ),
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
    payload: '',
  );
}

scheduledDate(){

}


String? message;
/// the description on the notification
String? handleNotification(TypeN? type, username) {
  switch (type) {
    case TypeN.Likes:
      message = '@$username likes your post';
      break;
    case TypeN.Comments:
      message = '@$username commented on your post';
      break;
    case TypeN.Follower:
      message = '@$username follows you';
      break;
    default:
      message = 'This notification is from @$username';
      break;
  }
  return null;
}
//
//
// extension ConvertNotification on String{
//   TypeN toEnum() {
//     switch (this) {
//       case 'follow':
//         return TypeN.Follower;
//       case 'likes':
//         return TypeN.Likes;
//       case 'comment':
//         return TypeN.Comments;
//       default:
//         return TypeN.Likes;
//     }
//   }
// }



class ErrorMessages{
  static String mapError(String error){
    switch(error){
      case 'weak-password':
        return 'Password too weak';
      case 'email-already-in-use':
        return 'Email is already in use';
      case 'invalid-credential':
        return 'Invalid user';
      case 'invalid-email':
        return 'Invalid email';
      case 'invalid-password':
        return 'Invalid Password';
      case 'network-request-failed':
        return 'No network, please check your connection';
      case 'user-not-found':
        return 'Invalid email / password';
      case 'user-not-verified':
        return 'Please verify email';
      default:
        return 'Unknown error';
    }
  }
}

void showToast(String? msg, FToast fToast,
    {Color toastColor = Colors.green,
      int seconds = 2,
      ToastGravity toastGravity = ToastGravity.BOTTOM,
      double fontSize = 20.0,
      Color bgColor = Colors.black54}) {

  if (msg != null) {
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: bgColor,
      ),
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: toastColor,
          fontSize: fontSize,
          fontFamily: 'Lora',
          letterSpacing: 1.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: toastGravity,
      toastDuration: Duration(seconds: seconds),
    );
  }
}


enum ChatMessageTypes {
  None,
  Text,
  Image,
  Video,
  Document,
  Audio,
  Location,
}

enum ImageProviderCategory {
  FileImage,
  ExactAssetImage,
  NetworkImage,
}

enum MessageHolderType {
  Me,
  ConnectedUsers,
}

enum GetFieldForImportantDataLocalDatabase {
  UserEmail,
  Token,
  ProfileImagePath,
  ProfileImageUrl,
  About,
  WallPaper,
  MobileNumber,
  Notification,
  AccountCreationDate,
  AccountCreationTime,
}

enum PreviousMessageColTypes {
  ActualMessage,
  MessageDate,
  MessageTime,
  MessageHolder,
  MessageType,
}

void showSnackBar(
    BuildContext context, {
      required String text,
    }) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 2,
    backgroundColor: Colors.white10,
    duration: const Duration(seconds: 3),
    margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(30.0),
        vertical: getProportionateScreenWidth(20.0)),
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: TextStyle(
          color: Colors.white,
          fontSize: getFontSize(16),
          fontWeight: FontWeight.w500),
    ),
  ));
}

enum StatusMediaTypes {
  TextActivity,
  ImageActivity,
}

List<String> eventType = [
  'Anniversary',
  'Announcement',
  'Birthday',
  'Concert',
  'Convention',
  'Examination',
  'Flight',
  'Holiday',
  'Movie/TV',
  'Party',
  'Religious',
  'Trip',
  'Others',
];

final Shader linearGradient = const LinearGradient(
  colors: <Color>[
    Color(0xffFEA831),
    Color(0xffEE197F),
  ],
).createShader(const Rect.fromLTWH(0.0, 0.0, 400.0, 50.0));

const outlineBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.all(
    Radius.circular(10.0),
  ),
);


// Center kProgressIndicator = const Center(
//   child: Padding(
//     padding: EdgeInsets.only(bottom: 8),
//     child: CircularProgressIndicator(
//       color: kOrange,
//     ),
//   ),
// );
