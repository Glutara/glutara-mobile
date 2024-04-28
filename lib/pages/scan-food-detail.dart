import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ScanFoodDetailPage extends StatelessWidget {
  const ScanFoodDetailPage(
      {Key? key, required this.picture, required this.foodData})
      : super(key: key);

  final XFile picture;
  final Map<String, dynamic> foodData;

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
            _buildFoodNameWidget(),
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

  Widget _buildFoodNameWidget() {
    final String foodName = foodData['foodname'] ?? 'Unknown Food';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        foodName,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNutritionTable(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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
            const SizedBox(height: 1),
            Text(
              '*Data is based on per serving',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            _buildNutritionRow(
              'Calories',
              foodData['calories']?.toString() ?? '-',
              'cal',
            ),
            _buildNutritionRow(
              'Carbs',
              foodData['carbs']?.toString() ?? '-',
              'gr',
            ),
            _buildNutritionRow(
              'Protein',
              foodData['protein']?.toString() ?? '-',
              'gr',
            ),
            _buildNutritionRow(
              'Fat',
              foodData['fat']?.toString() ?? '-',
              'gr',
            ),
            _buildNutritionRow(
              'Fiber',
              foodData['fiber']?.toString() ?? '-',
              'gr',
            ),
            _buildNutritionRow(
              'Glucose',
              foodData['glucose']?.toString() ?? '-',
              'gr',
            ),
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
        crossAxisAlignment: CrossAxisAlignment
            .center, // Aligns items along the Y-axis (vertically)
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(
            value + ' ' + unit,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
