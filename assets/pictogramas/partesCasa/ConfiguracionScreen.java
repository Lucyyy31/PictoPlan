import 'package:flutter/material.dart';
import '../session.dart'; // Asegúrate de tener una clase Session para guardar el tipo de aprendizaje

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool darkMode = true;
  bool notifications = true;
  bool sound = true;
  String selectedType = 'General'; // Estado para el tipo de aprendizaje

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
          'Configuración',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        children: [
          // SWITCHES
          _buildSwitch('Modo oscuro', darkMode, (val) {
            setState(() => darkMode = val);
          }),
          _buildSwitch('Notificaciones', notifications, (val) {
            setState(() => notifications = val);
          }),
          _buildSwitch('Sonido', sound, (val) {
            setState(() => sound = val);
          }),
          const SizedBox(height: 24),

          // TIPO DE APRENDIZAJE
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  width: double.infinity,
                  color: Colors.lightBlue[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Tipo de aprendizaje',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_drop_up),
                    ],
                  ),
                ),
                _buildLearningOption('General'),
                _buildLearningOption('Sentimientos'),
                _buildLearningOption('Objetos'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      value: value,
      activeColor: Colors.blue,
      onChanged: onChanged,
    );
  }

  Widget _buildLearningOption(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.trailing,
        value: selectedType == label,
        onChanged: (val) {
          setState(() {
            selectedType = label;
            // Guardar la opción seleccionada en la clase Session
            Session.learningType = selectedType;
          });
        },
        title: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
