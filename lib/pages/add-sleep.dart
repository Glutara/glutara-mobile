import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add-meal.dart';
import 'add-medication.dart';
import 'add-exercise.dart';

class AddSleepPage extends StatefulWidget {
  const AddSleepPage({Key? key}) : super(key: key);

  @override
  _AddSleepPageState createState() => _AddSleepPageState();
}

class _AddSleepPageState extends State<AddSleepPage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  DateTime? selectedStartDate; // Tambahkan variabel untuk tanggal awal
  DateTime? selectedEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        backgroundColor: Colors.amber[50],
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
      // TODO: Implement body as design
      // Inside the Scaffold of your AddSleepPage

      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.orange[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add Sleep',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Start Time',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.watch_later_outlined),
                hintText: selectedStartDate != null
                    ? DateFormat('dd MMM yyyy HH:mm').format(selectedStartDate!)
                    : 'Select start time', // Tampilkan tanggal yang dipilih atau pesan 'Select start time'
              ),
              readOnly: true,
              onTap: () async {
                // Tampilkan date-time picker untuk tanggal awal
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      selectedStartDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'End Time',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.watch_later_outlined),
                hintText: selectedEndDate != null
                    ? DateFormat('dd MMM yyyy HH:mm').format(selectedEndDate!)
                    : 'Select end time', // Tampilkan tanggal yang dipilih atau pesan 'Select end time'
              ),
              readOnly: true,
              onTap: () async {
                // Tampilkan date-time picker untuk tanggal akhir
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      selectedEndDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
            ),
            SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                child: Text('Save', style: TextStyle(fontSize: 20.0)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  primary: Color(0xFF715C0C),
                ),
                onPressed: () {
                  // Code to save sleep data
                },
              ),
            ),
          ],
        ),
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
        backgroundColor: Colors.amber[50],
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
