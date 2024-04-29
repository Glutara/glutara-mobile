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
import 'scan-food.dart';
import '../color_schemes.g.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int userRole = 0;
  int currentPageIndex = 0;
  bool showNotification = false;
  late StreamSubscription _userRoleSubscription;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  @override
  void dispose() {
    _userRoleSubscription.cancel(); // Cancel the subscription
    super.dispose();
  }

  Future<void> _getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int role = prefs.getInt('role') ?? 0; // Default role is patient

    setState(() {
      userRole = role;
      currentPageIndex = (role == 0) ? 0 : 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build UI based on user role
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(userRole),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: IconButton(
          onPressed: () async {
            await availableCameras().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ScanFoodPage(cameras: value))));
          },
          icon: Icon(
            Icons.document_scanner_outlined,
            size: 30.0,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/topbar-logo.png'),
        ],
      ),
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
    );
  }

  Widget _buildBody() {
    return showNotification
        ? const NotificationPage()
        : IndexedStack(
      index: currentPageIndex,
      children: const [
        DashboardPage(),
        LogbookPage(),
        RelationPage(),
        ProfilePage(),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton(int userRole) {
    return FloatingActionButton(
      backgroundColor: CustomColors.brandColor,
      foregroundColor: Colors.white,
      shape: const CircleBorder(eccentricity: 1),
      child: const Icon(Icons.add),
      onPressed: () {
        if (userRole == 0) {
          // Patient action
          _showPatientActionSheet();
        } else if (userRole == 1) {
          // Relation action
          _showRelationActionSheet();
        } else {
          // Default action
        }
      },
    );
  }

  void _showPatientActionSheet() {
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
          color: Theme.of(context).colorScheme.background,
          height: 400,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                "Add Log Activity",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.outline,
              thickness: 2.0,
            ),
            ListTile(
              // add meal
              leading: CircleAvatar(
                radius: 24,
                backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.fastfood_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer),
                ),
              ),
              title: const Text(
                "Meal",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('Track your consumption',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddMealPage()));
              },
            ),
            ListTile(
              // add medication
              leading: CircleAvatar(
                radius: 24,
                backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.vaccines_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer),
                ),
              ),
              title: const Text(
                "Medication",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('Record medication taken',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddMedicationPage()));
              },
            ),
            ListTile(
              // add exercise
              leading: CircleAvatar(
                radius: 24,
                backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.fitness_center_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer),
                ),
              ),
              title: const Text(
                "Exercise",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('Log your exercise activities',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddExercisePage()));
              },
            ),
            ListTile(
              // add sleep
              leading: CircleAvatar(
                radius: 24,
                backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.bedtime_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer),
                ),
              ),
              title: const Text(
                "Sleep",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.normal),
              ),
              subtitle: Text('Track your sleep patterns',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant)),
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
  }

  void _showRelationActionSheet() {
    // Define the action for relation role
  }

  NavigationBar _buildBottomNavigationBar() {
    if (userRole == 0) {
      // Patient UI
      return NavigationBar(
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
      );
    } else {
      // Relation UI
      return NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        onDestinationSelected: (int index) {
          setState(() {
            showNotification = false;
            currentPageIndex = index == 0 ? 2 : 3; // Map index for 'Relation' and 'Profile'
          });
        },
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
        selectedIndex: currentPageIndex == 2 ? 0 : 1, // Map 'Relation' and 'Profile' to first and second index
        destinations: const <Widget>[
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
      );
    }
  }
}
