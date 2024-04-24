import 'package:flutter/material.dart';
import 'add-with-phone.dart';

class AddWithQRCodePage extends StatelessWidget {
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
              style: TextStyle(
                fontSize: 16
              ),
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
                  MaterialPageRoute(builder: (context) => AddWithPhonePage()),
                );
              },
              child: const Text(
                  'Add with phone number',
                  style: TextStyle(fontSize: 16.0)
              ),
            )
          ],
        ),
      ),
    );
  }
}
