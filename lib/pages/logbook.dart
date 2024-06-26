import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glutara_mobile/utils/format_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LogbookPage extends StatefulWidget {
  const LogbookPage({Key? key}) : super(key: key);

  @override
  State<LogbookPage> createState() => _LogbookPageState();
}

class _LogbookPageState extends State<LogbookPage> {
  List _logs = [];
  bool _isLoading = false;

  Future<void> _fetchLogs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');
    final String? token = prefs.getString('jwtToken');
    List<Map<String, dynamic>> formattedLogs = [];

    var url = Uri.parse(
        'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/logs');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty && response.body != 'null') {
        List<dynamic> data = jsonDecode(response.body);

        for (var log in data) {
          final date = log['Date'];
          String formattedDate =
              FormatUtils.formatDateToReadable(date) ?? 'Invalid date';
          formattedLogs.add({
            'date': formattedDate,
            'logs': log['Logs'].map((log) {
              return {
                'type': log['Type'],
                'Data': log['Data'],
              };
            }).toList(),
          });
        }
        setState(() {
          _logs = formattedLogs;
        });
      } else {
        List<dynamic> data = [];
      }
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
        return Icons.vaccines_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String formatSubtitle(Map<String, dynamic> entry) {
    var type = entry['type'];
    var data = entry['Data'];

    switch (type) {
      case 'Medication':
        return '${data['Category']}, Dose: ${data['Dose']}';
      case 'Exercise':
        var intensityLabel = ['light', 'medium', 'high'][data['Intensity']];
        var durationMinutes = DateTime.parse(data['EndTime'])
            .difference(DateTime.parse(data['StartTime']))
            .inMinutes;
        var duration = FormatUtils.formatDuration(durationMinutes);
        return '${data['Name']}, $intensityLabel intensity, ${duration}';
      case 'Sleep':
        var durationMinutes = DateTime.parse(data['EndTime'])
            .difference(DateTime.parse(data['StartTime']))
            .inMinutes
            .abs();
        var duration = FormatUtils.formatDuration(durationMinutes);
        return 'Duration: ${duration}';
      case 'Meal':
        var mealTypeLabel = ['Breakfast', 'Lunch', 'Dinner', ''][data['Type']];
        var name = data['Name'].toString();
        return '$name, $mealTypeLabel, ${data['Calories']} Calories';
      default:
        return 'Unknown';
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _fetchLogs().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
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
      body: FutureBuilder(
          future: _fetchLogs(), // Fetch data on build
          builder: (context, snapshot) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading logs'));
            } else {
              if (_logs.isEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                  child: Center(
                    child: Text(
                      'No log to display.',
                      style: TextStyle(fontSize: 16.0, color: Colors.black54),
                    ),
                  ),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dailyLog = _logs[index];
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
                        ...dailyLog['logs'].map<Widget>((entry) {
                          IconData icon = getIconForType(entry['type']);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Icon(icon,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                              ),
                              title: Text(entry['type']),
                              subtitle: Text(formatSubtitle(entry)),
                              trailing:
                                  Text(FormatUtils.formatTime(entry['Data'])),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
              );
            }
          }),
    );
  }
}
