import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:down_care/widgets/input_field.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String? selectedKid;
  DateTime selectedDate = DateTime.now();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController motoricController = TextEditingController();
  final TextEditingController cognitiveController = TextEditingController();
  final TextEditingController mentalController = TextEditingController();

  final List<String> kidsProfiles = ['Kid 1', 'Kid 2', 'Kid 3']; // Example profiles

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress Tracker", style: const TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedKid,
              hint: Text('Select Kid Profile'),
              items: kidsProfiles.map((String profile) {
                return DropdownMenuItem<String>(
                  value: profile,
                  child: Row(
                    children: [
                      CircleAvatar(child: Text(profile[0])), // Placeholder for profile pic
                      SizedBox(width: 8),
                      Text(profile),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedKid = newValue;
                });
              },
              // decoration: InputDecoration(
              //   suffixIcon: Icon(Icons.arrow_drop_down_outlined),
              // ),
            ),
            if (selectedKid != null) ...[
              TextButton(
                onPressed: () {
                  // Navigate to kid's growth statistics
                },
                child: Text('View Details'),
              ),
              SizedBox(height: 16),
              Text('Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Text(
                          DateFormat('d MMMM yyyy').format(selectedDate),
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.black.withOpacity(0.6)),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text('Weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                labelText: 'Weight',
                hintText: 'Enter weight',
                controller: weightController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text('Height', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                labelText: 'Height',
                hintText: 'Enter height',
                controller: heightController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text('Motoric Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                labelText: 'Motoric Growth',
                hintText: 'Enter motoric growth',
                controller: motoricController,
              ),
              SizedBox(height: 16),
              Text('Cognitive Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                labelText: 'Cognitive Growth',
                hintText: 'Enter cognitive growth',
                controller: cognitiveController,
              ),
              SizedBox(height: 16),
              Text('Mental Condition', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              InputField(
                labelText: 'Mental Condition',
                hintText: 'Enter mental condition',
                controller: mentalController,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Submit the progress
                },
                child: Text('Submit'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
