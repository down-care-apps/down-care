import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String title;
  final String description;
  final TimeOfDay time;
  final DateTime date;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.date,
  });

  Reminder copyWith({String? id, String? title, String? description, TimeOfDay? time, DateTime? date}) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }

  DateTime getDateTime() {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toString(),
      'time': time.toString(),
    };
  }

  String stringTime(time) {
    String timeString = time.toString();
    List<String> timeParts = timeString.split('(')[1].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1].split(')')[0]);
    String parsedTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return parsedTime;
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: _parseTimeOfDay(json['time']),
      date: _parseDateTime(json['date']),
    );
  }

  // Helper method to parse DateTime
  static DateTime _parseDateTime(dynamic dateInput) {
    if (dateInput == null) return DateTime.now();

    if (dateInput is DateTime) return dateInput;

    try {
      // Handle different date string formats
      return DateTime.parse(dateInput.toString().split(' ')[0]);
    } catch (e) {
      return DateTime.now();
    }
  }

  // Helper method to parse TimeOfDay
  static TimeOfDay _parseTimeOfDay(dynamic timeInput) {
    if (timeInput == null) return TimeOfDay.now();

    if (timeInput is TimeOfDay) return timeInput;

    try {
      String timeString = timeInput.toString();

      // Handle 'TimeOfDay(10:30)' format
      if (timeString.contains('TimeOfDay(')) {
        timeString = timeString.replaceAll('TimeOfDay(', '').replaceAll(')', '');
      }

      // Split and parse hours and minutes
      List<String> timeParts = timeString.split(':');
      return TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    } catch (e) {
      return TimeOfDay.now();
    }
  }
}
