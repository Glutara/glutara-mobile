import 'package:flutter/material.dart';
import 'package:glutara_mobile/utils/validators.dart';
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

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  Future<void> _handleSave(GlobalKey<FormState> _formKey) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userID = prefs.getInt('userID');

    try {} catch (error) {
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
          bottom: TabBar(
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
                      Text(
                        'Add Medication',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 60.0),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Injection Type',
                                border: _border(Colors.grey),
                              ),
                              onChanged: (String? newValue) {
                                // Handle change
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
                          SizedBox(width: 25.0),
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
                      SizedBox(height: 25),
                      TextFormField(
                        controller: dateControllerInjection,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: _border(Colors.grey),
                          suffixIcon: Icon(Icons.calendar_today),
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
                      SizedBox(height: 25),
                      TextFormField(
                        controller: timeControllerInjection,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: _border(Colors.grey),
                          suffixIcon: Icon(Icons.watch_later_outlined),
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
                            _handleSave(_formKeyInjection);
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
                      Text(
                        'Add Medication',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 60.0),
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
                          SizedBox(width: 25.0),
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
                      SizedBox(height: 25),
                      TextFormField(
                        controller: dateControllerPill,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          border: _border(Colors.grey),
                          suffixIcon: Icon(Icons.calendar_today),
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
                      SizedBox(height: 25),
                      TextFormField(
                        controller: timeControllerPill,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: _border(Colors.grey),
                          suffixIcon: Icon(Icons.watch_later_outlined),
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
                            _handleSave(_formKeyPill);
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
