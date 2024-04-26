import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ScanFoodDetailPage extends StatelessWidget {
  const ScanFoodDetailPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

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
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSquareImage(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Spaghetti',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            _buildNutritionTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareImage() {
    return Container(
      width: 300,
      height: 350,
      child: Image.file(File(picture.path), fit: BoxFit.cover),
    );
  }

  Widget _buildNutritionTable(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 50),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Nutrition Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildNutritionRow('Calories', '300', 'cal'),
            _buildNutritionRow('Carbs', '20', 'gr'),
            _buildNutritionRow('Protein', '10', 'gr'),
            _buildNutritionRow('Fat', '13', 'gr'),
            _buildNutritionRow('Fiber', '2', 'gr'),
            _buildNutritionRow('Glucose', '2', 'gr'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // Aligns items along the Y-axis (vertically)
        children: [
          Text(
              label,
              style: const TextStyle(
                  fontSize: 18)
          ),
          Text(
            value + ' ' + unit,
            style: const TextStyle(
                fontSize: 18),
          ),
        ],
      ),
    );
  }
}
