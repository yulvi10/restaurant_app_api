import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  late RestaurantList _restaurantList;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasInternet = true; 

  RestaurantList get restaurantList => _restaurantList;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasInternet => _hasInternet; 

  RestaurantListProvider() {
    _fetchRestaurantList();
  }

  Future<void> _fetchRestaurantList() async {
    try {
      _isLoading = true;
      notifyListeners();
      _restaurantList = await _apiService.restaurantList(); // Updated method name
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to fetch restaurant list: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryFetchList() {
    _hasError = false;
    _fetchRestaurantList();
  }
}
