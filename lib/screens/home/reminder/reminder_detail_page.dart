import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'reminder.dart';

class ReminderDetailPage extends StatelessWidget {
  final Reminder reminder;

  const ReminderDetailPage({Key? key, required this.reminder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parsedTime = reminder.stringTime(reminder.time);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Details', style: TextStyle(color: Colors.white, fontSize: 24)),
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
            Text(reminder.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            Text(DateFormat('dd-MM-yyyy').format(reminder.date)),
            const SizedBox(height: 8.0),
            Text(parsedTime),
            const SizedBox(height: 16.0),
            Text(reminder.description),
          ],
        ),
      ),
    );
  }
}
