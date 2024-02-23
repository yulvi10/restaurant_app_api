// import 'package:flutter/material.dart';
// import 'package:restaurant_app_api/data/preferences/preferences_helper.dart';
// // import 'package:restaurant_app_api/style/styles.dart';

// class PreferencesProvider extends ChangeNotifier {
//   PreferencesHelper preferencesHelper;

//   PreferencesProvider({required this.preferencesHelper});

//   bool _isDarkTheme = false;
//   bool get isDarkTheme => _isDarkTheme;

//   bool _isDailyRestaurantActive = false;
//   bool get isDailyRestaurantActive => _isDailyRestaurantActive;

//   void _getTheme() async {
//     _isDarkTheme = await preferencesHelper.isDarkTheme;
//     notifyListeners();
//   }

//   void _getDailyRestaurantPreferences() async {
//     _isDailyRestaurantActive = await preferencesHelper.isRestaurantDailyActive;
//     notifyListeners();
//   }

//   void enableDarkTheme(bool value) {
//     preferencesHelper.setDarkTheme(value);
//     _getTheme();
//   }

//   void enableDailyRestaurant(bool value){
//     preferencesHelper.setDailyRestaurant(value);
//     _getDailyRestaurantPreferences();
//   }

//   // ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;
// }


