import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 12, minute: 0);
  TextEditingController _labelController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initSetttings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
  }

  // Future onSelectNotification(String? payload) {
  //   // Handle your notification tap here.
  // }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime = DateTime.now().add(Duration(
        seconds: 5)); // This should be replaced with your time calculation
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reminder'),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text('Select time'),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null && picked != _selectedTime)
                setState(() {
                  _selectedTime = picked;
                });
            },
          ),
          TextField(
            controller: _labelController,
            decoration: InputDecoration(
              labelText: 'Label',
            ),
          ),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Notes',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              scheduleNotification();
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
