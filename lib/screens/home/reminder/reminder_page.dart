import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'reminder.dart';
import 'reminder_detail_page.dart';
import 'add_reminder_page.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Reminder>> _reminders = {};

  List<Reminder> _getAllReminders() {
    return _reminders.entries.expand((entry) => entry.value.map((r) => r.copyWith(date: entry.key))).toList()
      ..sort((a, b) => a.getDateTime().compareTo(b.getDateTime()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder', style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(child: _buildRemindersList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newReminder = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReminderPage(selectedDate: _selectedDay)),
          );
          if (newReminder != null) {
            setState(() {
              _reminders[_selectedDay] ??= [];
              _reminders[_selectedDay]!.add(newReminder);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _selectedDay,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _selectedDay = selectedDay);
      },
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        todayBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        markerBuilder: (context, date, events) {
          if (_reminders[date] != null && _reminders[date]!.isNotEmpty) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                date.day.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRemindersList() {
    return ListView(
      children: _getAllReminders().map((reminder) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReminderDetailPage(reminder: reminder),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(reminder.title),
                  Text(
                    DateFormat('d MMM yyyy').format(reminder.date),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      reminder.description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    reminder.time.format(context),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
