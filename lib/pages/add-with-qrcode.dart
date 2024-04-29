import 'package:flutter/material.dart';
import 'add-with-phone.dart';
import 'package:camera/camera.dart';

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
      return _CameraPage(cameras: cameras);
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
            Image.asset(
              'assets/qrcode.png',
              width: 250,
              height: 250,
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

class _CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const _CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<_CameraPage> {
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(widget.cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

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
          Positioned.fill(
            child: _cameraController.value.isInitialized
                ? CameraPreview(_cameraController)
                : Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
          _buildDescription(),
        ],
      ),
    );
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
}
