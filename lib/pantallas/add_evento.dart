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
    );
    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo pictograma')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del pictograma'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fechaSeleccionada == null
                        ? 'Selecciona una fecha'
                        : 'Fecha: ${_fechaSeleccionada!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _seleccionarFecha(context),
                  child: const Text('Elegir fecha'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.image),
              label: const Text('Subir imagen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes guardar el evento con la fecha seleccionada
              },
              child: const Text('Guardar pictograma'),
            ),
          ],
        ),
      ),
    );
  }
}
