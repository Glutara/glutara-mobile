import 'package:flutter/material.dart';
import 'add-with-qrcode.dart';

class AddWithPhonePage extends StatelessWidget {
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
              'Add your relation phone number to share your glucose level tracking with them',
              style: TextStyle(
                  fontSize: 16
              ),
              textAlign: TextAlign.center,
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
