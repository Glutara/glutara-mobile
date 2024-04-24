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
import '../color_schemes.g.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  bool showNotification = false;

  final List<Widget> _pages = [
    const DashboardPage(),
    const LogbookPage(),
    const RelationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        centerTitle: true,
        toolbarHeight: 60.0,
        elevation: 20,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  showNotification = !showNotification;
                });
              },
              icon: Icon(
                showNotification
                    ? Icons.notifications
                    : Icons.notifications_outlined,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      body: showNotification
          ? const NotificationPage()
          : IndexedStack(
              index: currentPageIndex,
              children: _pages,
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.brandColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(eccentricity: 1),
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(200.0),
                topRight: Radius.circular(200.0),
              ),
            ),
            builder: (context) {
              return Container(
                alignment: Alignment.center,
                color: const Color(0xFFFFF8F0),
                height: 400,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Add Log Activity",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.outline,
                    thickness: 2.0,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Icon(Icons.fastfood_outlined, color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: const Text(
                      "Meal",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Track your consumption',
                        style:
                            TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddMealPage()));
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Icon(Icons.vaccines_outlined, color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: const Text(
                      "Medication",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Record medication taken',
                        style:
                            TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddMedicationPage()));
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.fitness_center_outlined,
                            color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: const Text(
                      "Exercise",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Log your exercise activities',
                        style:
                            TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddExercisePage()));
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Icon(Icons.bedtime_outlined, color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: const Text(
                      "Sleep",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    subtitle: Text('Track your sleep patterns',
                        style:
                            TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddSleepPage()));
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        onDestinationSelected: (int index) {
          setState(() {
            showNotification = false;
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
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
