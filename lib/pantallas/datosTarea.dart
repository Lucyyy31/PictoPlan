import 'package:flutter/material.dart';

class DatosTareaScreen extends StatefulWidget {
  final String tareaNombre;

  const DatosTareaScreen({super.key, required this.tareaNombre});

  @override
  State<DatosTareaScreen> createState() => _DatosTareaScreenState();
}

class _DatosTareaScreenState extends State<DatosTareaScreen> {
  final TextEditingController _nombreController = TextEditingController();
  int _hora = TimeOfDay.now().hour;
  int _minuto = TimeOfDay.now().minute;

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.tareaNombre;
  }

  void _mostrarSelectorHora() {
    int tempHora = _hora;
    int tempMinuto = _minuto;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selecciona la hora',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeColumn(
                        label: 'Hora',
                        value: tempHora,
                        onIncrement: () => setModalState(() => tempHora = (tempHora + 1) % 24),
                        onDecrement: () => setModalState(() => tempHora = (tempHora - 1 + 24) % 24),
                      ),
                      const SizedBox(width: 30),
                      _buildTimeColumn(
                        label: 'Minuto',
                        value: tempMinuto,
                        onIncrement: () => setModalState(() => tempMinuto = (tempMinuto + 1) % 60),
                        onDecrement: () => setModalState(() => tempMinuto = (tempMinuto - 1 + 60) % 60),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hora = tempHora;
                        _minuto = tempMinuto;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildTimeColumn({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up, size: 30),
          onPressed: onIncrement,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
          onPressed: onDecrement,
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final horaFormateada = '${_hora.toString().padLeft(2, '0')} : ${_minuto.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Datos de la tarea',
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen cuadrada del pictograma
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.image, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // Nombre editable
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre de la tarea',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Hora seleccionada (simula contenedor)
            GestureDetector(
              onTap: _mostrarSelectorHora,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 10),
                    Text(
                      'Hora seleccionada: $horaFormateada',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarea guardada a las $horaFormateada')),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text(
                  'Guardar tarea',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
