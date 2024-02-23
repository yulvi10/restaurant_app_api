import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final String restaurantId;

  late DetailRestaurant _detailRestaurant;
  late List<CustomerReview> _customerReviews = [];
  late bool _isLoading;
  late bool _hasError;
  late String _errorMessage;

  DetailRestaurant get detailRestaurant => _detailRestaurant;
  List<CustomerReview> get customerReviews => _customerReviews;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  RestaurantDetailProvider(this.restaurantId) {
    _isLoading = true;
    _hasError = false;
    _errorMessage = '';
    _fetchRestaurantDetail();
  }

  Future<void> _fetchRestaurantDetail() async {
    try {
      _detailRestaurant = await _apiService.restaurantDetail(restaurantId);
      _customerReviews = _detailRestaurant.restaurant.customerReviews;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to fetch restaurant detail: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview(String name, String reviewText) async {
    try {
      await _apiService.addReview(restaurantId, name, reviewText);
      await _fetchRestaurantDetail(); // Refresh data after adding review
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}