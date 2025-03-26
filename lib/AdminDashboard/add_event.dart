import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Theme/theme_provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  String eventName = '';
  String eventDescription = '';
  DateTime? startDate;
  DateTime? endDate;
  String eventLocation = '';
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isPaid = false;
  double eventFee = 0.0;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Event Name", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter event name' : null,
                onSaved: (value) => eventName = value!,
              ),
              const SizedBox(height: 16),

              const Text("Event Description", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                maxLines: 3,
                onSaved: (value) => eventDescription = value!,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, true),
                          child: Text(startDate == null ? 'Select Start Date' : '${startDate!.toLocal()}'.split(' ')[0]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("End Date", style: TextStyle(fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: () => _selectDate(context, false),
                          child: Text(endDate == null ? 'Select End Date' : '${endDate!.toLocal()}'.split(' ')[0]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Start Time", style: TextStyle(fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, true),
                          child: Text(startTime == null ? 'Start Time' : startTime!.format(context)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("End Time", style: TextStyle(fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: () => _selectTime(context, false),
                          child: Text(endTime == null ? 'End Time' : endTime!.format(context)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text("Event Venue", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter event venue' : null,
                onSaved: (value) => eventLocation = value!,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text("Is this a paid event?"),
                  Checkbox(
                    value: isPaid,
                    onChanged: (value) => setState(() => isPaid = value!),
                  ),
                ],
              ),

              if (isPaid)
                TextFormField(
                  decoration: const InputDecoration(hintText: "Enter fee amount", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => eventFee = double.parse(value!),
                ),

              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text("Create Event"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event '$eventName' added successfully!")),
      );
    }
  }

}