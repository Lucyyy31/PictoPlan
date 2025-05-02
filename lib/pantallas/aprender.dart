import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../session.dart'; // Importa la clase Session
import '../widgets/bottom_nav.dart';
import 'app_drawer.dart';

class AprenderScreen extends StatefulWidget {
  const AprenderScreen({super.key});

  @override
  State<AprenderScreen> createState() => _AprenderScreenState();
}

class _AprenderScreenState extends State<AprenderScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late List<Map<String, dynamic>> _pictogramas;

  Uint8List? _imagenActual;
  String? _respuestaCorrecta;
  List<String> _opciones = [];
  String? _seleccion;
  bool _respondido = false;

  @override
  void initState() {
    super.initState();
    _cargarQuiz();
  }

  Future<void> _cargarQuiz() async {
    String learningType = Session.learningType;  // Tipo de aprendizaje

    List<Map<String, dynamic>> pictogramasTemp = [];  // Lista mutable para los pictogramas

    if (learningType == 'General') {
      pictogramasTemp = await dbHelper.getPictogramas();
    } else if (learningType == 'Sentimientos') {
      pictogramasTemp = await dbHelper.getPictogramasPorCarpeta('sentimientos_y_emociones');
    } else if (learningType == 'Objetos') {
      pictogramasTemp = await dbHelper.getPictogramasPorCarpeta('objetos');
      final materialEscolar = await dbHelper.getPictogramasPorCarpeta('material_escolar');
      pictogramasTemp.addAll(materialEscolar);
    }

    if (pictogramasTemp.isEmpty) {
      setState(() {
        _imagenActual = null;
        _respuestaCorrecta = null;
        _opciones = [];
        _seleccion = null;
        _respondido = false;
      });
      return; // Si no hay pictogramas, salir temprano
    }

    final random = Random();
    final correcto = pictogramasTemp[random.nextInt(pictogramasTemp.length)];

    _respuestaCorrecta = correcto['nombre'];
    _imagenActual = correcto['imagen'];

    // Obtener 3 nombres incorrectos únicos
    final opcionesIncorrectas = <String>{};
    while (opcionesIncorrectas.length < 3) {
      final candidato = pictogramasTemp[random.nextInt(pictogramasTemp.length)];
      if (candidato['nombre'] != _respuestaCorrecta) {
        opcionesIncorrectas.add(candidato['nombre']);
      }
    }

    _opciones = [...opcionesIncorrectas, _respuestaCorrecta!];
    _opciones.shuffle();

    setState(() {
      _seleccion = null;
      _respondido = false;
    });
  }

  void _seleccionarOpcion(String opcion) {
    setState(() {
      _seleccion = opcion;
      _respondido = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      final esCorrecto = opcion == _respuestaCorrecta;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(esCorrecto ? '¡Correcto!' : '¡Incorrecto!'),
          content: Text(esCorrecto
              ? '¡Has elegido la respuesta correcta!'
              : 'La respuesta correcta era: $_respuestaCorrecta'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cargarQuiz(); // Reinicia
              },
              child: const Text('Volver a jugar'),
            )
          ],
        ),
      );
    });
  }

  Color _colorOpcion(String opcion) {
    if (!_respondido) return Colors.white;
    if (opcion == _respuestaCorrecta) return Colors.green[200]!;
    if (opcion == _seleccion) return Colors.red[200]!;
    return Colors.grey[300]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
        title: const Text('Aprender'),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mostrar la imagen del pictograma
            if (_imagenActual != null) Image.memory(_imagenActual!),
            const SizedBox(height: 20),
            // Opciones de respuesta en formato cuadrado (2x2)
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // Dos columnas
                  childAspectRatio: 2, // Ajustar las opciones
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _opciones.length,
                itemBuilder: (context, index) {
                  final opcion = _opciones[index];
                  return GestureDetector(
                    onTap: () => _seleccionarOpcion(opcion),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: _colorOpcion(opcion),
                      child: Center(
                        child: Text(
                          opcion,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
