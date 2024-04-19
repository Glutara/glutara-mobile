import 'package:flutter/material.dart';
import 'add-with-qrcode.dart';
import 'generate-otp.dart';

class AddWithPhonePage extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
            Text(
              'Add Relation with Phone',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Add your relation name and phone number to share your glucose level tracking with them',
              style: TextStyle(
                  fontSize: 16
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Relation\'s name',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary), // Use theme color
                border: _border(Colors.grey),
                focusedBorder: _border(Theme.of(context).colorScheme.primary), // Use theme color
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
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
            SizedBox(height: 30.0),
            ElevatedButton(
              child: Text(
                  'Generate OTP',
                  style: TextStyle(fontSize: 16.0)
              ),
              onPressed: () {
                if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
                  // Show error message if any of the fields is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
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
                minimumSize: Size(double.infinity, 36),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddWithQRCodePage()),
                );
              },
              child: Text(
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