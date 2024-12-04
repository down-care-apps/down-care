import 'package:down_care/api/reminderServices.dart';
import 'package:down_care/screens/home/reminder/reminder_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'reminder.dart';
import 'package:down_care/widgets/input_field.dart';

class AddReminderPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddReminderPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final ReminderServices _reminderServices = ReminderServices();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder', style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title:'),
              InputField(
                labelText: 'Title',
                hintText: 'Enter title',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Description:'),
              InputField(
                labelText: 'Description',
                hintText: 'Enter description',
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 10,
              ),
              const SizedBox(height: 16.0),
              _buildDateTimePicker(context),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newReminder = Reminder(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      time: _selectedTime,
                      date: _selectedDate,
                    );
                    try {
                      // Save the reminder
                      final savedReminder = _reminderServices.createReminder(newReminder.toJson()); 

                      // Show a success Snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Pengingat berhasil ditambahkan!'),
                          duration: const Duration(seconds: 2), 
                          backgroundColor: Colors.green,// Customize the duration
                        ),
                      );

                      // Navigate to the ReminderPage
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ReminderPage()),
                      );
                    } catch (e) {
                      // Show error Snackbar in case of failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Gagal menambahkan pengingat. Silahkan coba lagi.'),
                          backgroundColor: Colors.red, // Error color
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Add Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Date:'),
            _buildDateButton(context),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time:'),
            _buildTimeButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildDateButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextButton(
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) setState(() => _selectedDate = date);
        },
        child: Text(DateFormat('d MMM yyyy').format(_selectedDate)),
      ),
    );
  }

  Widget _buildTimeButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextButton(
        onPressed: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: _selectedTime,
          );
          if (time != null) setState(() => _selectedTime = time);
        },
        child: Text(_selectedTime.format(context)),
      ),
    );
  }
}
