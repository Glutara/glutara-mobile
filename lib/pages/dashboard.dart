import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:glutara_mobile/utils/format_utils.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../color_schemes.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

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

class _DashboardPageState extends State<DashboardPage> {
  DateTime selectedDate = DateTime.now();
  int selectedSegment = 0; // 0: Today, 1: This Week, 2: This Month
  List<FlSpot> spots = [];
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchGlucose();
    _fetchAverage();
  }

  List<FlSpot> getSpots() {
    return dummyData
        .map((data) => FlSpot(data['x']!.toDouble(), data['y']!.toDouble()))
        .toList();
  }

  Future<void> _fetchAverage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');

    try {
      var response = await http.get(Uri.parse(
          'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/glucoses/info/average'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          // Update the insights data directly with fetched averages.
          insightsData['today']['averageGlucose'] =
              '110 mg/dL';
          insightsData['thisWeek']['averageGlucose'] =
              '${data['Week'].toStringAsFixed(2)} mg/dL';
          insightsData['thisMonth']['averageGlucose'] =
              '${data['Month'].toStringAsFixed(2)} mg/dL';
        });
      }
    } catch (e) {
      logger.e("Error fetching averages: $e");
    }
  }

  Future<void> _fetchGlucose() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userID = prefs.getInt('userID');

    try {
      logger.f("MASUKK");
      logger.f("MASUKK");
      logger.f("MASUKK");
      Uri uri = Uri.parse(
              'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/glucoses/info/graphic')
          .replace(queryParameters: {
        "Date": FormatUtils.formatToIsoDateTime(selectedDate),
      });
      logger.f("YESS");
      logger.f("YESS");
      logger.f("YESS");
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      logger.f(response.body);
      logger.f(response.body);
      logger.f(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        logger.f(data);
        logger.f(data);
        logger.f(data);

        List<FlSpot> fetchedSpots = data.map((entry) {
          double x = FormatUtils.formatTimeAsDouble(entry['Time']);
          double y = entry['Prediction'].toDouble();
          return FlSpot(x, y);
        }).toList();

        logger.f(fetchedSpots);
        logger.f(fetchedSpots);
        logger.f(fetchedSpots);

        setState(() {
          spots = fetchedSpots;
        });

        logger.f(selectedDate);
        logger.f(data);
      }
    } catch (e) {
      logger.e("Error fetching logs: $e");
    }
  }

  Map<int, Widget> segmentedWidgets = const {
    0: Text('Today'),
    1: Text('This Week'),
    2: Text('This Month'),
  };

  // Patient data for insights
  final Map<String, dynamic> insightsData = {
    'today': {
      'averageGlucose': "0",
      'sleep': '8h 30m',
      'exercise': '500 cal',
    },
    'thisWeek': {
      'averageGlucose': "0",
      'sleep': '8h 10m',
      'exercise': '750 cal',
    },
    'thisMonth': {
      'averageGlucose': "0",
      'sleep': '8h 20m',
      'exercise': '600 cal',
    },
  };

  void changeDate(bool increment) {
    setState(() {
      DateTime now = DateTime.now();

      if (increment) {
        if (selectedDate.isBefore(DateTime(now.year, now.month, now.day))) {
          selectedDate = selectedDate.add(const Duration(days: 1));
        }
      } else {
        selectedDate = selectedDate.subtract(const Duration(days: 1));
      }

      _fetchGlucose();
      logger.f(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayFormat = DateFormat('EEEE');
    final dateFormat = DateFormat('MMMM d');

    String displayDay = dayFormat.format(selectedDate);
    String displayDate = dateFormat.format(selectedDate);
    DateTime today = DateTime.now();

    bool isToday = selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day;

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
                icon: Icon(
                  Icons.chevron_right,
                  color: isToday
                      ? Colors.grey.withOpacity(0.3)
                      : Theme.of(context).primaryColor,
                ),
                onPressed:
                    isToday ? null : () => changeDate(true), // Disable if today
              ),
            ],
          ),
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Theme.of(context).colorScheme.onPrimary,
                      tooltipBorder: const BorderSide(
                          width: 2, color: CustomColors.brandColor),
                      tooltipRoundedRadius: 20,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y} mg/dL',
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: const FlGridData(show: true, verticalInterval: 3.0),
                  titlesData: const FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
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
                        reservedSize: 35,
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
                      isCurved: true,
                      color: CustomColors.brandColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.brandColor.withOpacity(0.3),
                            Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
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
    // Get the data for the current selected segment
    var currentData = insightsData[selectedSegment == 0
        ? 'today'
        : selectedSegment == 1
            ? 'thisWeek'
            : 'thisMonth'];
    return Column(
      children: [
        Container(
          color: Theme.of(context).colorScheme.onSecondary,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSegment('Today', 0),
              _buildSegment('This week', 1),
              _buildSegment('This month', 2),
            ],
          ),
        ),
        Card(
          elevation: 2,
          margin: const EdgeInsets.all(16.0),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Average glucose',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentData['averageGlucose'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
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
              _buildInfoCard('Sleep', currentData['sleep'], 'assets/sleep.png'),
              _buildInfoCard(
                  'Exercise', currentData['exercise'], 'assets/exercise.png'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegment(String text, int value) {
    bool isSelected = selectedSegment == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSegment = value;
          // No need to update the data here since it's done in the build method
        });
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                ),
              )
            : null,
        padding:
            const EdgeInsets.symmetric(vertical: 8.0), // Add padding if needed
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
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
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onBackground,
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
