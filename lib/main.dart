import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/data/db/database_helper.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';
import 'package:restaurant_app_api/provider/restaurant_list_provider.dart';
import 'package:restaurant_app_api/ui/home_page.dart';
import 'package:restaurant_app_api/ui/splahscreen.dart';

void main() {
  DatabaseHelper databaseHelper =
      DatabaseHelper(); // Membuat instance DatabaseHelper
  DatabaseProvider databaseProvider = DatabaseProvider(
      databaseHelper:
          databaseHelper); // Memberikan instance DatabaseHelper ke DatabaseProvider
  runApp(MyApp(
    databaseHelper: databaseHelper,
    databaseProvider: databaseProvider,
  ));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;
  final DatabaseProvider databaseProvider;

  const MyApp({
    required this.databaseHelper,
    required this.databaseProvider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantListProvider()),
        ChangeNotifierProvider.value(
          value: databaseProvider, // Menggunakan value provider untuk instance yang sudah dibuat sebelumnya
        ),
        // ChangeNotifierProvider(
        //   create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        // ),
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
      ),
    );
  }
}
