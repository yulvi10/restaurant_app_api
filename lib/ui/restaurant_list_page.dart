import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/restaurant_list_provider.dart';
import 'package:restaurant_app_api/provider/scheduling_provider.dart';
import 'package:restaurant_app_api/ui/no_internet_page.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:restaurant_app_api/ui/settings_page.dart';
import 'package:restaurant_app_api/utils/notification_helper.dart';
import 'package:restaurant_app_api/widgets/card_restaurant.dart';

class RestaurantListPage extends StatefulWidget {
  RestaurantListPage({Key? key}) : super(key: key);

  static const routeName = '/restaurant_list';

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  Widget build(BuildContext context) {
    final restaurantListProvider = Provider.of<RestaurantListProvider>(context);

    _notificationHelper
        .configureSelectNotificationSubject(RestaurantListPage.routeName);

    ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(),
      child: const SettingsPage(),
    );

    return Scaffold(
      body: restaurantListProvider.hasInternet
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: const Color(0xFFFBBB00),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
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
                            'Recommendation in your nearby',
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
                    child: Consumer<RestaurantListProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          if (provider.hasError) {
                            return Center(
                              child: Material(
                                child: Text(provider.errorMessage),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount:
                                  provider.restaurantList.restaurants.length,
                              itemBuilder: (context, index) {
                                var restaurant =
                                    provider.restaurantList.restaurants[index];
                                return CardRestaurant(restaurant: restaurant);
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          : NoInternetPage(onRetryPressed: () {
              restaurantListProvider.retryFetchList();
            }),
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
