import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'add-with-qrcode.dart';
import 'add-with-phone.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RelationPage extends StatefulWidget {
  final int userRole;

  const RelationPage({Key? key, required this.userRole}) : super(key: key);

  @override
  _RelationPageState createState() => _RelationPageState();
}

class _RelationPageState extends State<RelationPage> {
  late GoogleMapController mapController;
  final Location _location = Location();
  LatLng _initialPosition = const LatLng(-6.890670, 107.607060);
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _addInitialMarker();
  }

  void _addInitialMarker() {
    _markers.add(const Marker(
      markerId: MarkerId('marker1'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(-6.900670, 107.627060),
      infoWindow: InfoWindow(
        title: 'Marker 1',
        snippet: 'Label for Marker 1',
      ),
    ));
    _markers.add(const Marker(
      markerId: MarkerId('marker2'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(-6.930670, 107.617060),
      infoWindow: InfoWindow(
        title: 'Marker 2',
        snippet: 'Label for Marker 2',
      ),
    ));
  }

  Future<void> _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _location.getLocation();
    setState(() {
      _initialPosition = LatLng(_locationData.latitude ?? -6.890670,
          _locationData.longitude ?? 107.607060);

      _markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: _initialPosition,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    });

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _initialPosition = LatLng(
          currentLocation.latitude ?? -6.890670,
          currentLocation.longitude ?? 107.607060,
        );
        _markers.removeWhere(
            (marker) => marker.markerId == const MarkerId("currentLocation"));
        _markers.add(
          Marker(
            markerId: const MarkerId("currentLocation"),
            position: _initialPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
            _buildMapSection(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    String titleText = '';
    bool showCircleIconButton = true;

    switch (widget.userRole) {
      case 0:
        titleText = 'My Relation';
        break;
      case 1:
        titleText = 'Track My Relation';
        showCircleIconButton = false;
        break;
      case 2:
        titleText = 'Patient Around Me';
        showCircleIconButton = false;
        break;
      default:
        titleText = 'My Relation';
        break;
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: AppBar(
          title: Text(
            titleText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            if (showCircleIconButton)
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 24,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                onPressed: () {
                  _showAddConnectionDialog(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    if (widget.userRole == 1) {
      // Hide map section for relation role
      return SizedBox();
    } else {
      // Show map section for other roles
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: const Text(
              'Search From Map',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 13),
                markers: _markers,
              ),
            ),
          ),
        ],
      );
    }
  }

  void _showAddConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Connection',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose how you would like to connect',
                  style: TextStyle(fontSize: 16.0)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddWithQRCodePage()),
                  );
                },
                child: const Text('With QR code',
                    style: TextStyle(fontSize: 16.0)),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddWithPhonePage()),
                  );
                },
                child: const Text('With phone number',
                    style: TextStyle(fontSize: 16.0)),
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

  const _RelationTile({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
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
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      name,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Text(
                    phone,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Wrap(
              spacing: 12,
              children: <Widget>[
                Icon(Icons.call_outlined),
                Icon(Icons.chat_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
