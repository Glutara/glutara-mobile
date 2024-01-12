import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'logbook.dart';
import 'relation.dart';
import 'profile.dart';
import 'notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  bool isNotificationClicked = false;

  final List<Widget> _pages = [
    const DashboardPage(),
    const LogbookPage(),
    const RelationPage(),
    const ProfilePage(),
    const NotificationPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        backgroundColor: const Color(0xFFFFFBFF),
        centerTitle: true,
        toolbarHeight: 60.0,
        elevation: 20,
        actions: <Widget>[
          IconButton(
            icon: isNotificationClicked
                ? const Icon(Icons.notifications)
                : const Icon(Icons.notifications_outlined),
            onPressed: () {
              setState(() {
                isNotificationClicked = !isNotificationClicked;
                // Handle notification icon press and status change
              });
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Color(0xFFF5EDDF),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color(0xFFF1E1BB),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.query_stats),
            icon: Icon(Icons.query_stats_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.menu_book),
            icon: Icon(Icons.menu_book_outlined),
            label: 'Logbook',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.handshake),
            icon: Icon(Icons.handshake_outlined),
            label: 'Relation',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
