// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/default-avatar.jpeg'),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selina Anita',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '+6282336571102',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement edit profile action
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary,
                    minimumSize: const Size(50, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _buildListTile(
                    context, Icons.notifications_outlined, 'Reminders'),
                _buildListTile(context, Icons.badge_outlined, 'Change Role'),
                _buildListTile(context, Icons.dark_mode_outlined, 'Appearance'),
                _buildListTile(context, Icons.lock_outline, 'Privacy'),
                _buildListTile(context, Icons.cloud_outlined, 'Storage & Data'),
                _buildListTile(context, Icons.info_outline, 'About'),
                _buildLogoutListTile(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      onTap: () {
        // TODO: Implement navigation or action for each ListTile
      },
    );
  }

  ListTile _buildLogoutListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
      onTap: () async {
        bool confirmLogout = await _showLogoutDialog(context);

        if (confirmLogout) {
          // Clear user session data from shared preferences or any other persistent storage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('userID');
          await prefs.remove('lastLoginTime');

          // Navigate to LoginPage and remove all routes below from the stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      },
    );
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ), // Makes the corners rounded
              child: Container(
                padding: const EdgeInsets.all(20.0),
                constraints: const BoxConstraints(
                    minHeight: 200.0), // Set a minimum height for the dialog
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures the space is only as big as its children need
                  children: <Widget>[
                    SizedBox(height: 20), // Spacing at the top
                    Text(
                      'Confirm Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    SizedBox(height: 20), // Spacing between text and buttons
                    Text(
                      'Are you sure you want to logout?',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20), // Spacing between text and buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'Logout',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }
}
