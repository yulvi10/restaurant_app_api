import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/db/database_helper.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';
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


  void addBookmark(String restaurantId) async {
    try {
      print(
          'Adding restaurant with ID: $restaurantId to bookmarks (Database provider process)...');
      // Panggil method restaurantDetail dari ApiService untuk mendapatkan detail restoran
      final RestaurantList restaurantList =
          await ApiService().restaurantList(); // Hapus argumen restaurant
      // Ambil restaurant pertama dari daftar restoran
      final Restaurant restaurant = restaurantList.restaurants.firstWhere(
          (element) => element.id == restaurantId,
          orElse: () => throw Exception(
              'Restaurant with ID $restaurantId not found')); // Filter restoran berdasarkan ID
      // Buat objek Restaurant baru dengan hanya menyimpan data yang diinginkan
      final bookmarkRestaurant = Restaurant(
        id: restaurant.id,
        name: restaurant.name,
        description: restaurant.description,
        city: restaurant.city,
        pictureId: restaurant.pictureId,
        rating: restaurant.rating,
      );
      // Simpan restaurant ke dalam database
      await databaseHelper.insertBookmark(bookmarkRestaurant);
      _getBookmarks();
      // print('Restaurant with ID: $restaurantId added to bookmarks successfully .');
      print('Restaurant added to bookmarks successfully .');
    } catch (e) {
      print(
          'Failed to add restaurant with ID: $restaurantId to bookmarks. (Database provider process)');
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
