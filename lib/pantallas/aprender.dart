import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../session.dart';
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
    String learningType = Session.learningType;
    List<Map<String, dynamic>> pictogramasTemp = [];

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
      return;
    }

    final random = Random();
    final correcto = pictogramasTemp[random.nextInt(pictogramasTemp.length)];
    _respuestaCorrecta = correcto['nombre'];
    _imagenActual = correcto['imagen'];

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
          content: Text(
            esCorrecto
                ? '¡Has elegido la respuesta correcta!'
                : 'La respuesta correcta era: $_respuestaCorrecta',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cargarQuiz();
              },
              child: const Text('Volver a jugar'),
            ),
          ],
        ),
      );
    });
  }

  Color _getColor(String name) {
    final Map<String, Color> colorMap = {
      'rosa': Colors.pink[200]!,
      'amarillo': Colors.yellow[300]!,
      'verde': Colors.green[300]!,
      'azul': Colors.blue[300]!,
      'lila': Colors.purple[200]!,
      'naranja': Colors.orange[200]!,
      'marron': Colors.brown[200]!,
      'cyan': Colors.lightBlue[200]!,
    };

    return colorMap[name] ?? Colors.grey[300]!; // Default color
  }

  Color _colorOpcion(int index, String opcion) {
    if (!_respondido) {
      final colores = Session.selectedColors.value;
      return _getColor(colores[index % colores.length]);
    }
    if (opcion == _respuestaCorrecta) return Colors.green[300]!;
    if (opcion == _seleccion) return Colors.red[300]!;
    return Colors.grey[300]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[200], // Light grey background
        elevation: 0,
        automaticallyImplyLeading: false, // Disable default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('lib/imagenes/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text(
              'PictoPlan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_imagenActual != null)
              Image.memory(
                _imagenActual!,
                height: 180,
              ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
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
                      decoration: BoxDecoration(
                        color: _colorOpcion(index, opcion),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
