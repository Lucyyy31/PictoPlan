import 'package:flutter/material.dart';
import '../session.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  bool notifications = Session.notifications.value;

  final List<String> coloresDisponibles = [
    'rosa',
    'amarillo',
    'verde',
    'azul',
    'lila',
    'naranja',
    'marron',
    'cyan',
  ];

  final Map<String, Color> colorMap = {
    'rosa': Colors.pink[200]!,
    'amarillo': Colors.yellow[300]!,
    'verde': Colors.green[300]!,
    'azul': Colors.blue[300]!,
    'lila': Colors.purple[200]!,
    'naranja': Colors.orange[200]!,
    'marron': Colors.brown[200]!,
    'cyan': Colors.lightBlue[200]!,
  };

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
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Configuración', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            children: [
              _buildCheckbox(
                'Modo oscuro',
                isDark,
                Session.darkMode.value,
                    (val) {
                  setState(() {
                    Session.darkMode.value = val!;
                  });
                },
                isDark,
              ),
              _buildCheckbox(
                'Notificaciones',
                isDark,
                notifications,
                    (val) {
                  setState(() {
                    notifications = val!;
                    Session.notifications.value = val;
                  });
                },
                isDark,
              ),
              const SizedBox(height: 16),
              Text(
                'Colores para aprender (elige 4)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<List<String>>(
                valueListenable: Session.selectedColors,
                builder: (context, selected, _) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: coloresDisponibles.map((color) {
                      final isSelected = selected.contains(color);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              Session.selectedColors.value = List.from(selected)..remove(color);
                            } else if (selected.length < 4) {
                              Session.selectedColors.value = List.from(selected)..add(color);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorMap[color],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            color,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
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
                        children: [
                          Text(
                            'Tipo de aprendizaje',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Icon(Icons.arrow_drop_up, color: isDark ? Colors.white : Colors.black),
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

  Widget _buildCheckbox(String title, bool isDark, bool value, ValueChanged<bool?> onChanged, bool theme) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: theme ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
