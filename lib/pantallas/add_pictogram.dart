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
// Función para cargar los pictogramas de la BBDD
  Future<void> cargarCategorias() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> resultados =
    await db.rawQuery('SELECT DISTINCT categoria FROM pictograma');

    setState(() {
      categorias =
          resultados.map((fila) => fila['categoria'] as String).toList();
    });
  }
// Función para obtener la ruta para las imagenes de las categorias
  String obtenerRutaImagen(String categoria) {
    final mapaEspecial = {
      'mediosTransporte': 'mediosTransporte.jpeg',
      'partesCasa': 'partesCasa.jpeg',
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
  // Vista de la interfaz
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Selecciona una categoría",
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
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
                    isDark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.3),
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
