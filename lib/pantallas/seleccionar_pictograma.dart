import 'package:flutter/material.dart';
import '../database_helper.dart';

class SelectPictogramScreen extends StatefulWidget {
  final int idUsuario;
  final int idCategoria;
  final String nombreCategoria;

  const SelectPictogramScreen({
    super.key,
    required this.idUsuario,
    required this.idCategoria,
    required this.nombreCategoria,
  });

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
// Función para cargar los pictogramas de una categoria concreta
  Future<void> cargarPictogramas() async {
    final db = await DatabaseHelper().database;
    final resultado = await db.query(
      'pictograma',
      where: 'categoria = ?',
      whereArgs: [widget.nombreCategoria],
    );

    setState(() {
      pictogramas = resultado;
    });
  }
// Popup para cancelar o aceptar el pictograma seleccionado
  Future<void> _confirmarSeleccion(Map<String, dynamic> pictograma) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar selección'),
        content: Text('¿Quieres seleccionar este pictograma: ${pictograma['nombre']}?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: const Text('Confirmar'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmado == true && mounted) {
      Navigator.of(context).pop({'pictograma': pictograma});
    }
  }
// Vista de la interfaz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pictogramas: ${widget.nombreCategoria}')),
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
          final imagenBytes = pictograma['imagen'];

          return GestureDetector(
            onTap: () => _confirmarSeleccion(pictograma),
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
