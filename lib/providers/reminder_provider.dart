import 'package:flutter/material.dart';
import 'package:down_care/models/reminder.dart';
import 'package:down_care/api/reminderServices.dart';

class ReminderProvider with ChangeNotifier {
  final ReminderServices _reminderServices = ReminderServices();
  List<Reminder> _reminders = [];
  bool _isLoading = false;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  // Fetch all reminders
  Future<void> fetchReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final reminderList = await _reminderServices.getAllReminders();
      _reminders = reminderList.map((reminderJson) => Reminder.fromJson(reminderJson)).toList();
    } catch (e) {
      throw Exception('Error fetching reminders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new reminder
  Future<void> createReminder(Reminder reminder) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Send the reminder to the server
      final newReminderData = await _reminderServices.createReminder(reminder.toJson());

      // Create a new Reminder object using the original data and the server-returned ID
      final createdReminder = Reminder(
        id: newReminderData['id'] ?? reminder.id,
        title: reminder.title,
        description: reminder.description,
        time: reminder.time,
        date: reminder.date,
      );

      _reminders.add(createdReminder);

      // Sort reminders
      _reminders.sort((a, b) => a.getDateTime().compareTo(b.getDateTime()));
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a reminder
  Future<void> deleteReminder(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _reminderServices.deleteReminder(id);
      _reminders.removeWhere((reminder) => reminder.id == id);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
