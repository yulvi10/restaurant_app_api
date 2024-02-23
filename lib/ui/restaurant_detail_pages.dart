import 'package:flutter/material.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant_detail.dart';

class RestaurantDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String restaurantId;

  const RestaurantDetailPage({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Future<DetailRestaurant> _detailRestaurantFuture;
  late List<CustomerReview> _customerReviews = [];

  @override
  void initState() {
    super.initState();
    _detailRestaurantFuture = _fetchRestaurantDetail();
  }

  Future<DetailRestaurant> _fetchRestaurantDetail() async {
    final apiService = ApiService();
    return apiService.restaurantDetail(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DetailRestaurant>(
      future: _detailRestaurantFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final detailRestaurant = snapshot.data!;
          final restaurant = detailRestaurant.restaurant;
          _customerReviews = detailRestaurant.restaurant.customerReviews;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Hero(
                          tag: restaurant.pictureId,
                          child: Image.network(
                              'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}'),
                        ),
                        Positioned(
                          top: 16.0,
                          left: 16.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(190, 158, 158, 158),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        const Positioned(
                          top: 16.0,
                          right: 16.0,
                          child: FavoriteButton(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF410E82)),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.grey, size: 16.0),
                              const SizedBox(width: 5),
                              Text(restaurant.city),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              for (var i = 0; i < restaurant.rating; i++)
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFBBB00),
                                  size: 16.0,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            restaurant.description,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    // Display Food and Drink Items
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Menu:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Foods :',
                            style: TextStyle(
                                color: Color(0xFF410E82),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: restaurant.menus.foods.map((food) {
                                return _buildMenuItem(
                                    context, food.name, 'images/food.png');
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Drinks :',
                            style: TextStyle(
                                color: Color(0xFF410E82),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 150,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: restaurant.menus.drinks.map((drink) {
                                return _buildMenuItem(
                                    context, drink.name, 'images/drinks.png');
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Customer reviews
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Reviews',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF410E82),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _customerReviews.length,
                            itemBuilder: (context, index) {
                              final review = _customerReviews[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 40,
                                  ),
                                ),
                                title: Text(
                                  review.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF410E82)),
                                ),
                                subtitle: Text(review.review),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _showAddReviewDialog(
                                  context, widget.restaurantId);
                            },
                            child: Text('Add Review'),
                          ),
                        ],
                      ),
                    ),
                    //Customer reviews
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _reloadPage() {
    setState(() {
      _detailRestaurantFuture = _fetchRestaurantDetail();
    });
  }

  Widget _buildMenuItem(
      BuildContext context, String itemName, String imageUrl) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(imageUrl),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SizedBox(
                  width: 100,
                  child: Text(
                    itemName,
                    style: const TextStyle(color: Color(0xFF410E82)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context, String restaurantId) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Review',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _submitReview(
                    context, _nameController, _reviewController, restaurantId);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitReview(BuildContext context, TextEditingController nameController,
      TextEditingController reviewController, String restaurantId) async {
    final String name = nameController.text.trim();
    final String reviewText = reviewController.text.trim();

    if (name.isNotEmpty && reviewText.isNotEmpty) {
      try {
        // Panggil metode addReview dari ApiService dengan menyertakan restaurantId
        await ApiService().addReview(restaurantId, name, reviewText);

        // Tampilkan snackbar jika berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Review submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Perbarui tampilan dengan review terbaru
        _reloadPage();
      } catch (e) {
        // Tangani jika gagal menambahkan review
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit review'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // icon: Icon(Icons.favorite_border),
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: Colors.red,
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
    );
  }
}
