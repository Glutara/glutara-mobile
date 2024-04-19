import 'package:flutter/material.dart';
import 'add-with-qrcode.dart';
import 'add-with-phone.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RelationPage extends StatelessWidget {
  const RelationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: AppBar(
            title: const Text(
              'My Relation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 24,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                onPressed: () {
                  _showAddConnectionDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  _RelationTile(name: 'Jonas', phone: '+6282338741009'),
                  _RelationTile(name: 'Thomas', phone: '+6281395328431'),
                  _RelationTile(name: 'Irene', phone: '+6285391410588'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Add Connection',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:  20.0,
              )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose how you would like to connect',
                style: TextStyle(fontSize: 16.0)
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddWithQRCodePage()),
                  );
                },
                child: Text(
                    'With QR code',
                    style: TextStyle(fontSize: 16.0)
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddWithPhonePage()),
                  );
                },
                child: Text(
                    'With phone number',
                    style: TextStyle(fontSize: 16.0)
              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RelationTile extends StatelessWidget {
  final String name;
  final String phone;

  const _RelationTile({Key? key, required this.name, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/default-avatar.jpeg'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    phone,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 12,
              children: <Widget>[
                const Icon(Icons.call_outlined),
                const Icon(Icons.chat_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}