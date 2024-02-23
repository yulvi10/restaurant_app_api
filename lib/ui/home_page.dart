import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:restaurant_app_api/ui/no_internet_page.dart';
import 'package:restaurant_app_api/widgets/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/background_1.jpg',
            ), // Ganti dengan path asset gambar Anda
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult != ConnectivityResult.none) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigationPage(),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoInternetPage(
                          onRetryPressed: () {
                            _reloadHomePage(context);
                          },
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 40,
                  color: Colors.white,
                ),
                label: const Text(
                  'View Restaurant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBBB00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reloadHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}
