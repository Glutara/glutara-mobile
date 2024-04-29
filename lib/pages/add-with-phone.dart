import 'package:flutter/material.dart';
import 'add-with-qrcode.dart';
import 'generate-otp.dart';
import 'package:camera/camera.dart';

class AddWithPhonePage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final int userRole;

  AddWithPhonePage({Key? key, required this.userRole}) : super(key: key);

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Add Relation with Phone',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Add your relation name and phone number to share your glucose level tracking with them',
              style: TextStyle(
                  fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Relation\'s name',
                border: _border(Colors.grey),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Relation\'s phone number',
                border: _border(Colors.grey),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              child: const Text(
                  'Generate OTP',
                  style: TextStyle(fontSize: 16.0)
              ),
              onPressed: () {
                if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
                  // Show error message if any of the fields is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                } else {
                  // Navigate to the next page if both fields are filled
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateOTPPage()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary,
                onPrimary: Colors.white,
                minimumSize: const Size(double.infinity, 36),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await availableCameras().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddWithQRCodePage(userRole: userRole, cameras: value))),
                );
              },
              child: const Text(
                  'Add with QR code',
                  style: TextStyle(fontSize: 16.0)
              ),
            )
          ],
        ),
      ),
    );
  }
}