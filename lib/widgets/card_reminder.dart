import 'package:down_care/models/reminder.dart';
import 'package:down_care/screens/home/reminder/reminder_detail_page.dart';
import 'package:down_care/utils/transition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ReminderItem extends StatelessWidget {
  final Map<String, dynamic> reminder;

  const ReminderItem({required this.reminder, super.key});

  DateTime _parseDate(String date) => DateFormat('yyyy-MM-dd').parse(date.split(' ')[0]);
  DateTime _parseDateTime(String date, String? time) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date.split(' ')[0]);

    if (time != null && time.isNotEmpty) {
      List<String> timeParts = time.replaceAll('TimeOfDay(', '').replaceAll(')', '').split(':');
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, hours, minutes);
    }

    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 23, 59);
  }

  bool _isPastReminder(String date, String? time) {
    DateTime reminderDateTime = _parseDateTime(date, time);

    return reminderDateTime.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id');

    final reminderDate = _parseDate(reminder['date']);
    final isPastReminder = _isPastReminder(reminder['date'], reminder['time']);
    final dateFormatter = DateFormat('d MMM yyyy', 'id');
    Color primaryColor = isPastReminder ? Colors.grey.shade400 : Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          createRoute(ReminderDetailPage(reminder: Reminder.fromJson(reminder))),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(border: Border(left: BorderSide(color: primaryColor, width: 4))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder['title'],
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: isPastReminder ? Colors.grey.shade600 : Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          reminder['description'],
                          style: TextStyle(color: isPastReminder ? Colors.grey.shade500 : Colors.grey.shade700, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          dateFormatter.format(reminderDate),
                          style: TextStyle(fontSize: 11, color: primaryColor.withOpacity(0.7), fontWeight: FontWeight.w600),
                        ),
                        Text(
                          reminder['time'] != null
                              ? reminder['time'].toString().replaceAll('TimeOfDay(', '').replaceAll(')', '')
                              : 'Waktu Tidak Diketahui',
                          style: TextStyle(fontSize: 11, color: primaryColor.withOpacity(0.7), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
