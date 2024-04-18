import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 12, minute: 0);
  TextEditingController _noteController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _selectedLabel = 'Medication';

  @override
  void initState() {
    super.initState();
  }

  List<DropdownMenuItem<String>> get _dropdownMenuItems {
    List<String> labels = ['Meal', 'Medication', 'Exercise', 'Sleep'];
    return labels.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  // Future onSelectNotification(String? payload) {
  //   // Handle your notification tap here.
  // }

  Future<void> scheduleNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Medication Reminder',
        _noteController.text,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        payload: 'Custom_Sound',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Widget _buildReminderItem(String label, String time) {
    return Card(
      child: ListTile(
        tileColor: Colors.orange[50],
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFFFEE086),
          child: Align(
            alignment: Alignment.center,
            child: Icon(Icons.vaccines_outlined, color: Colors.black),
          ),
        ),
        title: Text(label),
        subtitle: Text(time),
        trailing: Icon(Icons.delete), // Update with your own icon
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the AppBar background color
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Change color
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Add actions if needed
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
          child: ListView(
            children: <Widget>[
              Center(
                child: Text(
                  'Add Reminder',
                  style: TextStyle(
                    fontSize: 24.0, // Adjust the font size
                    fontWeight: FontWeight.bold, // Adjust the font weight
                  ),
                ),
              ),
              SizedBox(height: 8.0), // Spacing between title and description
              Center(
                child: Text(
                  'Elevate your well-being effortlessly with timely reminder and notifications for a healthier you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0, // Adjust the font size
                    color: Colors.grey, // Set the color
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              // ... Your other widgets ...
              _buildReminderItem('Take 500g of Metformin', '12:00'),
              _buildReminderItem('Take 500g of Metformin', '12:00'),
              // ... Add more items ...
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReminderModal();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }

  Future<void> _showAddReminderModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: bottomInset + 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Select time',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (picked != null && picked != _selectedTime) {
                          setModalState(() {
                            _selectedTime = picked;
                          });
                        }
                      },
                      child: Text(
                        '${_selectedTime.format(context)}',
                        style: TextStyle(
                          fontSize: 56.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedLabel,
                      decoration: InputDecoration(
                        labelText: 'Label',
                        border: OutlineInputBorder(),
                      ),
                      items: _dropdownMenuItems,
                      onChanged: (String? newValue) {
                        setModalState(() {
                          _selectedLabel = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            scheduleNotification();
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
