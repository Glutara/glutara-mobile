import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add-meal.dart';
import 'add-medication.dart';
import 'add-sleep.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key? key}) : super(key: key);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  void _onDatePicked(DateTime pickedDate) {
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _onStartTimePicked(TimeOfDay pickedTime) {
    setState(() {
      _selectedStartTime = pickedTime;
    });
  }

  void _onEndTimePicked(TimeOfDay pickedTime) {
    setState(() {
      _selectedEndTime = pickedTime;
    });
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.jm(); // Change the format as needed
    return format.format(dt);
  }

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
      body: Container(
        child: Container(
          color: Colors.orange[50],
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add Exercise',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Exercise Name',
                    labelStyle: TextStyle(color: Color(0xFF715C0C)),
                    border: _border(Colors.grey),
                    focusedBorder: _border(Color(0xFF715C0C)),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Intensity',
                    labelStyle: TextStyle(color: Color(0xFF715C0C)),
                    border: _border(Colors.grey),
                    focusedBorder: _border(Color(0xFF715C0C)),
                  ),
                  items: ['Low', 'Medium', 'High']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      _onDatePicked(pickedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                          text: _selectedDate != null
                              ? DateFormat('EEEE, dd MMM yyyy')
                                  .format(_selectedDate!)
                              : ''),
                      decoration: InputDecoration(
                        labelText: 'Date',
                        labelStyle: TextStyle(color: Color(0xFF715C0C)),
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedStartTime ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            _onStartTimePicked(pickedTime);
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                                text: _selectedStartTime != null
                                    ? _formatTimeOfDay(_selectedStartTime!)
                                    : ''),
                            decoration: InputDecoration(
                              labelText: 'Start Time',
                              border: _border(Colors.grey),
                              focusedBorder: _border(Color(0xFF715C0C)),
                              suffixIcon: Icon(Icons.access_time),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedEndTime ?? TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            _onEndTimePicked(pickedTime);
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: TextEditingController(
                                text: _selectedEndTime != null
                                    ? _formatTimeOfDay(_selectedEndTime!)
                                    : ''),
                            decoration: InputDecoration(
                              labelText: 'End Time',
                              border: _border(Colors.grey),
                              focusedBorder: _border(Color(0xFF715C0C)),
                              suffixIcon: Icon(Icons.access_time),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 64.0),
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
