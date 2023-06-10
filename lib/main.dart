
// import 'package:megas/no';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:megas/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:megas/src/services/shared_prefernces.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_splash/flutter_native_splash.dart';
final dateTime = DateTime.now();


Future<void> _messageHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

// late MessageFromFirebaseHandling messageFromFirebaseHandling;


Future<void> _firebaseMessagingHandler(RemoteMessage message) async{
  // await Firebase.initializeApp();
}
//
AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
late FirebaseMessaging messaging;
 final instant = FirebaseMessaging.instance;

void notificationTapBackground(NotificationResponse notificationResponse){
  if(notificationResponse.input?.isNotEmpty ?? false){
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}

Preferences? preferences;
int? isViewed;
// List<CameraDescription> cameras = [];
// late ObjectBox objectBox;
String token_value = '';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  tz.initializeTimeZones();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
   messaging = instant;


  final fcmToken = await messaging.getToken().then((value) {
    token_value = value!;
  });
  preferences?.setFCMToken(fcmToken!);
  print(fcmToken);

   await messaging.requestPermission(
     alert: true,
     announcement: false,
     badge: true,
     carPlay: false,
     criticalAlert: false,
     provisional: false,
     sound: true,
   );
  //
  //

   // await messaging.subscribeToTopic('flutter_notification');
  //
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingHandler);
   if(!kIsWeb){
     channel = const AndroidNotificationChannel(
       'flutter_notification', //id
       'flutter_notification_title', // name
       importance: Importance.high,
       enableLights: true,
       enableVibration: true,
       showBadge: true,
       playSound: true,
     );

     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

     final android = AndroidInitializationSettings('@drawable/ic_launcher');

     final ios = DarwinInitializationSettings();
     final initSettings = InitializationSettings(
       android: android,
       iOS: ios
     );

     await flutterLocalNotificationsPlugin!.initialize(initSettings,
       onDidReceiveNotificationResponse: notificationTapBackground,
       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,);
     await messaging.setForegroundNotificationPresentationOptions(
       alert: true,
       badge: true,
       sound: true,
     );
   }
  final sharePreferences = await SharedPreferences.getInstance();
  ////////onBoard
  await FaceCamera.initialize();
  isViewed = sharePreferences.getInt('onBoard');
  // debugPrint('saved');
  runApp( const ProviderScope(child: MyApp()));
}




final fcmTokenProvider = ChangeNotifierProvider<FcmTokenProvider>((ref) {
  return FcmTokenProvider();
});
class FcmTokenProvider extends ChangeNotifier{
  String _token = '';
  String get token => _token;

  setToken(String value){
    _token = value;
    notifyListeners();
  }
}