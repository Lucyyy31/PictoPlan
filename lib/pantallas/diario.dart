import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class DiarioScreen extends StatelessWidget {
  const DiarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: Column(
        children: [
          // CABECERA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'lib/imagenes/logo.png',
                  height: 50,
                ),
                const Text(
                  'PictoPlan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.menu, size: 35),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TÍTULO
                  const Text(
                    'Eventos importantes',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // BOTÓN AÑADIR EVENTO
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
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Añadir evento',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // EVENTOS
                  EventCard(
                    date: '04 / 03 / 2025',
                    description: 'Visita a los abuelos',
                  ),
                  EventCard(
                    date: '25 / 02 / 2025',
                    description: 'Hice un dibujo',
                  ),
                  EventCard(
                    date: '14 / 11 / 2024',
                    description: 'Comí mi comida favorita',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date;
  final String description;

  const EventCard({
    super.key,
    required this.date,
    required this.description,
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
            offset: Offset(0, 2),
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
            children: const [
              Icon(Icons.edit, size: 20),
              SizedBox(height: 12),
              Icon(Icons.delete, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
