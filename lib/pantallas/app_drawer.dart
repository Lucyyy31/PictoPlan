import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
// Vista de la interfaz del menú hamburguesa
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[100];

    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        children: [
          /*
          _buildDrawerItem(
            icon: Icons.notifications_outlined,
            text: 'Notificaciones',
            onTap: () => Navigator.pushNamed(context, '/notificaciones'),
            textColor: textColor,
          ),
           */
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Configuración',
            onTap: () => Navigator.pushNamed(context, '/configuracion'),
            textColor: textColor,
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            text: 'Ayuda',
            onTap: () => Navigator.pushNamed(context, '/ayuda'),
            textColor: textColor,
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Salir',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 28, color: textColor),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
