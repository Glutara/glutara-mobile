import 'package:flutter/material.dart';
import 'add-with-phone.dart';
import 'package:camera/camera.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
            // TODO : update QR data
            QrImageView(
              data: 'This is a simple QR code',
              version: QrVersions.auto,
              backgroundColor: Color(0xFFFFFFFF),
              size: 250,
              gapless: true,
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

  void _foundBarcode(BarcodeCapture barcodeCapture) {
    if (!_screenOpened) {
      String raw = barcodeCapture.raw[0]['rawValue'];
      _screenOpened = true;

      // Navigating to a new screen to display the barcode data
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          FoundCodeScreen(screenClosed: _screenWasClosed, value: raw),));
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
}

class FoundCodeScreen extends StatefulWidget {
  final String value;
  final Function() screenClosed;
  const FoundCodeScreen({
    Key? key,
    required this.value,
    required this.screenClosed,
  }) : super(key: key);

  @override
  State<FoundCodeScreen> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        centerTitle: true,
        toolbarHeight: 60.0,
        elevation: 20,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Scanned Code:", style: TextStyle(fontSize: 20,),),
              SizedBox(height: 20,),
              Text(widget.value, style: TextStyle(fontSize: 16,),),
            ],
          ),
        ),
      ),
    );
  }
}
