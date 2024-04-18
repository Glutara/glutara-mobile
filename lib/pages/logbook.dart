import 'package:flutter/material.dart';

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

class LogbookPage extends StatelessWidget {
  const LogbookPage({Key? key}) : super(key: key);

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
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(entry['icon'], color: Theme.of(context).colorScheme.onPrimaryContainer),
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
