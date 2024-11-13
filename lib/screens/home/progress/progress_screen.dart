import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/screens/home/progress/detail_progress.dart';
import 'package:down_care/api/childrens_service.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final ChildrensService _childrensService = ChildrensService();
  String? selectedKid;
  Map<String, dynamic>? selectedKidData;
  DateTime selectedDate = DateTime.now();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController motoricController = TextEditingController();
  final TextEditingController cognitiveController = TextEditingController();
  final TextEditingController mentalController = TextEditingController();

  List<Map<String, dynamic>> children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      final List<dynamic> data = await _childrensService.getAllChildrens();
      setState(() {
        children = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load children: $e')),
      );
    }
  }

  Future<void> _loadChildDetails(String childId) async {
    try {
      final data = await _childrensService.getChildrenById(childId);
      setState(() {
        selectedKidData = data;
        // Pre-fill the form with existing data if available
        weightController.text = data['weight']?.toString() ?? '';
        heightController.text = data['height']?.toString() ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load child details: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress Tracker", 
          style: TextStyle(color: Colors.white, fontSize: 24)
        ),
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
              hint: const Text('Select Kid Profile'),
              items: children.map((child) {
                return DropdownMenuItem<String>(
                  value: child['id'].toString(),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          child['imageUrl'] ?? 'https://example.com/default_image.jpg'
                        ),
                        child: child['imageUrl'] == null 
                          ? Text(child['name']?[0] ?? '?') 
                          : null,
                      ),
                      const SizedBox(width: 8),
                      Text(child['name'] ?? 'Unnamed Child'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedKid = newValue;
                  if (newValue != null) {
                    _loadChildDetails(newValue);
                  }
                });
              },
            ),
            if (selectedKid != null) ...[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProgress(kidProfile: selectedKidData!['name']),
                    ),
                  );
                },
                child: const Text('View Details'),
              ),
              const SizedBox(height: 16),
              const Text('Date', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
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
                      icon: Icon(Icons.calendar_today, 
                        color: Colors.black.withOpacity(0.6)
                      ),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Weight', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              InputField(
                // labelText: 'Weight',
                hintText: 'Enter weight',
                controller: weightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text('Height', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              InputField(
                // labelText: 'Height',
                hintText: 'Enter height',
                controller: heightController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text('Motoric Growth', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              InputField(
                // labelText: 'Motoric Growth',
                hintText: 'Enter motoric growth',
                controller: motoricController,
              ),
              const SizedBox(height: 16),
              const Text('Cognitive Growth', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              InputField(
                // labelText: 'Cognitive Growth',
                hintText: 'Enter cognitive growth',
                controller: cognitiveController,
              ),
              const SizedBox(height: 16),
              const Text('Mental Condition', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              InputField(
                // labelText: 'Mental Condition',
                hintText: 'Enter mental condition',
                controller: mentalController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Submit the progress
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    motoricController.dispose();
    cognitiveController.dispose();
    mentalController.dispose();
    super.dispose();
  }
}