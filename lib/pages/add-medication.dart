import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:glutara_mobile/utils/format_utils.dart';
import 'package:glutara_mobile/utils/validators.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({Key? key}) : super(key: key);

  @override
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final GlobalKey<FormState> _formKeyInjection = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyPill = GlobalKey<FormState>();
  String saveFormattedDate = "";
  final TextEditingController doseUnitController = TextEditingController();
  final TextEditingController dateControllerInjection = TextEditingController();
  final TextEditingController timeControllerInjection = TextEditingController();

  final TextEditingController nameControllerPill = TextEditingController();
  final TextEditingController doseMgControllerPill = TextEditingController();
  final TextEditingController dateControllerPill = TextEditingController();
  final TextEditingController timeControllerPill = TextEditingController();
  DateTime? selectedStartDate;
  String? selectedInjectionType;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  Future<void> _handleSave(
      GlobalKey<FormState> _formKey, bool isInjection) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');
    String? token = prefs.getString('jwtToken');
    int medicationType = isInjection ? 0 : 1;
    String? category =
        isInjection ? selectedInjectionType : nameControllerPill.text;
    String dose = medicationType == 0
        ? doseUnitController.text
        : doseMgControllerPill.text;

    logger.d(jsonEncode(<String, dynamic>{
      "UserID": userID,
      "MedicationID": 1,
      "Type": medicationType,
      "Category": category,
      "Dose": int.tryParse(dose) ?? 0,
      "Date": DateFormat('yyyy-MM-dd')
              .format(DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate)) +
          "T00:00:00Z",
      "Time": FormatUtils.combineDateWithTime(
          DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate),
          TimeOfDay.fromDateTime(selectedStartDate!)),
    }));

    try {
      var response = await http.post(
        Uri.parse(
            'https://glutara-rest-api-reyoeq7kea-uc.a.run.app/api/$userID/medications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "UserID": userID,
          "MedicationID": 1,
          "Type": medicationType,
          "Category": category,
          "Dose": int.tryParse(dose) ?? 0,
          "Date": DateFormat('yyyy-MM-dd').format(
                  DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate)) +
              "T00:00:00Z",
          "Time": FormatUtils.combineDateWithTime(
              DateFormat('dd-MM-yyyy').parseLoose(saveFormattedDate),
              TimeOfDay.fromDateTime(selectedStartDate!)),
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
                msg: "Medication log saved successfully!",
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
  void dispose() {
    dateControllerInjection.dispose();
    timeControllerInjection.dispose();
    dateControllerPill.dispose();
    timeControllerPill.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Image.asset('assets/topbar-logo.png'),
          centerTitle: true,
          toolbarHeight: 60.0,
          elevation: 20,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Injection'),
              Tab(text: 'Pill'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // The Injection tab content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKeyInjection,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Medication',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 60.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Injection Type',
                                border: _border(Colors.grey),
                              ),
                              value: selectedInjectionType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedInjectionType = newValue;
                                });
                              },
                              items: [
                                'Long-acting',
                                'Medium-acting',
                                'Short-acting'
                              ]
                                  .map((String value) =>
                                      DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(width: 25.0),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: doseUnitController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Dose (unit)',
                                border: _border(Colors.grey),
                              ),
                              validator: Validators.numberValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: dateControllerInjection,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: _border(Colors.grey),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
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
                                DateFormat('EEEE, MMMM dd yyyy')
                                    .format(pickedDate);

                            setState(() {
                              dateControllerInjection.text =
                                  displayFormattedDate;
                            });
                          }
                        },
                        validator: Validators.notEmptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: timeControllerInjection,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: _border(Colors.grey),
                          suffixIcon: const Icon(Icons.watch_later_outlined),
                        ),
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
                              timeControllerInjection.text = DateFormat('HH:mm')
                                  .format(tempSelectedStartDate);
                            });
                          }
                        },
                        validator: Validators.notEmptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 60.0),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Save',
                              style: TextStyle(fontSize: 20.0)),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            primary: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            _handleSave(_formKeyInjection, true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // The Pill tab content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKeyPill,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Medication',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 60.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: nameControllerPill,
                              decoration: InputDecoration(
                                labelText: 'Pill Name',
                                border: _border(Colors.grey),
                              ),
                              validator: Validators.notEmptyValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(width: 25.0),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: doseMgControllerPill,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Dose (mg)',
                                border: _border(Colors.grey),
                              ),
                              validator: Validators.numberValidator,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: dateControllerPill,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: _border(Colors.grey),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
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
                                DateFormat('EEEE, MMMM dd yyyy')
                                    .format(pickedDate);

                            setState(() {
                              dateControllerPill.text = displayFormattedDate;
                            });
                          }
                        },
                        validator: Validators.notEmptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: timeControllerPill,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: _border(Colors.grey),
                          suffixIcon: const Icon(Icons.watch_later_outlined),
                        ),
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
                              timeControllerPill.text = DateFormat('HH:mm')
                                  .format(tempSelectedStartDate);
                            });
                          }
                        },
                        validator: Validators.notEmptyValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 60.0),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          child: const Text('Save',
                              style: TextStyle(fontSize: 20.0)),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            primary: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            _handleSave(_formKeyPill, false);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
