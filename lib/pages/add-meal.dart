import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({Key? key}) : super(key: key);
  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  TextEditingController caloriesController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String saveFormattedDate = "";

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
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Meal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60.0),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Meal Name',
                        labelStyle: TextStyle(color: Color(0xFF715C0C)),
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                      ),
                    ),
                  ),
                  SizedBox(width: 25.0),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Calories',
                        labelStyle: TextStyle(color: Color(0xFF715C0C)),
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Meal Type',
                  labelStyle: TextStyle(color: Color(0xFF715C0C)),
                  border: _border(Colors.grey),
                  focusedBorder: _border(Color(0xFF715C0C)),
                ),
                items: ['Breakfast', 'Lunch', 'Dinner']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  // Handle change
                },
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: Color(0xFF715C0C)),
                  border: _border(Colors.grey),
                  focusedBorder: _border(Color(0xFF715C0C)),
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
              SizedBox(height: 25),
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
                        suffixIcon: Icon(Icons.watch_later_outlined),
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
                  SizedBox(width: 25),
                  Expanded(
                    child: TextFormField(
                      controller: endTimeController,
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        labelStyle: TextStyle(color: Color(0xFF715C0C)),
                        border: _border(Colors.grey),
                        focusedBorder: _border(Color(0xFF715C0C)),
                        suffixIcon: Icon(Icons.watch_later_outlined),
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
                            endTimeController.text =
                                DateFormat('HH:mm').format(tempSelectedEndDate);
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
                    primary: Color(0xFF715C0C),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: () {
                    // TODO: Implement save functionality
                  },
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
