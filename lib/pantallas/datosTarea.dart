import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:picto_plan/pantallas/seleccionar_pictograma.dart';
import '../database_helper.dart';
import 'add_pictogram.dart';

class DatosTareaScreen extends StatefulWidget {
  final String tareaNombre;
  final String correoUsuario;
  final Function onTareaAgregada;

  const DatosTareaScreen({
    super.key,
    required this.tareaNombre,
    required this.correoUsuario,
    required this.onTareaAgregada,
  });

  @override
  _DatosTareaScreenState createState() => _DatosTareaScreenState();
}

class _DatosTareaScreenState extends State<DatosTareaScreen> {
  late DatabaseHelper _databaseHelper;
  late TextEditingController _nombreController;
  late TextEditingController _horaController;

  int _hora = TimeOfDay.now().hour;
  int _minuto = TimeOfDay.now().minute;

  String? _selectedPictogramaId;
  String? _selectedPictogramaNombre;
  Uint8List? _selectedPictogramaImagen;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _nombreController = TextEditingController(text: widget.tareaNombre);
    _horaController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _horaController.dispose();
    super.dispose();
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
                  const Text('Selecciona la hora', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                        _horaController.text = '${_hora.toString().padLeft(2, '0')}:${_minuto.toString().padLeft(2, '0')}';
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
        IconButton(icon: const Icon(Icons.keyboard_arrow_up, size: 30), onPressed: onIncrement),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
          child: Text(value.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
        IconButton(icon: const Icon(Icons.keyboard_arrow_down, size: 30), onPressed: onDecrement),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }

  void _agregarRutina() async {
    if (_nombreController.text.isNotEmpty &&
        _horaController.text.isNotEmpty &&
        _selectedPictogramaId != null) {
      final usuarios = await _databaseHelper.getUsuarios();
      final usuarioData = usuarios.firstWhere(
            (user) => user['correoElectronico'] == widget.correoUsuario,
        orElse: () => {},
      );

      if (usuarioData.isNotEmpty) {
        final idUsuario = usuarioData['id'];

        await _databaseHelper.insertRutina({
          'nombre': _nombreController.text,
          'hora': _horaController.text,
          'completado': 0,
          'id_usuario': idUsuario,
          'id_pictograma': _selectedPictogramaId,
        });

        widget.onTareaAgregada();
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
    }
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
            GestureDetector(
              onTap: () async {
                // Navegar a AddPictogramaScreen para seleccionar un pictograma
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPictogramaScreen(), // Abre AddPictogramaScreen
                  ),
                );

                // Si el resultado es válido, navega a SelectPictogramScreen
                if (result != null && result['pictograma'] != null) {
                  final pictogramaSeleccionado = result['pictograma'];

                  setState(() {
                    _selectedPictogramaId = pictogramaSeleccionado['id'].toString();
                    _selectedPictogramaNombre = pictogramaSeleccionado['nombre'];
                    _selectedPictogramaImagen = pictogramaSeleccionado['imagen'];
                  });
                }
              },
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: _selectedPictogramaImagen != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(_selectedPictogramaImagen!, fit: BoxFit.cover),
                )
                    : const Icon(Icons.image, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            if (_selectedPictogramaNombre != null)
              Text(_selectedPictogramaNombre!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

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
                    Text('Hora seleccionada: $horaFormateada', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _agregarRutina,
                icon: const Icon(Icons.add),
                label: const Text('Agregar tarea'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
