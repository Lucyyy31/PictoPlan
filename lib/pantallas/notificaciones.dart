import 'package:flutter/material.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView(
        children: const [
          NotificationItem(title: 'Nueva actividad', description: 'Añadido nuevo pictograma'),
          NotificationItem(title: 'Nueva actividad', description: 'Añadido nuevo pictograma'),
          NotificationItem(title: 'Aviso', description: 'Ha cambiado tu rutina'),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  const NotificationItem({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}