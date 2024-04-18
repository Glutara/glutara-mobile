import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({Key? key}) : super(key: key);

  @override
  _AddMedicationPageState createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  bool isPill = true;
  String? pillName;
  int? dose;
  String? injectionType;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showNotification = false;
  int currentPageIndex = 0;

  void _onDateChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedDate = args.value;
    });
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // This function can be used to save the medication data
  void _saveMedication() {
    // Implement your save logic here
    // You can use pillName, dose, injectionType, selectedDate, and selectedTime as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Image.asset('assets/topbar-logo.png'),
        backgroundColor: const Color(0xFFF5EDDF),
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
                'Add Medication',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ToggleButtons(
                children: const [Text('Injection'), Text('Pill')],
                isSelected: [!isPill, isPill],
                onPressed: (int index) {
                  setState(() {
                    isPill = index != 0;
                  });
                },
              ),
              if (isPill) ...[
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Pill Name',
                    labelStyle: TextStyle(color: Color(0xFF715C0C)),
                  ),
                  onChanged: (value) => pillName = value,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Dose (mg)',
                    labelStyle: TextStyle(color: Color(0xFF715C0C)),
                  ),
                  onChanged: (value) => dose = int.tryParse(value),
                  keyboardType: TextInputType.number,
                ),
              ] else ...[
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select Injection Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: injectionType,
                      isDense: true,
                      isExpanded: true,
                      hint: Text('Select Injection Type'),
                      items: <String>[
                        'Long-acting',
                        'Rapid-acting',
                        'Short-acting'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          injectionType = newValue;
                        });
                      },
                    ),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Dose (unit)'),
                  onChanged: (value) => dose = int.tryParse(value),
                  keyboardType: TextInputType.number,
                ),
              ],
              SfDateRangePicker(
                onSelectionChanged: _onDateChanged,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedDate: selectedDate,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: TextStyle(color: Colors.black),
                  todayTextStyle: TextStyle(color: Colors.black),
                ),
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selectionColor: Colors.amber,
                todayHighlightColor: Colors.amber,
              ),
              TextButton(
                onPressed: () => _selectTime(context),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.access_time, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Select Time: ${selectedTime.format(context)}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.amber,
                  onSurface: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
