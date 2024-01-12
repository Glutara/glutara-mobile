import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

final dummyData = [
  {'x': 00.00, 'y': 99},
  {'x': 02.59, 'y': 119},
  {'x': 04.39, 'y': 148},
  {'x': 06.48, 'y': 116},
  {'x': 08.00, 'y': 104},
  {'x': 09.58, 'y': 96},
  {'x': 11.40, 'y': 126},
  {'x': 13.50, 'y': 124},
  {'x': 15.20, 'y': 96},
  {'x': 16.38, 'y': 125},
  {'x': 18.10, 'y': 102},
  {'x': 19.45, 'y': 116},
  {'x': 21.20, 'y': 96},
  {'x': 22.45, 'y': 149},
  {'x': 23.24, 'y': 149},
];

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();

  List<FlSpot> getSpots() {
    return dummyData
        .map((data) => FlSpot(data['x']!.toDouble(), data['y']!.toDouble()))
        .toList();
  }

  void changeDate(bool increment) {
    setState(() {
      if (increment) {
        if (selectedDate.isBefore(DateTime.now())) {
          selectedDate = selectedDate.add(Duration(days: 1));
        }
      } else {
        selectedDate = selectedDate.subtract(Duration(days: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('EEEE');
    final dateFormat = DateFormat('MMMM d');

    String displayDay = dayFormat.format(selectedDate);
    String displayDate = dateFormat.format(selectedDate);

    if (DateTime.now().difference(selectedDate).inDays == 0 &&
        selectedDate.day == DateTime.now().day) {
      displayDay = 'Today';
      displayDate = '';
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => changeDate(false),
              ),
              Column(
                children: <Widget>[
                  Text(displayDay,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (displayDate.isNotEmpty) Text(displayDate),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => changeDate(true),
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.white,
                      tooltipBorder:
                          BorderSide(width: 2, color: Color(0xFFFF6B42)),
                      tooltipRoundedRadius: 20,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y} mg/dL',
                            const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(show: true, verticalInterval: 3.0),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 24,
                  minY: 0,
                  maxY: 200,
                  lineBarsData: [
                    LineChartBarData(
                      spots: getSpots(),
                      isCurved: false,
                      color: Color(0xFFFF6B42),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightsSection(),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('Today', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('This week'),
              Text('This month'),
            ],
          ),
        ),
        Card(
          elevation: 2,
          margin: const EdgeInsets.all(16.0),
          color: Color(0xFFFEE086), // Replace with your card's background color
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Average glucose',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '102 mg/dL',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your glucose levels are quite good and relatively stable.',
                ),
              ],
            ),
          ),
        ),
        // The row for additional info cards (Sleep and Exercise)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoCard('Sleep', '7h 15m', 'assets/sleep.png'),
              _buildInfoCard('Exercise', '850cal', 'assets/exercise.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, String imagePath) {
    return Expanded(
      child: Card(
        elevation: 2, // Adds a subtle shadow to the card
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Row(
            children: [
              Image.asset(
                imagePath, // Path to your asset image
                height: 40, // Set the image size
              ),
              const SizedBox(
                  width: 16), // Spacing between the image and the text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors
                          .grey[800], // Adjust the color to match your design
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
