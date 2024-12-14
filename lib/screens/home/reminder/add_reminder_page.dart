import 'package:down_care/widgets/date_time_input.dart';
import 'package:flutter/material.dart';

import 'package:down_care/api/reminderServices.dart';
import 'package:down_care/widgets/input_field.dart';
import 'package:down_care/widgets/custom_button.dart';
import '../../../models/reminder.dart';

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

  final ReminderServices _reminderServices = ReminderServices();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  void _saveReminder() {
    if (_formKey.currentState!.validate()) {
      final newReminder = Reminder(
        title: _titleController.text,
        description: _descriptionController.text,
        time: _selectedTime,
        date: _selectedDate,
      );

      try {
        _reminderServices.createReminder(newReminder.toJson());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengingat berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan pengingat. Silahkan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
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
              text: 'Tambahkan',
              onPressed: _saveReminder,
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
