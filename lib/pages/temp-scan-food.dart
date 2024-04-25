// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
//
// class ScanFoodPage extends StatefulWidget {
//   @override
//   _ScanFoodPageState createState() => _ScanFoodPageState();
// }
//
// class _ScanFoodPageState extends State<ScanFoodPage> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     // Obtain a list of the available cameras on the device
//     availableCameras().then((cameras) {
//       if (cameras.isNotEmpty) {
//         // Get the first camera from the list
//         _controller = CameraController(cameras[0], ResolutionPreset.medium);
//         // Initialize the camera controller
//         _initializeControllerFuture = _controller.initialize();
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the camera controller when the widget is disposed
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take a picture of a food'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the Future is complete, display the camera preview
//             return CameraPreview(_controller);
//           } else {
//             // Otherwise, display a loading indicator
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             // Ensure that the camera is initialized before attempting to take a picture
//             await _initializeControllerFuture;
//             // Attempt to take a picture and get the result
//             final XFile picture = await _controller.takePicture();
//             // Navigate to the preview page with the captured picture
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => PicturePreviewPage(imagePath: picture.path)),
//             );
//           } catch (e) {
//             // If an error occurs, log the error to the console
//             print('Error taking picture: $e');
//           }
//         },
//         child: Icon(Icons.camera),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
//
// class PicturePreviewPage extends StatelessWidget {
//   final String imagePath;
//
//   const PicturePreviewPage({required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Preview'),
//       ),
//       body: Center(
//         child: Image.file(
//           File(imagePath),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
