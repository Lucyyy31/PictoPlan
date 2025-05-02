import 'package:flutter/material.dart';
import '../database_helper.dart';

class SelectPictogramScreen extends StatefulWidget {
  final String categoria;

  const SelectPictogramScreen({super.key, required this.categoria});

  @override
  State<SelectPictogramScreen> createState() => _SelectPictogramScreenState();
}

class _SelectPictogramScreenState extends State<SelectPictogramScreen> {
  List<Map<String, dynamic>> pictogramas = [];

  @override
  void initState() {
    super.initState();
    cargarPictogramas();
  }

  Future<void> cargarPictogramas() async {
    final db = await DatabaseHelper().database;
    final resultado = await db.query(
      'pictograma',
      where: 'categoria = ?',
      whereArgs: [widget.categoria],
    );

    setState(() {
      pictogramas = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pictogramas: ${widget.categoria}')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pictogramas.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final pictograma = pictogramas[index];
          final nombre = pictograma['nombre'];
          final imagenBytes = pictograma['imagen']; // si es BLOB

          return GestureDetector(
            onTap: () {
              Navigator.pop(context, {
                'id': pictograma['id'],
                'nombre': nombre,
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: Image.memory(
                    imagenBytes,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nombre,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
