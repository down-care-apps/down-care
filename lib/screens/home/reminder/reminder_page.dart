// ignore_for_file: use_build_context_synchronously

import 'package:down_care/providers/reminder_provider.dart';
import 'package:down_care/screens/home/reminder/history_reminder.dart';
import 'package:down_care/utils/transition.dart';
import 'package:down_care/widgets/skeleton_reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'add_reminder_page.dart';
import 'package:down_care/widgets/card_reminder.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  ReminderPageState createState() => ReminderPageState();
}

class ReminderPageState extends State<ReminderPage> {
  DateTime _selectedDay = DateTime.now();
  bool _showAllReminders = true;

  @override
  void initState() {
    super.initState();
    // Fetch reminders when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReminderProvider>(context, listen: false).fetchReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 16),
          _buildReminderList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddReminder(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text('Pengingat', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary),
          onSelected: (value) {
            switch (value) {
              case 'history':
                Navigator.push(context, createRoute(const ReminderHistoryPage()));
                break;
              case 'all_reminders':
                setState(() {
                  _showAllReminders = true;
                });
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'history',
              child: Row(
                children: [
                  Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  const Text('Riwayat'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'all_reminders',
              child: Row(
                children: [
                  Icon(Icons.list, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  const Text('Mendatang'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    initializeDateFormatting('id');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
      child: TableCalendar(
        locale: 'id',
        focusedDay: _selectedDay,
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, _) => setState(() {
          _selectedDay = selectedDay;
          _showAllReminders = false;
        }),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          titleTextFormatter: (date, locale) {
            return DateFormat.yMMMM('id').format(date);
          },
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return Center(
              child: Text(
                day.day.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReminderList() {
    return Expanded(
      child: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, child) {
          // Show loading skeleton while fetching
          if (reminderProvider.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) => const SkeletonReminderItem(),
            );
          }

          // Check if no reminders exist
          if (reminderProvider.reminders.isEmpty) {
            return _buildEmptyState('Tidak ada pengingat', Icons.calendar_today);
          }

          // Convert reminders to Map for compatibility with existing code
          final reminderMaps = reminderProvider.reminders.map((r) => r.toJson()).toList();

          // Filter out past reminders only for 'All Reminders' view
          final currentDateTime = DateTime.now();
          final reminders = _showAllReminders
              ? reminderMaps.where((reminder) {
                  final reminderDate = _parseDate(reminder['date']);
                  final reminderTime = _parseTime(reminder['time']);
                  final reminderDateTime = DateTime(reminderDate.year, reminderDate.month, reminderDate.day, reminderTime.hour, reminderTime.minute);

                  return reminderDateTime.isAfter(currentDateTime);
                }).toList()
              : reminderMaps;

          final filteredReminders = (_showAllReminders ? reminders : _filterRemindersByDate(reminders)).toList()..sort(_sortReminders);

          return filteredReminders.isEmpty
              ? _buildEmptyState(_showAllReminders ? 'Tidak ada pengingat mendatang' : 'Tidak ada pengingat pada tanggal ini', Icons.event_busy)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredReminders.length,
                  itemBuilder: (context, index) => ReminderItem(
                    reminder: filteredReminders[index],
                  ),
                );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _filterRemindersByDate(List<Map<String, dynamic>> reminders) {
    return reminders.where((reminder) {
      final reminderDate = _parseDate(reminder['date']);
      return isSameDay(reminderDate, _selectedDay);
    }).toList();
  }

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

  int _sortReminders(Map<String, dynamic> a, Map<String, dynamic> b) {
    final currentDateTime = DateTime.now();
    final dateA = _parseDate(a['date']);
    final dateB = _parseDate(b['date']);
    final timeA = _parseTime(a['time']);
    final timeB = _parseTime(b['time']);

    final dateTimeA = DateTime(dateA.year, dateA.month, dateA.day, timeA.hour, timeA.minute);
    final dateTimeB = DateTime(dateB.year, dateB.month, dateB.day, timeB.hour, timeB.minute);

    // Check if events are past
    final isPastA = dateTimeA.isBefore(currentDateTime);
    final isPastB = dateTimeB.isBefore(currentDateTime);

    // If both are past or both are future, sort by date and time
    if (isPastA == isPastB) {
      return dateTimeA.compareTo(dateTimeB);
    }

    // Move past events to the bottom
    return isPastA ? 1 : -1;
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
        ],
      ),
    );
  }

  void _navigateToAddReminder(BuildContext context) async {
    await Navigator.push(
      context,
      createRoute(AddReminderPage(selectedDate: _selectedDay)),
    );
  }

  DateTime _parseDate(String date) => DateFormat('yyyy-MM-dd').parse(date.split(' ')[0]);
}
