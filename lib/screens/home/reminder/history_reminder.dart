import 'package:down_care/api/reminder_services.dart';
import 'package:down_care/widgets/skeleton_reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:down_care/widgets/card_reminder.dart';

class ReminderHistoryPage extends StatefulWidget {
  const ReminderHistoryPage({super.key});

  @override
  _ReminderHistoryPageState createState() => _ReminderHistoryPageState();
}

class _ReminderHistoryPageState extends State<ReminderHistoryPage> {
  Future<List<Map<String, dynamic>>> _fetchHistoryReminders() async {
    final allReminders = await ReminderServices().getAllReminders();
    final currentDateTime = DateTime.now();

    return allReminders.where((reminder) {
      final reminderDate = _parseDate(reminder['date']);
      final reminderTime = _parseTime(reminder['time']);
      final reminderDateTime = DateTime(reminderDate.year, reminderDate.month, reminderDate.day, reminderTime.hour, reminderTime.minute);

      return reminderDateTime.isBefore(currentDateTime);
    }).toList()
      ..sort((a, b) {
        final dateA = _parseDate(a['date']);
        final dateB = _parseDate(b['date']);
        return dateB.compareTo(dateA);
      });
  }

  DateTime _parseDate(String date) => DateFormat('yyyy-MM-dd').parse(date.split(' ')[0]);

  TimeOfDay _parseTime(dynamic timeData) {
    if (timeData == null) return TimeOfDay.now();

    if (timeData is TimeOfDay) return timeData;

    if (timeData is String) {
      final cleanedTime = timeData.replaceAll('TimeOfDay(', '').replaceAll(')', '');
      final parts = cleanedTime.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pengingat', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchHistoryReminders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) => const SkeletonReminderItem(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Tidak ada riwayat pengingat', style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final reminder = snapshot.data![index];

              return ReminderItem(
                reminder: reminder,
              );
            },
          );
        },
      ),
    );
  }
}
