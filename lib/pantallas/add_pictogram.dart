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
      categorias =
          resultados.map((fila) => fila['categoria'] as String).toList();
    });
  }

  String obtenerRutaImagen(String categoria) {
    final mapaEspecial = {
      'mediosTransporte': 'mediostransporte.jpeg',
      'partesCasa': 'partescasa.jpeg',
    };

    if (mapaEspecial.containsKey(categoria)) {
      return 'assets/imagenes_categorias/${mapaEspecial[categoria]}';
    }

    final nombreArchivo = categoria
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n');

    return 'assets/imagenes_categorias/$nombreArchivo.jpeg';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecciona una categoría"),
        backgroundColor: theme.appBarTheme.backgroundColor ?? (isDark ? Colors.grey[900] : Colors.blue[300]),
        elevation: 1,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: categorias.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categorias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final imagenRuta = obtenerRutaImagen(categoria);

          return GestureDetector(
            onTap: () async {
              final idUsuario = 1;

              final resultado =
              await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectPictogramScreen(
                    idUsuario: idUsuario,
                    idCategoria: categoria.hashCode,
                    nombreCategoria: categoria,
                  ),
                ),
              );

              if (resultado != null &&
                  resultado.containsKey('pictograma')) {
                Navigator.pop(context, resultado);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(imagenRuta),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                categoria.toUpperCase(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
