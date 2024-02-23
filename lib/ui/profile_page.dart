import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                children: [
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF410E82),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  color: const Color(0xFFFBFBFB),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('images/profile.jpg'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Yulvi Setiyawan', // Ganti dengan nama pengguna
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF410E82)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Software Engineer', // Ganti dengan pekerjaan pengguna
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
