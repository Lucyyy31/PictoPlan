import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'lista_pictogramas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();

  try {
    await dbHelper.insertAllPictogramas(pictogramas);
    print('Pictogramas insertados correctamente.');
  } catch (e) {
    print('Error al insertar pictogramas: $e');
  }

  runApp(const PlaceholderWidget());
}

class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Carga completada. Puedes cerrar esta ventana.'),
        ),
      ),
    );
  }
}
