import 'package:flutter/material.dart';

class AddEventoScreen extends StatefulWidget {
  const AddEventoScreen({super.key});

  @override
  State<AddEventoScreen> createState() => _AddEventoScreenState();
}

class _AddEventoScreenState extends State<AddEventoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  DateTime? _fechaSeleccionada;

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: isDark ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo pictograma'),
        backgroundColor: theme.appBarTheme.backgroundColor ?? (isDark ? Colors.grey[900] : Colors.grey[100]),
        iconTheme: theme.iconTheme,
        elevation: 1,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Nombre del pictograma',
                labelStyle: theme.textTheme.bodyMedium,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fechaSeleccionada == null
                        ? 'Selecciona una fecha'
                        : 'Fecha: ${_fechaSeleccionada!.toLocal().toString().split(' ')[0]}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () => _seleccionarFecha(context),
                  child: const Text('Elegir fecha'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
              ),
              onPressed: () {
                // Acción para subir imagen
              },
              icon: const Icon(Icons.image),
              label: const Text('Subir imagen'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                // Guardar pictograma
              },
              child: const Text('Guardar pictograma'),
            ),
          ],
        ),
      ),
    );
  }
}
