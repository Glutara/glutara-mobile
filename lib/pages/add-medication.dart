import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'add-meal.dart';
import 'add-exercise.dart';
import 'add-sleep.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({Key? key}) : super(key: key);

  @override
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  bool isPill = true;
  String? pillName;
  int? dose;
  String? injectionType;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showNotification = false;
  int currentPageIndex = 0;

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedDate = args.value;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // This function can be used to save the medication data
  void _saveMedication() {
    // Implement your save logic here
    // You can use pillName, dose, injectionType, selectedDate, and selectedTime as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        backgroundColor: const Color(0xFFF5EDDF),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Add Medication',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ToggleButtons(
              children: const [Text('Injection'), Text('Pill')],
              isSelected: [!isPill, isPill],
              onPressed: (int index) {
                setState(() {
                  isPill = index != 0;
                });
              },
            ),
            if (isPill) ...[
              TextField(
                decoration: const InputDecoration(labelText: 'Pill Name'),
                onChanged: (value) => pillName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Dose (mg)'),
                onChanged: (value) => dose = int.tryParse(value),
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Injection Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: injectionType,
                    isDense: true,
                    isExpanded: true,
                    hint: Text('Select Injection Type'),
                    items: <String>[
                      'Long-acting',
                      'Rapid-acting',
                      'Short-acting'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        injectionType = newValue;
                      });
                    },
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dose (unit)'),
                onChanged: (value) => dose = int.tryParse(value),
                keyboardType: TextInputType.number,
              ),
            ],
            SfDateRangePicker(
              onSelectionChanged: _onDateChanged,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: selectedDate,
              monthCellStyle: DateRangePickerMonthCellStyle(
                textStyle: TextStyle(color: Colors.black),
                todayTextStyle: TextStyle(color: Colors.black),
              ),
              headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selectionColor: Colors.amber,
              todayHighlightColor: Colors.amber,
            ),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Select Time: ${selectedTime.format(context)}',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                primary: Colors.black,
                backgroundColor: Colors.amber,
                onSurface: Colors.grey,
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
