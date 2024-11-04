import 'package:flutter/material.dart';

// add placeholder for history diagnose that show this is history diagnose page
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder')),
      body: const Center(child: Text('History Page')),
    );
  }
}
