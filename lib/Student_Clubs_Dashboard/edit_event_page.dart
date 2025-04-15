import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventPage extends StatefulWidget {
  final String documentId;
  final String eventName;
  final String eventDescription;
  final DateTime startDate;
  final DateTime endDate;
  final String eventVenue;
  final String eventImage;
  final int attendees;
  final bool isPaid;
  final double price;
  final String club;
  final String status;

  const EditEventPage({
    super.key,
    required this.documentId,
    required this.eventName,
    required this.eventDescription,
    required this.startDate,
    required this.endDate,
    required this.eventVenue,
    required this.eventImage,
    required this.isPaid,
    required this.attendees,
    required this.price,
    required this.club,
    required this.status,
  });

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _venueController;
  late TextEditingController _priceController;
  bool _isPaid = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.eventName);
    _descController = TextEditingController(text: widget.eventDescription);
    _venueController = TextEditingController(text: widget.eventVenue);
    _priceController = TextEditingController(text: widget.price.toString());
    _isPaid = widget.isPaid;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _venueController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance.collection('events').doc(widget.documentId).update({
        'Event Name': _nameController.text,
        'Event Description': _descController.text,
        'Event Venue': _venueController.text,
        'Payment Info': {
          'isPaid': _isPaid,
          'price': _isPaid ? double.parse(_priceController.text) : 0.0,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event updated successfully!")),
      );

      Navigator.pop(context); // Go back after saving
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update event: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Event")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Event Name"),
                validator: (value) => value!.isEmpty ? "Please enter a name" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Event Description"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(labelText: "Venue"),
              ),
              SwitchListTile(
                title: const Text("Paid Event"),
                value: _isPaid,
                onChanged: (value) => setState(() => _isPaid = value),
              ),
              if (_isPaid)
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Event Fee"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (_isPaid && (value == null || double.tryParse(value) == null)) {
                      return "Enter a valid price";
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEvent,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}