import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../session.dart';
import 'add_pictogram.dart';

class AddEntryScreen extends StatefulWidget {
  final int? eventId; // Parámetro opcional para el ID del evento

  const AddEntryScreen({Key? key, this.eventId}) : super(key: key);

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _selectedPictograms = [];

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null) {
      _loadEventData(widget.eventId!); // Si hay ID, cargar los datos del evento
    }
  }

  Future<void> _loadEventData(int eventId) async {
    try {
      final eventData = await _dbHelper.getEventoCompletoPorId(eventId);

      if (eventData != null) {
        final evento = eventData['evento'];
        final pictogramas = eventData['pictogramas'] as List<Map<String, dynamic>>;

        setState(() {
          _titleController.text = evento['nombre'];
          _dateController.text = evento['fecha'];
          _descriptionController.text = evento['descripcion'];
          _selectedPictograms = pictogramas;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos del evento: $e')),
      );
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es', ''),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
        "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedPictograms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos y selecciona al menos un pictograma')),
      );
      return;
    }

    final email = Session.correoUsuario;
    if (email == null) return;

    final userId = await _dbHelper.getUsuarioIdByEmail(email);
    if (userId == null) return;

    final List<int> pictogramaIds = _selectedPictograms.map((picto) => picto['id'] as int).toList();

    try {
      if (widget.eventId == null) {
        // Si es un evento nuevo, insertamos un nuevo registro
        await _dbHelper.insertarEventoConPictogramas(
          nombre: _titleController.text,
          fecha: _dateController.text,
          descripcion: _descriptionController.text,
          pictogramaIds: pictogramaIds,
          idUsuario: userId,
        );
      } else {
        // Si es un evento existente, actualizamos el evento
        await _dbHelper.actualizarEvento(
          eventId: widget.eventId!, // Usamos el ID para actualizar el evento específico
          nombre: _titleController.text,
          fecha: _dateController.text,
          descripcion: _descriptionController.text,
          pictogramaIds: pictogramaIds,
          idUsuario: userId,
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el evento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('lib/imagenes/logo.png', height: 40),
            const SizedBox(width: 10),
            Text(
              widget.eventId == null ? 'Nueva entrada' : 'Editar entrada', // Cambiar el título según si es nueva o edición
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputField('Título', _titleController),
              const SizedBox(height: 16),
              _buildDateField('Fecha', _dateController),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pictogramas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(builder: (_) => const AddPictogramaScreen()),
                      );
                      if (result != null && result['pictograma'] != null) {
                        setState(() {
                          _selectedPictograms.add(result['pictograma']);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Seleccionar pictogramas'),
                  ),
                  const SizedBox(height: 10),
                  if (_selectedPictograms.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _selectedPictograms.map((picto) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.memory(
                                picto['imagen'] as Uint8List,
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(height: 4),
                              Text(picto['nombre'], style: const TextStyle(fontSize: 12)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Volver', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: _saveEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Aceptar', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Escribe aquí...'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(
                    controller.text.isEmpty ? 'Selecciona una fecha' : controller.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            maxLines: 6,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration.collapsed(hintText: 'Escribe aquí tu experiencia...'),
          ),
        ],
      ),
    );
  }
}
