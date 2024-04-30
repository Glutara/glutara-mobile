import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glutara_mobile/utils/format_utils.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);
  TextEditingController _noteController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? _selectedLabel = 'Medication';
  final logger = Logger();
  List<dynamic> reminders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _fetchReminders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  IconData getIconForType(String type) {
    switch (type) {
      case "Meal":
        return Icons.fastfood_outlined;
      case "Sleep":
        return Icons.bedtime_outlined;
      case "Exercise":
        return Icons.fitness_center_outlined;
      case "Medication":
        return Icons.vaccines_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Future<void> _fetchReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');
    if (userID == null) {
      logger.e("User ID not found in SharedPreferences");
      return;
    }

    var url = Uri.parse(
        'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/reminders');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body) as List;
        setState(() {
          reminders = jsonData;
        });
      } else {
        logger.e("Failed to fetch reminders: ${response.body}");
      }
    } catch (e) {
      logger.e("Error fetching reminders: $e");
    }
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

  Future<void> scheduleNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
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

  Future<void> _deleteReminder(int reminderID) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');
    if (userID == null) {
      logger.e("User ID not found in SharedPreferences");
      return;
    }

    var url = Uri.parse(
        'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/reminders/$reminderID');
    try {
      var response = await http.delete(url);
      if (response.statusCode != 200) {
        logger.e("Failed to delete reminder: ${response.body}");
      }
    } catch (e) {
      logger.e("Error deleting reminder: $e");
    }
  }

  Future<void> _confirmAndDeleteReminder(int reminderID) async {
    final bool? deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Confirm Delete",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text("Are you sure you want to delete this reminder?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await _deleteReminder(reminderID);
                    _fetchReminders();
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (deleteConfirmed == true) {
      await _deleteReminder(reminderID);
      _fetchReminders();
    }
  }

  Widget _buildReminderItem(
      int reminderID, String name, String time, String description) {
    return Card(
      child: ListTile(
        tileColor: Colors.orange[50],
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(getIconForType(name), color: Colors.white),
        ),
        title: Text(name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time, style: TextStyle(fontSize: 16)),
            Text(description,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmAndDeleteReminder(reminderID),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
          future: _fetchReminders(),
          builder: (context, snapshot) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading logs'));
            } else {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Add Reminder',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      const Center(
                        child: Text(
                          'Elevate your well-being effortlessly with timely reminder and notifications for a healthier you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ...reminders.map<Widget>((reminder) {
                        DateTime dateTime = DateTime.parse(reminder['Time']);
                        String formattedTime =
                            DateFormat('HH:mm').format(dateTime);
                        return _buildReminderItem(
                            reminder['ReminderID'],
                            reminder['Name'],
                            formattedTime,
                            reminder['Description']);
                      }),
                    ],
                  ),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReminderModal();
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _createReminder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');

    final DateTime now = DateTime.now();
    final DateTime reminderTime = DateTime(
        now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);

    logger.f(jsonEncode(<String, dynamic>{
      "UserID": userID,
      "ReminderID": 1,
      "Name": _selectedLabel,
      "Description": _noteController.text,
      "Time": FormatUtils.combineDateWithTime(
          now, TimeOfDay.fromDateTime(reminderTime)),
    }));

    try {
      var response = await http.post(
        Uri.parse(
            'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/reminders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "UserID": userID,
          "ReminderID": 1,
          "Name": _selectedLabel,
          "Description": _noteController.text,
          "Time": FormatUtils.combineDateWithTime(
              now, TimeOfDay.fromDateTime(reminderTime)),
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
                msg: "Reminder saved successfully!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0)
            .then((value) => Navigator.pop(context));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                    const Text(
                      'Select Time',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedLabel,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            _createReminder(),
                            // scheduleNotification();
                          },
                          child: const Text('Ok'),
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
