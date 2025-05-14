import 'package:flutter/material.dart';

class reminderDetailScreen extends StatelessWidget {
  const reminderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(title: const Text("Reminder Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${args['title']}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Time: ${args['time']}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
