import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(title: const Text('Modo oscuro'), value: true, onChanged: (_) {}),
          SwitchListTile(title: const Text('Notificaciones'), value: true, onChanged: (_) {}),
          SwitchListTile(title: const Text('Sonido'), value: true, onChanged: (_) {}),
          ListTile(
            title: const Text('Tipo de aprendizaje'),
            trailing: DropdownButton<String>(
              value: 'General',
              items: const [
                DropdownMenuItem(value: 'General', child: Text('General')),
                DropdownMenuItem(value: 'Sentimientos', child: Text('Sentimientos')),
                DropdownMenuItem(value: 'Objetos', child: Text('Objetos')),
              ],
              onChanged: (_) {},
            ),
          )
        ],
      ),
    );
  }
}
