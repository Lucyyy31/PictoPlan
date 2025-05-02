import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'app_drawer.dart';
import 'entrada_diario.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  // Lista de eventos
  List<EventData> events = [
    EventData(date: '04 / 03 / 2025', description: 'Visita a los abuelos'),
    EventData(date: '25 / 02 / 2025', description: 'Hice un dibujo'),
    EventData(date: '14 / 11 / 2024', description: 'Comí mi comida favorita'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/imagenes/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'PictoPlan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Eventos importantes',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddEntryScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Añadir evento',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Lista de eventos
                  ...events.map((event) => EventCard(
                    date: event.date,
                    description: event.description,
                    onDelete: () {
                      setState(() {
                        events.remove(event); // Eliminar evento de la lista
                      });
                    },
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventData {
  final String date;
  final String description;

  EventData({required this.date, required this.description});
}

class EventCard extends StatelessWidget {
  final String date;
  final String description;
  final VoidCallback onDelete; // Callback para eliminar el evento

  const EventCard({
    super.key,
    required this.date,
    required this.description,
    required this.onDelete, // Requiere el callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // FECHA + TEXTO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // SIMULACIÓN DE IMAGEN
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.image, color: Colors.white),
          ),

          const SizedBox(width: 10),

          // ICONOS DE ACCIÓN
          Column(
            children: [
              const Icon(Icons.edit, size: 20),
              const SizedBox(height: 12),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete, // Llamar al callback de eliminación
              ),
            ],
          ),
        ],
      ),
    );
  }
}
