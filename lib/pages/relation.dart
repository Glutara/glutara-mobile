import 'package:flutter/material.dart';
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
                  backgroundColor: Color(0xFF715C0C),
                  radius: 18,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                onPressed: () {
                  // TODO: Implement add relation action
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
                  _RelationTile(name: 'Jonas'),
                  _RelationTile(name: 'Thomas'),
                  _RelationTile(name: 'Irene'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Search From Map',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.77483, -122.41942), // Example coordinates
                    zoom: 14.0,
                  ),
                  // Set other map properties if needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelationTile extends StatelessWidget {
  final String name;

  const _RelationTile({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(name),
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            const Icon(Icons
                .call_outlined), // Dummy icon, replace with actions as needed
            const Icon(Icons
                .chat_outlined), // Dummy icon, replace with actions as needed
          ],
        ),
      ),
    );
  }
}
