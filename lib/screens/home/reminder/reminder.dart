import 'package:flutter/material.dart';

class Reminder {
  final String title;
  final String description;
  final TimeOfDay time;
  final DateTime date;

  Reminder({
    required this.title,
    required this.description,
    required this.time,
    required this.date,
  });

  Reminder copyWith({String? title, String? description, TimeOfDay? time, DateTime? date}) {
    return Reminder(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }

  DateTime getDateTime() {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
