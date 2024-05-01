import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'add-with-phone.dart';
import 'dart:convert';

// Generate a random encryption key
final key = encrypt.Key.fromLength(32);

// Generate a random IV (Initialization Vector)
final iv = encrypt.IV.fromLength(16);

// Encryption method
String encryptData(String data) {
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encryptedData = encrypter.encrypt(data, iv: iv);
  return encryptedData.base64;
}

// Decryption method
String decryptData(String encryptedData) {
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final decryptedData = encrypter.decrypt64(encryptedData, iv: iv);
  return decryptedData;
}

class AddWithQRCodePage extends StatelessWidget {
  final int userRole;
  final List<CameraDescription> cameras;

  AddWithQRCodePage({Key? key, required this.userRole, required this.cameras})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userRole == 0) {
      return _buildAddWithQRCode(context);
    } else {
      return _ScanQRPage();
    }
  }

  Widget _buildAddWithQRCode(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        centerTitle: true,
        toolbarHeight: 60.0,
        elevation: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Add Relation with QR Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Let your relation scan this QR Code to share your glucose level tracking with them',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: _generateQRData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return QrImageView(
                    data: snapshot.data!,
                    version: QrVersions.auto,
                    backgroundColor: Color(0xFFFFFFFF),
                    size: 250,
                    gapless: true,
                  );
                }
              },
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddWithPhonePage(userRole: userRole)),
                );
              },
              child: const Text('Add with phone number', style: TextStyle(fontSize: 16.0)),
            )
          ],
        ),
      ),
    );
  }

  Future<String> _generateQRData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    String name = prefs.getString('name') ?? '';
    String phone = prefs.getString('phone') ?? '';

    // Format the data into a string
    Map<String, dynamic> userData = {
      'userID': userID,
      'name': name,
      'phone': phone,
    };

    String userDataString = jsonEncode(userData);
    return userDataString;
  }
}

class _ScanQRPage extends StatefulWidget {
  const _ScanQRPage({Key? key}) : super(key: key);

  @override
  State<_ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<_ScanQRPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        centerTitle: true,
        toolbarHeight: 60.0,
        elevation: 20,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _foundBarcode
          ),
          _buildDescription(),
        ],
      ),
    );
  }

  Future<void> _foundBarcode(BarcodeCapture barcodeCapture) async {
    if (!_screenOpened) {
      String raw = barcodeCapture.raw[0]['rawValue'];
      _screenOpened = true;

      // Decode the QR data
      Map<String, dynamic> patientData = jsonDecode(raw);

      // Get relation data
      String relationData = await _generateQRData();

      // Decode the relation data
      Map<String, dynamic> relationMap = jsonDecode(relationData);

      // Prepare the query body
      Map<String, dynamic> body = {
        'UserID': patientData['userID'],
        'Name': patientData['name'],
        'Phone': patientData['phone'],
        'RelationID': relationMap['userID'],
        'RelationName': relationMap['name'],
        'RelationPhone': relationMap['phone'],
        'Logitude': 107.606017,
        'Latitude': -6.881305
      };

      // Convert the body to JSON
      String requestBody = jsonEncode(body);
      debugPrint(requestBody);
      int? userID = patientData['userID'];

      var response = await http.post(
        Uri.parse(
              'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/relations'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestBody,
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "New patient was added successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0)
        .then((value) => Navigator.pop(context));
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Patient already added to your list!"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDescription() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color: Colors.black.withOpacity(0.4),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan QR Code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Scan the QR Code shown in the patient\'s screen to connect and start tracking their glucose level',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }

  Future<String> _generateQRData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    String name = prefs.getString('name') ?? '';
    String phone = prefs.getString('phone') ?? '';

    // Format the data into a string
    Map<String, dynamic> userData = {
      'userID': userID,
      'name': name,
      'phone': phone,
    };

    String userDataString = jsonEncode(userData);
    return userDataString;
  }
}

