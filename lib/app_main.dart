
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:megas/core/utils/constants/navigator.dart';
import 'package:megas/core/utils/constants/regex.dart';
import 'package:megas/core/utils/constants/themes.dart';
import 'package:megas/src/services/auth/auths_impl.dart';
import 'package:megas/src/views/home/navigation.dart';
import 'package:megas/src/views/onBoarding/onBoardings.dart';
import 'package:megas/src/views/register/register_page.dart';
import 'main.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';



/* create  a function that sends new to notification to the server after every new activities */



class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
  static Color mainColor = const Color(0xFF9D50DD);
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // static const String routeHome = '/', routeNotification = '/notification-page';
// String token = '';

  @override
  void initState() {
    super.initState();
    // setupInteractedMessage();

    instant.getInitialMessage()
    .then((RemoteMessage? message) async{
      RemoteNotification? notification = message?.notification!;
      print(notification != null ? notification.title : '');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if(notification != null && android != null && !kIsWeb){
        String action = jsonEncode(message.data);

        flutterLocalNotificationsPlugin!.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              priority: Priority.high,
              importance: Importance.max,
              setAsGroupSummary: true,
              styleInformation: DefaultStyleInformation(true, true),
              largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
              channelShowBadge: true,
              autoCancel: true,
              icon: '@drawable/ic_launcher'
            ),
          ),
          payload: action,
        );
      }
      print('A new event was published');
    });

    FirebaseMessaging.onMessageOpenedApp
    .listen((message) => _handleMessage(message.data));
    FlutterNativeSplash.remove();
  }


  Future<dynamic> onSelectNotification(payload) async{
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  // Future<void> setupInteractedMessage() async {
  //   await FirebaseMessaging.instance.getInitialMessage()
  //       .then((value) => _handleMessage(value != null ? value.data : Map()));
  // }

  void _handleMessage(Map<String, dynamic> data){
    if(data['redirect'] == 'likes')
      push(context, Nav());
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fcmTokenProvider).setToken(token_value);
    });
    final notifier = ref.watch(themeNotifierProvider);
    print('token set: $token_value');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          navigatorKey: MyApp.mainNavigatorKey,
          scrollBehavior: const MaterialScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          themeMode: notifier,
          // home: isViewed != 0 ? const OnBoardingView() :  Register(),
          home: ref.watch(authProviderK).when(
              data: (user){
                // ref.watch(userDetailProvider).w
                if(user != null ){
                  return Nav();
                }
                return isViewed != 0 ? const OnBoardingView() :  Register();
              },
              error: (e, str) => CustomErrorWidget(err: e.toString(),),
              loading: ()=> kProgressIndicator),
        )
    );
  }
}



