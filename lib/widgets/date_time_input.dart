// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeInputField extends StatefulWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const DateTimeInputField({
    super.key,
    required this.initialDate,
    required this.initialTime,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  @override
  DateTimeInputFieldState createState() => DateTimeInputFieldState();
}

class DateTimeInputFieldState extends State<DateTimeInputField> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
  }

  bool _isValidDateTime(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final currentTime = TimeOfDay.now();

    // If selected date is today
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      // Convert TimeOfDay to minutes for easier comparison
      final selectedTimeInMinutes = time.hour * 60 + time.minute;
      final currentTimeInMinutes = currentTime.hour * 60 + currentTime.minute;

      // Return true only if selected time is after or equal to current time
      return selectedTimeInMinutes >= currentTimeInMinutes;
    }

    // For future dates, always return true
    return date.isAfter(now) || date.isAtSameMomentAs(now);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tanggal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(), // Prevent selecting dates before today
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      // If selected date is today, validate time
                      if (_isValidDateTime(date, _selectedTime)) {
                        setState(() => _selectedDate = date);
                        widget.onDateChanged(date);
                      } else {
                        // If time is invalid for today, reset time to current time
                        final now = DateTime.now();
                        final currentTime = TimeOfDay.fromDateTime(now);

                        setState(() {
                          _selectedDate = date;
                          _selectedTime = currentTime;
                        });

                        widget.onDateChanged(date);
                        widget.onTimeChanged(currentTime);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('d MMM yyyy').format(_selectedDate),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waktu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.fromSeed(
                              seedColor: Theme.of(context).colorScheme.primary,
                              primary: Theme.of(context).colorScheme.primary,
                            ),
                            timePickerTheme: TimePickerThemeData(
                              backgroundColor: Colors.white,
                              hourMinuteColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              hourMinuteTextColor: Colors.black87,
                              dialHandColor: Theme.of(context).colorScheme.primary,
                              dialBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              dayPeriodColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              dayPeriodTextColor: Colors.black87,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      // Validate date and time
                      if (_isValidDateTime(_selectedDate, time)) {
                        setState(() => _selectedTime = time);
                        widget.onTimeChanged(time);
                      } else {
                        // If time is invalid, show a message and keep current time
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pilih waktu setelah ${TimeOfDay.now().format(context)}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTime.format(context),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
