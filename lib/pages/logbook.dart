import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final List<Map<String, dynamic>> logs = [
  {
    'date': 'Today, 17 January 2024',
    'entries': [
      {
        'time': '12.00',
        'icon': Icons.bedtime_outlined,
        'activity': 'Sleep',
        'detail': '1h 30m'
      },
      {
        'time': '10.00',
        'icon': Icons.fitness_center_outlined,
        'activity': 'Exercise',
        'detail': 'Light intensity, 30 min'
      },
      {
        'time': '08.00',
        'icon': Icons.fastfood_outlined,
        'activity': 'Breakfast',
        'detail': '230 Calories'
      },
    ],
  },
  {
    'date': 'Yesterday, 16 January 2024',
    'entries': [
      {
        'time': '12.00',
        'icon': Icons.bedtime_outlined,
        'activity': 'Sleep',
        'detail': '1h 30m'
      },
      {
        'time': '10.00',
        'icon': Icons.fitness_center_outlined,
        'activity': 'Exercise',
        'detail': 'Light intensity, 30 min'
      },
      {
        'time': '08.00',
        'icon': Icons.fastfood_outlined,
        'activity': 'Breakfast',
        'detail': '230 Calories'
      },
    ],
  },
];

class LogbookPage extends StatefulWidget {
  const LogbookPage({Key? key}) : super(key: key);

  @override
  State<LogbookPage> createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  final logger = Logger();
  List _logs = [];

  Future<void> _fetchLogs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');
    if (userID == null) {
      logger.e("User ID not found in SharedPreferences");
      return;
    }

    var url = Uri.parse(
        'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/logs');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        logger.d("Logs fetched successfully: $data");
        setState(() {
          _logs = data;
        });
      } else {
        logger.e("Failed to fetch logs: ${response.body}");
      }
    } catch (e) {
      logger.e("Error fetching logs: $e");
    }
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
        return Icons.medical_services_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: AppBar(
            title: const Text(
              'Logbook',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // TODO: Implement menu action
                },
              ),
            ],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
        child: ListView.builder(
          itemCount: logs.length,
          itemBuilder: (BuildContext context, int index) {
            final dailyLog = logs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    dailyLog['date'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...dailyLog['entries'].map<Widget>((entry) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(entry['icon'],
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                      title: Text(entry['activity']),
                      subtitle: Text(entry['detail']),
                      trailing: Text(entry['time']),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
