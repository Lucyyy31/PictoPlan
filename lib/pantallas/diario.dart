import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class DiarioScreen extends StatelessWidget {
  const DiarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eventos importantes')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Añadir evento'),
            ),
            const SizedBox(height: 20),
            EventCard(date: '04 / 03 / 2025', description: 'Visita a los abuelos'),
            EventCard(date: '25 / 02 / 2025', description: 'Hice un dibujo'),
            EventCard(date: '14 / 11 / 2024', description: 'Comí mi comida favorita'),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date;
  final String description;
  const EventCard({super.key, required this.date, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(date),
        subtitle: Text(description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.edit),
            SizedBox(width: 10),
            Icon(Icons.delete),
          ],
        ),
      ),
    );
  }
}