import 'package:flutter/material.dart';
import 'package:down_care/models/reminder.dart';
import 'package:down_care/api/reminder_services.dart';

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
      rethrow;
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
      final newReminder = await _reminderServices.createReminder(reminder.toJson());
      _reminders.add(Reminder.fromJson(newReminder));
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
      // Remove the reminder by id (not by title)
      _reminders.removeWhere((reminder) => reminder.id == id);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
