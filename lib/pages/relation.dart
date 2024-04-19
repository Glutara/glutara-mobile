import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RelationPage extends StatefulWidget {
  const RelationPage({Key? key}) : super(key: key);

  @override
  _RelationPageState createState() => _RelationPageState();
}

class _RelationPageState extends State<RelationPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
        37.7749, -122.4194), // This is a dummy position for San Francisco
    zoom: 14,
  );

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    // Dummy markers data
    _markers.add(
      Marker(
        markerId: MarkerId('m1'),
        position: LatLng(37.7749, -122.4194),
        infoWindow: InfoWindow(title: 'Dummy Location 1'),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('m2'),
        position: LatLng(37.7769, -122.4174),
        infoWindow: InfoWindow(title: 'Dummy Location 2'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Relation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement add relation action
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView(
            shrinkWrap: true,
            children: const [
              _RelationTile(name: 'Jonas', phoneNumber: '081396301513'),
              _RelationTile(name: 'Thomas', phoneNumber: '081396301513'),
              _RelationTile(name: 'Irene', phoneNumber: '081396301513'),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Search From Map',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            // Make sure GoogleMap is wrapped with an Expanded widget
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  // TODO: Implement additional map configuration if needed
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationTile extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const _RelationTile({Key? key, required this.name, required this.phoneNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: ListTile(
        title: Text(name),
        trailing: IconButton(
          icon: const Icon(Icons.call_outlined), onPressed: () {  },
        ),
      ),
    );
  }

}
