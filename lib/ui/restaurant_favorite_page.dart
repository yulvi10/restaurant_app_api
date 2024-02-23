import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/data/db/database_helper.dart';
import 'package:restaurant_app_api/provider/database_provider.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';
import 'package:restaurant_app_api/utils/result_state.dart';




class RestaurantFavoritePage extends StatelessWidget {
  static const routeName = '/restaurant_favorite';

  const RestaurantFavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Restaurants'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<DatabaseProvider>(
          builder: (context, provider, _) {
            if (provider.state == ResultState.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (provider.state == ResultState.hasData) {
              return ListView.builder(
                itemCount: provider.bookmarks.length,
                itemBuilder: (context, index) {
                  Restaurant? restaurant = provider.bookmarks[index];
                  return ListTile(
                    leading: Image.network(
                      'https://restaurant-api.dicoding.dev/images/medium/${restaurant!.pictureId}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(restaurant.id ?? ''),
                    // title: Text(restaurant.name ?? ''),
                    // subtitle: Text(restaurant.city ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        provider.removeBookmark(restaurant!.id);
                      },
                    ),
                    onTap: () {
                      // Implement navigation to restaurant detail page
                      // Navigator.pushNamed(
                      //   context,
                      //   RestaurantDetailPage.routeName,
                      //   arguments: restaurant.id,
                      // );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text(provider.message ?? ''),
              );
            }
          },
        ),
      ),
    );
  }
}
