import 'package:flutter/material.dart';

final notifications = [
  {
    'title': 'Sleep Reminder',
    'time': '22.00',
    'description':
        "It's time to unwind and get a good night's sleep for your well-being.",
    'isNew': true
  },
  {
    'title': 'Medication Reminder',
    'time': '11.30',
    'description':
        "It's time to take 500g of Metformin to support your health and well-being.",
    'isNew': true
  },
  {
    'title': 'Time to Workout',
    'time': '10.00',
    'description':
        'Engage in your scheduled exercise routine for a healthier you.',
    'isNew': true
  },
  {
    'title': 'Medication Reminder',
    'time': '20.00',
    'description':
        "It's time to take 500g of Metformin to support your health and well-being.",
    'isNew': false
  },
];

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
            elevation: 0,
          ),
          body: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(
                    notification['title'] as String,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    notification['description'] as String,
                    style: const TextStyle(fontSize: 12)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (notification['isNew'] as bool)
                        Text(
                          notification['time'] as String,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )
                      else
                        Text(
                          'Yesterday',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
