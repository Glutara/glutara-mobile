import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

final dummyData = [
  {'x': 0.0, 'y': 99},
  {'x': 1.0, 'y': 119},
  {'x': 2.0, 'y': 148},
  {'x': 3.0, 'y': 116},
  {'x': 4.0, 'y': 104},
  {'x': 5.0, 'y': 96},
  {'x': 6.0, 'y': 126},
  {'x': 7.0, 'y': 124},
  {'x': 8.0, 'y': 96},
  {'x': 9.0, 'y': 125},
  {'x': 10.0, 'y': 102},
  {'x': 11.0, 'y': 116},
  {'x': 12.0, 'y': 96},
  {'x': 13.0, 'y': 149},
  {'x': 14.0, 'y': 149},
  {'x': 15.0, 'y': 144},
  {'x': 16.0, 'y': 147},
  {'x': 17.0, 'y': 141},
  {'x': 18.0, 'y': 147},
  {'x': 19.0, 'y': 140},
  {'x': 20.0, 'y': 95},
  {'x': 21.0, 'y': 92},
  {'x': 22.0, 'y': 138},
  {'x': 23.0, 'y': 79},
];

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  List<FlSpot> getSpots() {
    return dummyData
        .map((data) => FlSpot(data['x']!.toDouble(), data['y']!.toDouble()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 23,
                minY: 0,
                maxY: 200,
                lineBarsData: [
                  LineChartBarData(
                    spots: getSpots(),
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.yellow,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Average glucose\n102 mg/dL\nYour glucose levels are quite good and relatively stable.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
