import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSleepPage extends StatefulWidget {
  const AddSleepPage({Key? key}) : super(key: key);

  @override
  _AddSleepPageState createState() => _AddSleepPageState();
}

class _AddSleepPageState extends State<AddSleepPage> {
  bool showNotification = false;
  int currentPageIndex = 0;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Sleep',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60.0),
              TextFormField(
                controller: startTimeController,
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  border: _border(Colors.grey),
                  prefixIcon: Icon(Icons.watch_later_outlined),
                  hintText: selectedStartDate != null
                      ? DateFormat('dd MMM yyyy HH:mm')
                          .format(selectedStartDate!)
                      : 'Select start time', // Tampilkan tanggal yang dipilih atau pesan 'Select start time'
                ),
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
              SizedBox(height: 25.0),
              TextFormField(
                controller: endTimeController,
                decoration: InputDecoration(
                  labelText: 'End Time',
                  border: _border(Colors.grey),
                  prefixIcon: Icon(Icons.watch_later_outlined),
                  hintText: selectedEndDate != null
                      ? DateFormat('dd MMM yyyy HH:mm').format(selectedEndDate!)
                      : 'Select end time', // Tampilkan tanggal yang dipilih atau pesan 'Select end time'
                ),
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
                        endTimeController.text = DateFormat('dd MMM yyyy HH:mm')
                            .format(selectedEndDate!);
                      });
                    }
                  }
                },
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
