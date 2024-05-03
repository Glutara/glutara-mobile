import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:glutara_mobile/utils/format_utils.dart';
import 'package:glutara_mobile/utils/validators.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AddSleepPage extends StatefulWidget {
  const AddSleepPage({Key? key}) : super(key: key);

  @override
  _AddSleepPageState createState() => _AddSleepPageState();
}

class _AddSleepPageState extends State<AddSleepPage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String saveFormattedDate = "";
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    String? token = prefs.getString('jwtToken');

    logger.d(jsonEncode(<String, dynamic>{
      "UserID": userID,
      "SleepID": 0,
      "StartTime": FormatUtils.combineDateWithTime(
          selectedStartDate, TimeOfDay.fromDateTime(selectedStartDate!)),
      "EndTime": FormatUtils.combineDateWithTime(
          selectedStartDate, TimeOfDay.fromDateTime(selectedEndDate!)),
    }));

    try {
      var response = await http.post(
        Uri.parse(
            'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/sleeps'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "UserID": userID,
          "SleepID": 0,
          "StartTime": FormatUtils.combineDateWithTime(
              selectedStartDate, TimeOfDay.fromDateTime(selectedStartDate!)),
          "EndTime": FormatUtils.combineDateWithTime(
              selectedStartDate, TimeOfDay.fromDateTime(selectedEndDate!)),
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
                msg: "Sleep log saved successfully!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0)
            .then((value) => Navigator.pop(context));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        centerTitle: true,
        toolbarHeight: 60.0,
        elevation: 20,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Add Sleep',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60.0),
                TextFormField(
                  controller: startTimeController,
                  decoration: InputDecoration(
                    labelText: 'Start Time',
                    border: _border(Colors.grey),
                    prefixIcon: const Icon(Icons.watch_later_outlined),
                    hintText: selectedStartDate != null
                        ? DateFormat('dd MMM yyyy HH:mm')
                            .format(selectedStartDate!)
                        : 'Select start time', // Tampilkan tanggal yang dipilih atau pesan 'Select start time'
                  ),
                  validator: Validators.notEmptyValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedStartDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedStartDate != null
                            ? TimeOfDay.fromDateTime(selectedStartDate!)
                            : TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedStartDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          startTimeController.text =
                              DateFormat('dd MMM yyyy HH:mm')
                                  .format(selectedStartDate!);
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 25.0),
                TextFormField(
                  controller: endTimeController,
                  decoration: InputDecoration(
                    labelText: 'End Time',
                    border: _border(Colors.grey),
                    prefixIcon: const Icon(Icons.watch_later_outlined),
                    hintText: selectedEndDate != null
                        ? DateFormat('dd MMM yyyy HH:mm')
                            .format(selectedEndDate!)
                        : 'Select end time', // Tampilkan tanggal yang dipilih atau pesan 'Select end time'
                  ),
                  validator: Validators.notEmptyValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedEndDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedEndDate != null
                            ? TimeOfDay.fromDateTime(selectedEndDate!)
                            : TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedEndDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          endTimeController.text =
                              DateFormat('dd MMM yyyy HH:mm')
                                  .format(selectedEndDate!);
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 60.0),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: const Text('Save', style: TextStyle(fontSize: 20.0)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      primary: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      _handleSave();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
