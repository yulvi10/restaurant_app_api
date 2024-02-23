import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_search_list.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Restaurant> _searchResults = [];
  bool _isLoading = false;
  bool _isError = false;

  List<Restaurant> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  Future<void> searchData(String query) async {
    _isLoading = true;
    _isError = false;
    notifyListeners();

    try {
      final result = await _apiService.searchRestaurant(query);
      _searchResults = result.restaurants;
    } catch (e) {
      _isError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
