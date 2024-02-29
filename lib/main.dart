import 'dart:async';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/navigation.dart';
import 'package:restaurant_app_api/data/db/database_helper.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';
import 'package:restaurant_app_api/provider/restaurant_list_provider.dart';
import 'package:restaurant_app_api/provider/scheduling_provider.dart';
import 'package:restaurant_app_api/ui/home_page.dart';
import 'package:restaurant_app_api/ui/splahscreen.dart';
import 'package:restaurant_app_api/utils/background_service.dart';
import 'package:restaurant_app_api/utils/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  
  _service.initializeIsolate();
  
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp(
    flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
  ));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MyApp({required this.flutterLocalNotificationsPlugin});

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final DatabaseProvider databaseProvider =
        DatabaseProvider(databaseHelper: databaseHelper);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantListProvider()),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()), // Added
        ChangeNotifierProvider.value(
          value: databaseProvider,
        ),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          hintColor: Colors.yellow,
          fontFamily: 'Roboto',
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          HomePage.routeName: (context) => HomePage(),
        },
        navigatorKey: navigatorKey,
      ),
    );
  }
}
