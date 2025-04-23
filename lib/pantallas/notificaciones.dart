import 'package:flutter/material.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          NotificationItem(
            iconType: NotificationIconType.activity,
            title: 'Nueva actividad',
            description: 'Añadido nuevo pictograma',
          ),
          NotificationItem(
            iconType: NotificationIconType.activity,
            title: 'Nueva actividad',
            description: 'Añadido nuevo pictograma',
          ),
          NotificationItem(
            iconType: NotificationIconType.alert,
            title: 'Aviso',
            description: 'Ha cambiado tu rutina',
          ),
          NotificationItem(
            iconType: NotificationIconType.activity,
            title: 'Nueva actividad',
            description: 'Eliminado pictograma',
          ),
          NotificationItem(
            iconType: NotificationIconType.alert,
            title: 'Aviso',
            description: 'Ha cambiado tu rutina',
          ),
        ],
      ),
    );
  }
}

enum NotificationIconType { activity, alert }

class NotificationItem extends StatelessWidget {
  final NotificationIconType iconType;
  final String title;
  final String description;

  const NotificationItem({
    super.key,
    required this.iconType,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.3),
        ),
      ),
      child: Row(
        children: [
          // ÍCONO
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: iconType == NotificationIconType.activity
                ? const Icon(Icons.event_note, color: Colors.blueAccent)
                : const Icon(Icons.notifications_none, color: Colors.orangeAccent),
          ),
          const SizedBox(width: 12),

          // TEXTO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
