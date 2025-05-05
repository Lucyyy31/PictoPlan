import 'package:flutter/material.dart';
import 'package:picto_plan/pantallas/seleccionar_pictograma.dart';
import '../database_helper.dart';

class AddPictogramaScreen extends StatefulWidget {
  const AddPictogramaScreen({super.key});

  @override
  State<AddPictogramaScreen> createState() => _AddPictogramaScreenState();
}

class _AddPictogramaScreenState extends State<AddPictogramaScreen> {
  List<String> categorias = [];

  @override
  void initState() {
    super.initState();
    cargarCategorias();
  }

  Future<void> cargarCategorias() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> resultados =
    await db.rawQuery('SELECT DISTINCT categoria FROM pictograma');

    setState(() {
      categorias = resultados.map((fila) => fila['categoria'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona una categoría")),
      body: categorias.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categorias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          return GestureDetector(
            onTap: () async {
              final idUsuario = 1; // Solo como ejemplo

              final resultado = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectPictogramScreen(
                    idUsuario: idUsuario,
                    idCategoria: categoria.hashCode,
                    nombreCategoria: categoria,
                  ),
                ),
              );

              if (resultado != null && resultado.containsKey('pictograma')) {
                Navigator.pop(context, resultado); // Devuelve pictograma a la pantalla anterior
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                categoria.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
