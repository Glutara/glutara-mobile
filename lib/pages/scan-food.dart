import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scan-food-detail.dart';

class ScanFoodPage extends StatefulWidget {
  const ScanFoodPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<ScanFoodPage> createState() => _ScanFoodPageState();
}

class _ScanFoodPageState extends State<ScanFoodPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  Future<void> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (_cameraController.value.isTakingPicture) {
      return;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      final XFile picture = await _cameraController.takePicture();
      await sendImageToService(picture);
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
    }
  }

  Future<void> sendImageToService(XFile image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');
    final String? token = prefs.getString('jwtToken');

    final String url =
        "https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/1/scan";
    final Uri uri = Uri.parse(url);

    final http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Uploading image and analyzing nutritional information...",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final String responseString =
            await response.stream.transform(utf8.decoder).first;
        debugPrint('API Response: $responseString');
        final Map<String, dynamic> responseJson = jsonDecode(responseString);
        // Use the responseJson data in your ScanFoodDetailPage
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanFoodDetailPage(
              picture: image,
              foodData: responseJson,
            ),
          ),
        );
      } else {
        // Handle API errors here
        Navigator.pop(context);
        debugPrint('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      Navigator.pop(context);

      debugPrint('Error sending image: $error');
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
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
          _cameraPreviewWidget(),
          _buildDescription(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return Positioned.fill(
      child: _cameraController.value.isInitialized
          ? CameraPreview(_cameraController)
          : Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator()),
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
              'Scan Food',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Take a photo of your food and we\'ll give you its nutritional information',
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

  Widget _buildBottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          color: Colors.black,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 30,
                icon: Icon(
                  _isRearCameraSelected
                      ? CupertinoIcons.switch_camera
                      : CupertinoIcons.switch_camera_solid,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isRearCameraSelected = !_isRearCameraSelected;
                  });
                  initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                },
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: takePicture,
                iconSize: 50,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.circle, color: Colors.white),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  _getImageFromGallery();
                },
                iconSize: 30,
                icon: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final XFile picture = await XFile(pickedFile.path);
      await sendImageToService(picture);
    }
  }
}
