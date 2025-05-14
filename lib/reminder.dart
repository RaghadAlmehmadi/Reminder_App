
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/browser.dart' as tz;
import 'package:timezone/data/latest.dart' as tz show initializeTimeZones;
import 'package:timezone/timezone.dart' as tz;
import 'main.dart';

class reminderInputScreen extends StatefulWidget {
  const reminderInputScreen({super.key});

  @override
  State<reminderInputScreen> createState() => _reminderInputScreenState();
}

class _reminderInputScreenState extends State<reminderInputScreen> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _pickTime() async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _scheduleReminder() async {
    if (_titleController.text.isEmpty || _selectedTime == null) return;

    final now = DateTime.now();
    final scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final notificationTime = scheduledDateTime.isBefore(now)
        ? scheduledDateTime.add(const Duration(days: 1))
        : scheduledDateTime;

    tz.initializeTimeZones();
    final tzDateTime = tz.TZDateTime.from(notificationTime, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'reminder_channel_id',
      'Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      _titleController.text,
      'Reminder Notification',
      tzDateTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    Navigator.pushNamed(
      context,
      '/detail',
      arguments: {
        'title': _titleController.text,
        'time': _selectedTime!.format(context),
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final String timeText =
    _selectedTime != null ? _selectedTime!.format(context) : "Pick Time";

    return Scaffold(
      appBar: AppBar(title: const Text('Set Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Reminder Title'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Time: $timeText'),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _pickTime,
                  child: const Text('Choose Time'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _scheduleReminder,
              child: const Text('Schedule Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
