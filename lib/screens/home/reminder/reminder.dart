import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Map<String, dynamic> toJson() {
    return {
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
    DateTime parsedDate;
    TimeOfDay parsedTime;
    // Parse the date string to a DateTime object
    try {
      List<String> dateParts = json['date'].split(' ')[0].split('-');
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);
      parsedDate = DateTime(year, month, day);
    } catch (e) {
      parsedDate = DateTime(1970, 1, 1); // Handle invalid date format
    }

    // Parse the time string to a TimeOfDay object
    try {
      String timeString = json['time'];
      List<String> timeParts = timeString.split('(')[1].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1].split(')')[0]);
      parsedTime = TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      parsedTime = 'TimeOfDay(10:10)' as TimeOfDay; // Handle invalid time format
    }

    return Reminder(
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? '',
      time: parsedTime,
      date: parsedDate,
    );
  }
}
