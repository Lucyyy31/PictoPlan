import 'package:flutter/material.dart';
import '../session.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool notifications = true;
  bool sound = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Session.darkMode,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.grey[100],
          appBar: AppBar(
            backgroundColor: isDark ? Colors.grey[850] : Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Configuración',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            children: [
              _buildSwitch(
                'Modo oscuro',
                isDark,
                    (val) => Session.darkMode.value = val,
                isDark,
              ),
              _buildSwitch('Notificaciones', notifications, (val) {
                setState(() => notifications = val);
              }, isDark),
              _buildSwitch('Sonido', sound, (val) {
                setState(() => sound = val);
              }, isDark),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? Colors.white : Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      width: double.infinity,
                      color: isDark ? Colors.grey[800] : Colors.lightBlue[100],
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
                    _buildLearningOption('General', isDark),
                    _buildLearningOption('Sentimientos', isDark),
                    _buildLearningOption('Objetos', isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLearningOption(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder<String>(
        valueListenable: Session.learningTypeNotifier,
        builder: (context, selectedType, _) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
            value: selectedType == label,
            onChanged: (val) {
              if (val ?? false) {
                Session.learningType = label;
              }
            },
            title: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      value: value,
      activeColor: Colors.blue,
      onChanged: onChanged,
    );
  }
}
