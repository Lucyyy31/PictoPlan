import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[100],
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        children: [
          _buildDrawerItem(
            icon: Icons.notifications_outlined,
            text: 'Notificaciones',
            onTap: () {
              Navigator.pushNamed(context, '/notificaciones');
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Configuración',
            onTap: () {
              Navigator.pushNamed(context, '/configuracion');
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            text: 'Ayuda',
            onTap: () {
              Navigator.pushNamed(context, '/ayuda');
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Salir',
            onTap: () {
              // Cierra el drawer primero
              Navigator.pop(context);
              // Luego reemplaza la ruta por login (elimina historial anterior)
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
