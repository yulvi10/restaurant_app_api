import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';
import 'package:restaurant_app_api/data/model/restaurant_list.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:restaurant_app_api/utils/result_state.dart';

class RestaurantFavoritePage extends StatelessWidget {
  static const routeName = '/restaurant_favorite';

  const RestaurantFavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                children: const [
                  Text(
                    'Restaurant',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF410E82),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFFBFBFB),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 0, left: 10.0, right: 10, top: 10),
                    child: Text(
                      'Your List Favorite Restaurants',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF410E82),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<DatabaseProvider>(
                builder: (context, databaseProvider, _) {
                  return _buildFavoriteRestaurantsList(databaseProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteRestaurantsList(DatabaseProvider databaseProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<DatabaseProvider>(
        builder: (context, provider, _) {
          if (provider.state == ResultState.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.hasData) {
            return ListView.builder(
              itemCount: provider.bookmarks.length,
              itemBuilder: (context, index) {
                Restaurant restaurant = provider.bookmarks[index];
                return _buildRestaurantItem(context, provider, restaurant);
              },
            );
          } else {
            return Center(
              child: Text(provider.message ?? ''),
            );
          }
        },
      ),
    );
  }

  Widget _buildRestaurantItem(
      BuildContext context, DatabaseProvider provider, Restaurant restaurant) {
    return Card(
      color: Colors.white,
      child: Stack(
        children: [
          ListTile(
            visualDensity: const VisualDensity(vertical: 4),
            leading: Hero(
              tag: restaurant.pictureId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF410E82),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    Text(
                      restaurant.city,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 2.0),
                Row(
                  children: [
                    for (var i = 0; i < restaurant.rating.toInt(); i++)
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFBBB00),
                        size: 16.0,
                      ),
                  ],
                ),
              ],
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetailPage(restaurantId: restaurant.id),
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            right: 15,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                provider.removeBookmark(restaurant.id ?? '');
                // Menampilkan Snackbar jika bookmark berhasil dihapus
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bookmark for ${restaurant.name} removed'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
