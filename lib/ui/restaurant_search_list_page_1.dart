import 'package:flutter/material.dart'; // Import ApiService
import 'package:restaurant_app_api/widgets/card_restaurant_search.dart';
import 'package:restaurant_app_api/data/model/restaurant_search_list.dart'; // Import model untuk hasil pencarian
import 'package:restaurant_app_api/data/api/api_service.dart';

class RestaurantSearchListPage extends StatefulWidget {
  const RestaurantSearchListPage({Key? key}) : super(key: key);

  static const routeName = '/restaurant_search_list';

  @override
  _RestaurantSearchListPageState createState() =>
      _RestaurantSearchListPageState();
}

class _RestaurantSearchListPageState extends State<RestaurantSearchListPage> {
  TextEditingController _searchController = TextEditingController();
  List<Restaurant> _searchResults = [];
  bool _isLoading = false;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: const Color(0xFFFBBB00),
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Restaurant',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF410E82),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search for restaurants...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: (value) {
                          _searchData(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text(
                        "Finding restaurant for you. Please Wait..!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF410E82)),
                      ),
                    ],
                  ),
                ),
              if (_isError)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text("Failed to load data",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF410E82))),
                ),
              if (!_isLoading && !_isError && _searchResults.isEmpty)
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                      "The restaurant you're looking for was not found!",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF410E82))),
                ),
              if (!_isLoading && !_isError && _searchResults.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    var restaurant = _searchResults[index];
                    return CardRestaurantSearch(restaurant: restaurant);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchData(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isError = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    // Tambahkan indikator loading selama 5 detik
    await Future.delayed(Duration(seconds: 2));

    try {
      final result = await ApiService().searchRestaurant(query);
      setState(() {
        _searchResults = result.restaurants;
      });
    } catch (e) {
      setState(() {
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
