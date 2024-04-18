import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExercisePage extends StatefulWidget {
  const AddExercisePage({Key? key}) : super(key: key);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  String saveFormattedDate = "";
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        backgroundColor: Colors.amber[50],
        centerTitle: true,
        toolbarHeight: 60.0,
        elevation: 20,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Exercise',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                  labelStyle: TextStyle(color: Color(0xFF715C0C)),
                  border: _border(Colors.grey),
                  focusedBorder: _border(Color(0xFF715C0C)),
                ),
              ),
              SizedBox(height: 25.0),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Intensity',
                  labelStyle: TextStyle(color: Color(0xFF715C0C)),
                  border: _border(Colors.grey),
                  focusedBorder: _border(Color(0xFF715C0C)),
                ),
                items: ['Low', 'Medium', 'High']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 25.0),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
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
                        labelStyle: TextStyle(color: Color(0xFF715C0C)),
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                      onTap: () async {
                        final TimeOfDay? pickedStartTime = await showTimePicker(
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
                  SizedBox(width: 25.0),
                  Expanded(
                    child: TextFormField(
                      controller: endTimeController,
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        labelStyle: TextStyle(color: Color(0xFF715C0C)),
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                        suffixIcon: Icon(Icons.access_time),
                      ),
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
                  SizedBox(width: 25.0),
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
                    primary: Color(0xFF715C0C),
                  ),
                  onPressed: () {
                    // Code to save sleep data
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
