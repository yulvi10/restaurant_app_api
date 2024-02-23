import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/model/restaurant_search_list.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:connectivity/connectivity.dart';

class CardRestaurantSearch extends StatelessWidget {
  final Restaurant restaurant;

  const CardRestaurantSearch({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: Card(
        color: Colors.white,
        child: ListTile(
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
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFBBB00),
                    ),
                    child: Text(
                      '${restaurant.rating}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
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
            final hasInternet = await _checkInternet();
            if (hasInternet) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetailPage(restaurantId: restaurant.id),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No Internet Connection'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
