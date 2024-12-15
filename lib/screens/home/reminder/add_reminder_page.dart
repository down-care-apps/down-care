import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:down_care/widgets/date_time_input.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';
import 'package:down_care/models/reminder.dart';
import 'package:down_care/providers/reminder_provider.dart';
// ignore_for_file: use_build_context_synchronously

class AddReminderPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddReminderPage({super.key, required this.selectedDate});

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  void _saveReminder() async {
    if (_formKey.currentState!.validate()) {
      // Create a DateTime combining the selected date and time
      final selectedDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

      // Check if the selected date and time is in the past
      final now = DateTime.now();
      if (selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('waktu di masa depan'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final newReminder = Reminder(
        id: UniqueKey().toString(), // Generate a unique ID
        title: _titleController.text,
        description: _descriptionController.text,
        time: _selectedTime,
        date: _selectedDate,
      );

      try {
        // Use the provider to create the reminder
        await Provider.of<ReminderProvider>(context, listen: false).createReminder(newReminder);

        await Provider.of<ReminderProvider>(context, listen: false).fetchReminders();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengingat berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan pengingat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Tambah Pengingat', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputField(
                      labelText: 'Judul',
                      hintText: 'Masukkan judul',
                      controller: _titleController,
                      validator: (value) => value == null || value.isEmpty ? 'Silahkan masukkan judul' : null,
                    ),
                    const SizedBox(height: 16.0),
                    InputField(
                      labelText: 'Deskripsi',
                      hintText: 'Masukkan deskripsi',
                      controller: _descriptionController,
                      minLines: 5,
                      validator: (value) => value == null || value.isEmpty ? 'Silakan masukkan deskripsi' : null,
                    ),
                    const SizedBox(height: 16.0),
                    DateTimeInputField(
                      initialDate: _selectedDate,
                      initialTime: _selectedTime,
                      onDateChanged: (date) => setState(() => _selectedDate = date),
                      onTimeChanged: (time) => setState(() => _selectedTime = time),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              widthFactor: 1.0,
              text: _isSubmitting ? 'Menambahkan...' : 'Tambahkan',
              onPressed: _isSubmitting ? () {} : _saveReminder,
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
