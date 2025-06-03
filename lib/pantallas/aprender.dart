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
// Función para cargar el quiz, de forma predeterminada sale el tipo de General
  Future<void> _cargarQuiz() async {
    String learningType = Session.learningType;
    List<Map<String, dynamic>> pictogramasTemp = [];

    if (learningType == 'General') {
      pictogramasTemp = await dbHelper.getPictogramas();
    } else if (learningType == 'Sentimientos') {
      pictogramasTemp =
      await dbHelper.getPictogramasPorCarpeta('sentimientos_y_emociones');
    } else if (learningType == 'Objetos') {
      pictogramasTemp = await dbHelper.getPictogramasPorCarpeta('objetos');
      final materialEscolar =
      await dbHelper.getPictogramasPorCarpeta('material_escolar');
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
      final candidato =
      pictogramasTemp[random.nextInt(pictogramasTemp.length)];
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
// Función para seleccionar la opcion
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
// Colores de las opciones
  Color _getColor(String name) {
    final Map<String, Color> colorMap = {
      'rosa': Colors.pink[100]!,
      'amarillo': Colors.amber[200]!,
      'verde': Colors.green[100]!,
      'azul': Colors.blue[100]!,
      'lila': Colors.purple[200]!,
      'naranja': Colors.orange[200]!,
      'marron': Colors.brown[200]!,
      'cyan': Colors.lightBlue[200]!,
    };

    return colorMap[name] ?? Colors.grey[300]!;
  }

  Color _colorOpcion(int index, String opcion) {
    final theme = Theme.of(context);

    if (!_respondido) {
      final colores = Session.selectedColors.value;
      return _getColor(colores[index % colores.length]);
    }
    if (opcion == _respuestaCorrecta) return Colors.green[400]!;
    if (opcion == _seleccion) return Colors.red[300]!;
    return theme.colorScheme.surfaceVariant;
  }
// Vista de la aplicación
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('lib/imagenes/logo.png', height: 40),
            const SizedBox(width: 10),
            Text(
              'PictoPlan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: textColor, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        child: Column(
          children: [
            if (_imagenActual != null)
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Image.memory(
                  _imagenActual!,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
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
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          opcion,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87,
                          ),
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
