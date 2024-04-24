import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glutara_mobile/utils/format_utils.dart';
import 'package:glutara_mobile/utils/validators.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({Key? key}) : super(key: key);
  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController mealController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int? selectedMealType;
  String? saveFormattedDate;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void dispose() {
    dateController.dispose();
    caloriesController.dispose();
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

    // Log information before sending the HTTP request
    logger.d("Preparing to save the meal with the following details:");
    logger.d("Name: ${mealController.text}");
    logger.d("Calories: ${caloriesController.text}");
    logger.d("Type: $selectedMealType");
    logger.d("Date: ${FormatUtils.formatToIsoDate(saveFormattedDate)}");
    logger.d(
        "Start Time: ${FormatUtils.combineDateWithTime(DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate!), TimeOfDay.fromDateTime(selectedStartDate!))}");
    logger.d(
        "End Time: ${FormatUtils.combineDateWithTime(DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate!), TimeOfDay.fromDateTime(selectedEndDate!))}");
    logger.d(jsonEncode(<String, dynamic>{
      "UserID": userID,
      "MealID": 1,
      "Name": mealController.text,
      "Calories": int.tryParse(caloriesController.text) ?? 0,
      "Type": selectedMealType,
      "Date": FormatUtils.formatToIsoDate(saveFormattedDate),
      "StartTime": FormatUtils.combineDateWithTime(
          DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate!),
          TimeOfDay.fromDateTime(selectedStartDate!)),
      "EndTime": FormatUtils.combineDateWithTime(
          DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate!),
          TimeOfDay.fromDateTime(selectedEndDate!)),
    }));

    try {
      var response = await http.post(
        Uri.parse(
            'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/meals'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "UserID": userID,
          "MealID": 1,
          "Name": mealController.text,
          "Calories": int.tryParse(caloriesController.text) ?? 0,
          "Type": selectedMealType,
          "Date": FormatUtils.formatToIsoDate(saveFormattedDate),
          "StartTime": FormatUtils.combineDateWithTime(
              DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate!),
              TimeOfDay.fromDateTime(selectedStartDate!)),
          "EndTime": FormatUtils.combineDateWithTime(
              DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate!),
              TimeOfDay.fromDateTime(selectedEndDate!)),
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
                msg: "Meal log saved successfully!",
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
                  'Add Meal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 60.0),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: mealController,
                        decoration: InputDecoration(
                          labelText: 'Meal Name',
                          border: _border(Colors.grey),
                        ),
                        validator: Validators.notEmptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(width: 25.0),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Calories',
                          border: _border(Colors.grey),
                        ),
                        validator: Validators.numberValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Meal Type',
                    border: _border(Colors.grey),
                  ),
                  value: selectedMealType,
                  items: ['Breakfast', 'Lunch', 'Dinner']
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
                      selectedMealType = newValue;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: _border(Colors.grey),
                    suffixIcon: const Icon(Icons.calendar_today),
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
                      saveFormattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate);
                      String displayFormattedDate =
                          DateFormat('EEEE, MMMM dd yyyy').format(pickedDate);

                      setState(() {
                        dateController.text = displayFormattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Start Time',
                          border: _border(Colors.grey),
                          suffixIcon: const Icon(Icons.watch_later_outlined),
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
                    const SizedBox(width: 25),
                    Expanded(
                      child: TextFormField(
                        controller: endTimeController,
                        decoration: InputDecoration(
                          labelText: 'End Time',
                          border: _border(Colors.grey),
                          suffixIcon: const Icon(Icons.watch_later_outlined),
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
                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: () {
                      _handleSave();
                    },
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
