import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/restaurant_search_provider.dart';
import 'package:restaurant_app_api/widgets/card_restaurant_search.dart';

class RestaurantSearchListPage extends StatelessWidget {
  const RestaurantSearchListPage({Key? key}) : super(key: key);

  static const routeName = '/restaurant_search_list';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: SearchProvider(), // Menyediakan instance yang sudah ada
      child: Scaffold(
        body: SearchResults(),
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context);

    return Scaffold(
      body: SafeArea(
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
                      decoration: const InputDecoration(
                        hintText: 'Search for restaurants...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: (value) {
                        provider.searchData(value); // Panggil method searchData pada provider
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (provider.isLoading)
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
                        color: Color(0xFF410E82),
                      ),
                    ),
                  ],
                ),
              ),
            if (provider.isError)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Failed to load data",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF410E82),
                  ),
                ),
              ),
            if (!provider.isLoading &&
                !provider.isError &&
                provider.searchResults.isEmpty)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "The restaurant you're looking for was not found!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF410E82),
                  ),
                ),
              ),
            if (!provider.isLoading &&
                !provider.isError &&
                provider.searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    var restaurant = provider.searchResults[index];
                    return CardRestaurantSearch(restaurant: restaurant);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
