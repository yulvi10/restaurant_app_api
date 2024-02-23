import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class NoInternetPage extends StatelessWidget {
  
  final VoidCallback onRetryPressed; // Tambahkan properti onRetryPressed

  const NoInternetPage({Key? key, required this.onRetryPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'Tidak ada koneksi internet.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                var connectivityResult = await Connectivity().checkConnectivity();
                if (connectivityResult != ConnectivityResult.none) {
                  // Panggil fungsi onRetryPressed jika ada koneksi internet
                  onRetryPressed();
                }
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
