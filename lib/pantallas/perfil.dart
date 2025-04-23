import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'app_drawer.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // Drawer funcional
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false, // quitamos el back automático
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

      bottomNavigationBar: const BottomNavBar(currentIndex: 3),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                children: [
                  // FOTO DE PERFIL CON IMAGEN POR DEFECTO
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 90,
                          backgroundColor: Colors.blue[100],
                          backgroundImage: null, // Aquí iría una imagen si se carga
                          child: const Icon(
                            Icons.person,
                            size: 110,
                            color: Colors.white70,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: () {
                                // lógica para cambiar la imagen
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // CAMPOS REDUCIDOS ESTÁTICOS
                  _buildInfoField(label: 'Usuario', value: 'User10'),
                  const SizedBox(height: 12),
                  _buildInfoField(label: 'Email', value: 'user.10@gmail.com'),
                  const SizedBox(height: 12),
                  _buildInfoField(label: 'Contraseña', value: '12345678'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar campos de perfil de forma simple y estética
  Widget _buildInfoField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade400),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
