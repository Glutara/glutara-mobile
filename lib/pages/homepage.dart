import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'logbook.dart';
import 'relation.dart';
import 'profile.dart';
import 'notification.dart';
import 'add-meal.dart';
import 'add-exercise.dart';
import 'add-medication.dart';
import 'add-sleep.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF6B42),
        foregroundColor: Colors.white,
        shape: CircleBorder(eccentricity: 1),
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(200.0), // Radius sudut kiri atas
                topRight: Radius.circular(200.0), // Radius sudut kanan atas
              ),
            ),
            builder: (context) {
              return Container(
                alignment: Alignment.center,
                color: Color(0xFFFFF8F0),
                height: 400,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Add Log Activity",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Color(0xFF7D7667),
                    thickness: 2.0,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFFEE086),
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Icon(Icons.fastfood_outlined, color: Colors.black),
                      ),
                    ),
                    title: Text(
                      "Meal",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Track your consumption',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF4C4639))),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMealPage()));
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFFEE086),
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Icon(Icons.vaccines_outlined, color: Colors.black),
                      ),
                    ),
                    title: Text(
                      "Medication",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Record medication taken',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF4C4639))),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMedicationPage()));
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFFEE086),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.fitness_center_outlined,
                            color: Colors.black),
                      ),
                    ),
                    title: Text(
                      "Exercise",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Log your exercise activities',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF4C4639))),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddExercisePage()));
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFFEE086),
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Icon(Icons.bedtime_outlined, color: Colors.black),
                      ),
                    ),
                    title: Text(
                      "Sleep",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Track your sleep patterns',
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF4C4639))),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddSleepPage()));
                    },
                  ),
                ]),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
