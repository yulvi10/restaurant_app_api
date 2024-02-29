import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/provider/scheduling_provider.dart';
import 'package:restaurant_app_api/widgets/custom_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notification = false; // Default switch off

  @override
  void initState() {
    super.initState();
    // Set initial notification status
    _notification =
        Provider.of<SchedulingProvider>(context, listen: false).isScheduled;
  }

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
              title: Text('Daily Reminder'),
              value: _notification,
              onChanged: (value) async {
                setState(() {
                  _notification = value;
                });
                final schedulingProvider =
                    Provider.of<SchedulingProvider>(context, listen: false);
                await schedulingProvider.scheduledRestaurant(value);
                if (value) {
                  // Show alert notification when scheduling news is turned on
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Notification'),
                      content: Text('Daily Reminder has been turned on.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Show alert notification when scheduling news is turned off
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Notification'),
                      content: Text('Daily Reminder has been turned off.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildList(BuildContext context) {
  //   return ListView(
  //     shrinkWrap: true,
  //     children: [
  //       ListTile(
  //         title: const Text('Daily Reminder'),
  //         trailing: Consumer<SchedulingProvider>(
  //           builder: (context, scheduled, _) {
  //             return Switch.adaptive(
  //               value: scheduled.isScheduled,
  //               onChanged: (value) async {
  //                 if (Platform.isIOS) {
  //                   customDialog(context);
  //                 } else {
  //                   scheduled.scheduledRestaurant(value);
  //                 }
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: ListTile(
            title: const Text('Dark Theme'),
            trailing: Switch.adaptive(
              value: false,
              onChanged: (value) => customDialog(context),
            ),
          ),
        ),
        Material(
          child: ListTile(
            title: const Text('Scheduling News'),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      scheduled.scheduledRestaurant(value);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
