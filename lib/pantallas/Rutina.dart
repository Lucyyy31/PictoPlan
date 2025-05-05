import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'app_drawer.dart';
import 'datosTarea.dart';
import '../widgets/bottom_nav.dart';
import '../session.dart'; // Importamos la clase Session para acceder al correo

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper _databaseHelper;
  List<RoutineData> routines = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadUserRutinas();
  }

  // Método para cargar las rutinas asociadas al usuario actual
  Future<void> _loadUserRutinas() async {
    String correoUsuario = Session.correoUsuario;

    final usuarios = await _databaseHelper.getUsuarios();
    final usuarioData = usuarios.firstWhere(
          (user) => user['correoElectronico'] == correoUsuario,
      orElse: () => {},
    );

    if (usuarioData.isNotEmpty) {
      final idUsuario = usuarioData['id'];
      final rutinas = await _databaseHelper.getRutinasPorUsuario(idUsuario);

      // Aquí realizamos la carga de pictogramas de manera asíncrona
      List<RoutineData> loadedRoutines = [];

      for (var rutina in rutinas) {
        if (rutina['fecha'] == _getFormattedDate()) {
          // Obtener el pictograma de manera asíncrona
          final pictograma = await _getPictogramaById(rutina['id_pictograma']);

          // Crear la rutina con el pictograma y agregarla a la lista
          loadedRoutines.add(RoutineData(
            id: rutina['id'], // Asignar el id de la rutina
            name: rutina['nombre'],
            time: rutina['hora'],
            completed: rutina['completado'] == 1,
            pictograma: pictograma,
          ));
        }
      }

      // Después de cargar todas las rutinas, actualizamos el estado
      setState(() {
        routines = loadedRoutines;
      });
    }
  }

  // Método para obtener la fecha actual en formato 'DD-MM-YYYY'
  String _getFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();

    return '$day-$month-$year'; // Formato 'DD-MM-YYYY'
  }

  // Método para obtener el pictograma a partir del ID
  Future<Map<String, dynamic>> _getPictogramaById(int id) async {
    final pictogramaData = await _databaseHelper.getPictogramaById(id);
    return pictogramaData.isNotEmpty ? pictogramaData.first : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('lib/imagenes/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text(
              'PictoPlan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
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
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Tu rutina', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DatosTareaScreen(
                            tareaNombre: '',
                            correoUsuario: Session.correoUsuario,
                            onTareaAgregada: _loadUserRutinas,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Añadir evento',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 30),
                  routines.isNotEmpty
                      ? Column(
                    children: routines.map((routine) => RoutineItem(
                      name: routine.name,
                      time: routine.time,
                      completed: routine.completed,
                      pictograma: routine.pictograma,  // Mostrar el pictograma
                      onDelete: () {
                        setState(() {
                          routines.remove(routine);
                        });
                      },
                    )).toList(),
                  )
                      : const Text('Todavía no tienes tareas en tu rutina.', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoutineData {
  final int id;
  final String name;
  final String time;
  final bool completed;
  final Map<String, dynamic> pictograma;  // Añadimos el pictograma a la rutina

  RoutineData({
    required this.id,
    required this.name,
    required this.time,
    this.completed = false,
    required this.pictograma,
  });
}

class RoutineItem extends StatelessWidget {
  final String name;
  final String time;
  final bool completed;
  final Map<String, dynamic> pictograma;  // Recibimos el pictograma
  final VoidCallback onDelete;

  const RoutineItem({
    super.key,
    required this.name,
    required this.time,
    this.completed = false,
    required this.pictograma,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mostrar la imagen del pictograma
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: pictograma.isNotEmpty
                ? Image.memory(
              pictograma['imagen'],  // Mostrar imagen del pictograma
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.image, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Checkbox(
            value: completed,
            onChanged: (value) {
              // Actualizar el estado de la tarea en la base de datos
              _updateCompletionStatus(completed ? 0 : 1);
            },
          ),
          const SizedBox(width: 10),
          const Icon(Icons.edit, size: 20),
          const SizedBox(width: 10),
          IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: onDelete),
        ],
      ),
    );
  }

  // Método para actualizar el estado de la tarea en la base de datos
  Future<void> _updateCompletionStatus(int status) async {
    final db = await DatabaseHelper().database;
    await db.update(
      'rutina',
      {'completado': status},
      where: 'id = ?',
      whereArgs: [pictograma['id']],  // Usamos el id de la rutina para actualizar
    );
  }
}
