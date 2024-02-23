import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app_api/data/model/restaurant_search_list.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  // Endpoint untuk mendapatkan daftar restoran
  static const String _listUrl = 'list';

  // Endpoint untuk pencarian restoran
  static const String _searchUrl = 'search';

  Future<RestaurantList> restaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl$_listUrl"));
    if (response.statusCode == 200) {
      return RestaurantList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Restaurant List');
    }
  }

  Future<DetailRestaurant> restaurantDetail(String restaurantId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/detail/$restaurantId'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DetailRestaurant.fromJson(jsonData);
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<RestaurantSearch> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl$_searchUrl?q=$query'));
    if (response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to search restaurants');
    }
  }

  Future<void> addReview(String id, String name, String review) async {
    final url = Uri.parse('$_baseUrl/review');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    final body = json.encode({'id': id, 'name': name, 'review': review});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Review added successfully');
    } else {
      throw Exception('Failed to add review: ${response.statusCode}');
    }
  }
}
