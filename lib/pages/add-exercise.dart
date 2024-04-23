import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:glutara_mobile/utils/format_utils.dart';
import 'package:glutara_mobile/utils/validators.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key? key}) : super(key: key);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  String saveFormattedDate = "";
  int? selectedIntensityType;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void dispose() {
    dateController.dispose();
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

    logger.d(jsonEncode(<String, dynamic>{
      "UserID": userID,
      "ExerciseID": 1,
      "Name": nameController.text,
      "Intensity": selectedIntensityType,
      "Date": FormatUtils.formatToIsoDate(saveFormattedDate),
      "StartTime": FormatUtils.combineDateWithTime(
          DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate),
          TimeOfDay.fromDateTime(selectedStartDate!)),
      "EndTime": FormatUtils.combineDateWithTime(
          DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate),
          TimeOfDay.fromDateTime(selectedEndDate!)),
    }));

    try {
      var response = await http.post(
        Uri.parse(
            'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/${userID}/exercises'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "UserID": userID,
          "ExerciseID": 0,
          "Name": nameController.text,
          "Intensity": selectedIntensityType,
          "Date": FormatUtils.formatToIsoDate(saveFormattedDate),
          "StartTime": FormatUtils.combineDateWithTime(
              DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate),
              TimeOfDay.fromDateTime(selectedStartDate!)),
          "EndTime": FormatUtils.combineDateWithTime(
              DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate),
              TimeOfDay.fromDateTime(selectedEndDate!)),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
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
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add Exercise',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 60.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Exercise Name',
                    border: _border(Colors.grey),
                  ),
                  validator: Validators.notEmptyValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 25.0),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Intensity',
                    border: _border(Colors.grey),
                  ),
                  value: selectedIntensityType,
                  items: ['Low', 'Medium', 'High']
                      .asMap()
                      .entries
                      .map((MapEntry<int, String> entry) =>
                          DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedIntensityType = newValue;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: Validators.notEmptyValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));
                    if (pickedDate != null) {
                      // Format the date for saving
                      saveFormattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);

                      // Format the date for displaying
                      String displayFormattedDate =
                          DateFormat('EEEE, MMMM dd yyyy').format(pickedDate);

                      setState(() {
                        dateController.text =
                            displayFormattedDate; // Update the text field with the display date
                      });
                    }
                  },
                ),
                SizedBox(height: 25.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Start Time',
                          border: _border(Colors.grey),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        validator: Validators.notEmptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        onTap: () async {
                          final TimeOfDay? pickedStartTime =
                              await showTimePicker(
                            context: context,
                            initialTime: selectedStartDate != null
                                ? TimeOfDay.fromDateTime(selectedStartDate!)
                                : TimeOfDay.now(),
                          );
                          if (pickedStartTime != null) {
                            DateTime tempSelectedStartDate = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              pickedStartTime.hour,
                              pickedStartTime.minute,
                            );
                            setState(() {
                              selectedStartDate = tempSelectedStartDate;
                              startTimeController.text = DateFormat('HH:mm')
                                  .format(tempSelectedStartDate);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: TextFormField(
                        controller: endTimeController,
                        decoration: InputDecoration(
                          labelText: 'End Time',
                          border: _border(Colors.grey),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        validator: Validators.notEmptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                        onTap: () async {
                          final TimeOfDay? pickedEndTime = await showTimePicker(
                            context: context,
                            initialTime: selectedEndDate != null
                                ? TimeOfDay.fromDateTime(selectedEndDate!)
                                : TimeOfDay.now(),
                          );
                          if (pickedEndTime != null) {
                            DateTime tempSelectedEndDate = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              pickedEndTime.hour,
                              pickedEndTime.minute,
                            );
                            setState(() {
                              selectedEndDate = tempSelectedEndDate;
                              endTimeController.text = DateFormat('HH:mm')
                                  .format(tempSelectedEndDate);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.0),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    child: Text('Save', style: TextStyle(fontSize: 20.0)),
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
