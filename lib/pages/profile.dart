import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
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
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/default-avatar.jpeg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Selina Anita',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                  child: const Text('Edit'),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF715C0C),
                    primary: Colors.white,
                    minimumSize: Size(50, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 32.0),
            child: Text(
              'General',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF544514)),
            ),
          ),
          _buildListTile(context, Icons.notifications_outlined, 'Notifications'),
          _buildListTile(context, Icons.dark_mode_outlined, 'Appearance'),
          _buildListTile(context, Icons.lock_outline, 'Privacy'),
          _buildListTile(context, Icons.cloud_outlined, 'Storage & Data'),
          _buildListTile(context, Icons.info_outline, 'About'),
          _buildLogoutListTile(context), // Add Logout option
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF544514)),
      title: Text(title),
      onTap: () {
        // TODO: Implement navigation or action for each ListTile
      },
    );
  }

  ListTile _buildLogoutListTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red),
      title: Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        // TODO: Implement logout action
      },
    );
  }
}
