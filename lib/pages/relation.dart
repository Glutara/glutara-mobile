import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'patient.dart';
import 'add-with-qrcode.dart';
import 'add-with-phone.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _isLoading = false;

  Future<List<Map<String, dynamic>>> fetchRelationData() async {
    // Fetch the user ID
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');
    final String? token = prefs.getString('jwtToken');

    if (userID == null || token == null) {
      throw Exception('User authentication failed. Please login again.');
    }

    var url = Uri.parse(
        'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/relations/related');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Handle potential null response body using null-conditional operator
        final String data = response.body;

        // Check if data is not null before decoding
        if (data != 'null') {
          final List<dynamic> responseData = json.decode(data);
          return responseData
              .cast<Map<String, dynamic>>(); // Explicit type cast
        } else {
          return []; // Return an empty list if no data is present
        }
      } else {
        throw Exception(
            'Failed to load relation data (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception("Error fetching logs: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchPatientData() async {
    // Fetch the user ID
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');
    final String? token = prefs.getString('jwtToken');

    if (userID == null || token == null) {
      throw Exception('User authentication failed. Please login again.');
    }

    var url = Uri.parse(
        'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/relations');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Handle potential null response body using null-conditional operator
        final String data = response.body;

        // Check if data is not null before decoding
        if (data != 'null') {
          final List<dynamic> responseData = json.decode(data);
          return responseData
              .cast<Map<String, dynamic>>(); // Explicit type cast
        } else {
          return []; // Return an empty list if no data is present
        }
      } else {
        throw Exception(
            'Failed to load patient data (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception("Error fetching logs: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    setState(() {
      _isLoading = true;
    });
  }

  void _addInitialMarker(List<Map<String, dynamic>> patientData) async {
    if (patientData.isNotEmpty) {
      final Map<String, dynamic> patient =
          patientData.first; // Get first patient data
      final double patientLatitude = patient['Latitude'].toDouble() ?? 0.0;
      final double patientLongitude = patient['Longitude'].toDouble() ?? 0.0;
      final String relationName = patient['RelationName'] ?? '';

      // Send lat/lng to patient using your preferred method (e.g., socket, messaging)

      final marker = Marker(
        markerId: MarkerId(relationName), // Use relation name as marker ID
        position: LatLng(patientLatitude, patientLongitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: relationName,
          snippet: 'Your Relation',
        ),
      );

      setState(() {
        _markers.add(marker);
      });
    }
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
              child: FutureBuilder<List<Widget>>(
                future: _buildRelationTiles(context),
                builder: (context, snapshot) {
                  if (_isLoading) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView(
                      children: snapshot.data ?? [],
                    );
                  }
                },
              ),
            ),
            _buildMapSection(context),
          ],
        ),
      ),
    );
  }

  Future<List<Widget>> _buildRelationTiles(BuildContext context) async {
    if (widget.userRole == 0) {
      try {
        final List<Map<String, dynamic>> patientData = await fetchPatientData();
        setState(() {
          _isLoading = false;
        });
        _addInitialMarker(patientData);
        if (!patientData.isEmpty && patientData != 'null') {
          return patientData.map((data) {
            return _TileForPatient(
              name: data['RelationName'] ?? '',
              phone: data['RelationPhone'] ?? '',
            );
          }).toList();
        } else {
          // Handle case where no relation data is found (optional)
          return [
            Center(
              child: Text(
                'No relation data found',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          ];
        }
      } catch (e) {
        return [
          Center(
            child: Text(
              'Error fetching relation data',
              style: TextStyle(fontSize: 18.0),
            ),
          )
        ];
      }
    } else if (widget.userRole == 1) {
      try {
        final List<Map<String, dynamic>> relationData =
            await fetchRelationData();
        setState(() {
          _isLoading = false;
        });
        // Check if data exists before building tiles
        if (!relationData.isEmpty && relationData != 'null') {
          return relationData.map((data) {
            return _TileForRelation(
              userID: data['UserID'] ?? 0,
              name: data['Name'] ?? '',
              phone: data['Phone'] ?? '',
              glucose:
                  data['LatestBloodGlucose'].toDouble().toStringAsFixed(1) ??
                      '',
            );
          }).toList();
        } else {
          // Handle case where no relation data is found (optional)
          return [
            Center(
              child: Text(
                'No patient data found',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          ];
        }
      } catch (e) {
        return [
          Center(
            child: Text(
              'Error fetching patient data',
              style: TextStyle(fontSize: 18.0),
            ),
          )
        ];
      }
    } else {
      return [
        _TileForVolunteer(name: 'Thomas', phone: '081395328431'),
      ];
    }
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
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
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
                initialCameraPosition:
                    CameraPosition(target: _initialPosition, zoom: 13),
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
                onPressed: () async {
                  Navigator.pop(context);
                  await availableCameras().then(
                    (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddWithQRCodePage(
                                userRole: widget.userRole, cameras: value))),
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
                    MaterialPageRoute(
                        builder: (context) =>
                            AddWithPhonePage(userRole: widget.userRole)),
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

class _TileForPatient extends StatelessWidget {
  final String name;
  final String phone;

  const _TileForPatient({super.key, required this.name, required this.phone});

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

class _TileForRelation extends StatelessWidget {
  final int userID;
  final String name;
  final String phone;
  final String glucose;

  const _TileForRelation({
    Key? key,
    required this.userID,
    required this.name,
    required this.phone,
    required this.glucose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PatientPage(userID: this.userID.toString())),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      glucose.toString(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      'mg/dL',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileForVolunteer extends StatelessWidget {
  final String name;
  final String phone;

  const _TileForVolunteer({super.key, required this.name, required this.phone});

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
