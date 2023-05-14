// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:megas/no';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:face_camera/face_camera.dart';
import 'package:megas/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_main.dart';
// import 'package:timeago/timeago.dart' as timeago;


final dateTime = DateTime.now();

// final String dateTime =
//     "${DateTime.now().hour}:${DateTime.now().minute}";

int? isViewed;
List<CameraDescription> cameras = [];
// late ObjectBox objectBox;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await KNotificationController.initializeLocalNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FaceCamera.intialize();
  cameras = await availableCameras();
  print('ProviderScope is initialized!');
  final sharePreferences = await SharedPreferences.getInstance();
  ////////onBoard
  isViewed = sharePreferences.getInt('onBoard');
  debugPrint('saved');
  runApp( const ProviderScope(child: MyApp()));
}

