import 'package:flutter/material.dart';

import '../widgets/notification_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => const NotificationItem(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: 10,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
