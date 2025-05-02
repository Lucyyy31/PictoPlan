import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'app_drawer.dart';
import 'add_pictogram.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Tu rutina',
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
                        MaterialPageRoute(builder: (context) => const AddPictogramaScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Añadir evento',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Lista de rutinas
                  RoutineItem(name: 'Despertarse', time: '07:30', completed: true),
                  RoutineItem(name: 'Ir al baño', time: '07:35', completed: true),
                  RoutineItem(name: 'Desayunar', time: '07:45', completed: true),
                  RoutineItem(name: 'Vestirse', time: '08:20', completed: false),
                  RoutineItem(name: 'Ir al colegio', time: '8:45', completed: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoutineItem extends StatelessWidget {
  final String name;
  final String time;
  final bool completed;

  const RoutineItem({
    super.key,
    required this.name,
    required this.time,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          // Imagen simulada
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.image, color: Colors.white),
          ),
          const SizedBox(width: 10),

          // Nombre y hora
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Checkbox de completado
          Checkbox(
            value: completed,
            onChanged: (value) {
              // lógica para marcar completado
            },
          ),

          // Íconos editar y borrar
          const SizedBox(width: 10),
          const Icon(Icons.edit, size: 20),
          const SizedBox(width: 10),
          const Icon(Icons.delete, size: 20),
        ],
      ),
    );
  }
}
