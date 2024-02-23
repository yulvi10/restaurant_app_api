import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/db/database_helper.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';
import 'package:restaurant_app_api/utils/result_state.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';



class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getBookmarks();
  }

  late ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _bookmarks = [];
  List<Restaurant> get bookmarks => _bookmarks;

  Future<void> _getBookmarks() async {
    try {
      _bookmarks = await databaseHelper.getBookmarks();
      if (_bookmarks.isNotEmpty) {
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = 'Empty Data';
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
    }
    notifyListeners();
  }

  // void addBookmark(String restaurantId) async {
  //   try {
  //     await databaseHelper.insertBookmark(Restaurant.fromJson({'id': restaurantId}));
  //     _getBookmarks();
  //   } catch (e) {
  //     _state = ResultState.error;
  //     _message = 'Error: $e';
  //     notifyListeners();
  //   }
  // }

  void addBookmark(String restaurantId) async {
    try {
      print(
          'Adding restaurant with ID: $restaurantId to bookmarks (Database provider process)...'); // Menampilkan ID restoran yang akan ditambahkan ke bookmark di console
      await databaseHelper
          .insertBookmark(Restaurant.fromJson({'id': restaurantId}));
      _getBookmarks();
      print(
          'Restaurant with ID: $restaurantId added to bookmarks successfully .'); // Menampilkan pesan berhasil pada console
    } catch (e) {
      print(
          'Failed to add restaurant with ID: $restaurantId to bookmarks. (Database provider process)'); // Menampilkan pesan gagal pada console
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isBookmarked(String id) async {
    final bookmarkedRestaurant = await databaseHelper.getBookmarkById(id);
    return bookmarkedRestaurant.isNotEmpty;
  }

  Future<void> removeBookmark(String id) async {
    try {
      await databaseHelper.removeBookmark(id);
      await _getBookmarks(); // Memanggil _getBookmarks() setelah menghapus bookmark
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
