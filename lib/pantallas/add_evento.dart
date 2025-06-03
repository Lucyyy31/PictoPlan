import 'dart:typed_data';
import 'package:flutter/material.dart';

class AddEventoScreen extends StatefulWidget {
  const AddEventoScreen({super.key});

  @override
  State<AddEventoScreen> createState() => _AddEventoScreenState();
}

class _AddEventoScreenState extends State<AddEventoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  DateTime? _fechaSeleccionada;
  Uint8List? _imagenEvento;
// Función para seleccionar la fecha
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
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
// Función para guardar el evento
  void _guardarEvento() {
    if (_nombreController.text.isEmpty || _fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    Navigator.pop(context);
  }
// Vista de la interfaz
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        title: Text(
          'Nuevo evento',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Imagen del evento
            GestureDetector(
              onTap: () {
                // Acción para subir imagen
              },
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: _imagenEvento != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(_imagenEvento!, fit: BoxFit.cover),
                )
                    : Icon(Icons.image, size: 60, color: colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Sube una imagen para el evento'),

            const SizedBox(height: 30),

            // Nombre del evento
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del evento',
                filled: true,
                fillColor: colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Selección de fecha
            GestureDetector(
              onTap: () => _seleccionarFecha(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: colorScheme.primary),
                    const SizedBox(width: 10),
                    Text(
                      _fechaSeleccionada == null
                          ? 'Selecciona una fecha'
                          : _fechaSeleccionada!.toLocal().toString().split(' ')[0],
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botón guardar
            ElevatedButton(
              onPressed: _guardarEvento,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Guardar evento', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
