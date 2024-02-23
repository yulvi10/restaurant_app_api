import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                // Implement logic to change app theme to dark mode
              },
            ),
            Divider(),
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SwitchListTile(
              title: Text('Receive Notifications'),
              value: _notification,
              onChanged: (value) {
                setState(() {
                  _notification = value;
                });
                // Implement logic to enable/disable notifications
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Settings Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    darkTheme: ThemeData.dark(), // Dark theme configuration
    home: SettingsPage(),
  ));
}
