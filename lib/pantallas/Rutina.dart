import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'app_drawer.dart';
import 'datosTarea.dart';
import '../widgets/bottom_nav.dart';
import '../session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper _databaseHelper;
  List<RoutineData> routines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadUserRutinas();
  }

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

      List<RoutineData> loadedRoutines = [];

      for (var rutina in rutinas) {
        if (rutina['fecha'] == _getFormattedDate()) {
          final pictograma = await _getPictogramaById(rutina['id_pictograma']);

          loadedRoutines.add(RoutineData(
            id: rutina['id'],
            name: rutina['nombre'],
            time: rutina['hora'],
            completed: rutina['completado'] == 1,
            pictograma: pictograma,
          ));
        }
      }

      setState(() {
        routines = loadedRoutines;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();

    return '$day-$month-$year';
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: routines.isEmpty
            ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    'Añadir tarea',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Todavía no tienes tareas en tu rutina.',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Rutina del día',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
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
                'Añadir tarea',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return RoutineItem(
                    rutinaId: routine.id,
                    name: routine.name,
                    time: routine.time,
                    completed: routine.completed,
                    pictograma: routine.pictograma,
                    onDelete: () async {
                      await _databaseHelper.deleteRutinaById(routine.id);
                      setState(() {
                        routines.remove(routine);
                      });
                    },
                    onTareaEditada: _loadUserRutinas,
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

class RoutineData {
  final int id;
  final String name;
  final String time;
  final bool completed;
  final Map<String, dynamic> pictograma;

  RoutineData({
    required this.id,
    required this.name,
    required this.time,
    this.completed = false,
    required this.pictograma,
  });
}

class RoutineItem extends StatefulWidget {
  final int rutinaId;
  final String name;
  final String time;
  final bool completed;
  final Map<String, dynamic> pictograma;
  final VoidCallback onDelete;
  final VoidCallback onTareaEditada;

  const RoutineItem({
    super.key,
    required this.rutinaId,
    required this.name,
    required this.time,
    required this.completed,
    required this.pictograma,
    required this.onDelete,
    required this.onTareaEditada,
  });

  @override
  State<RoutineItem> createState() => _RoutineItemState();
}

class _RoutineItemState extends State<RoutineItem> {
  late bool isChecked;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    isChecked = widget.completed;
  }

  Future<void> _updateCompletion(bool? value) async {
    if (value == null) return;

    setState(() {
      isChecked = value;
    });

    await _databaseHelper.updateRutinaCompletado(widget.rutinaId, value ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: widget.pictograma.isNotEmpty
                ? Image.memory(
              widget.pictograma['imagen'],
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
                Text(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(widget.time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Checkbox(
            value: isChecked,
            onChanged: _updateCompletion,
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DatosTareaScreen(
                    tareaId: widget.rutinaId,
                    tareaNombre: widget.name,
                    correoUsuario: Session.correoUsuario,
                    onTareaAgregada: widget.onTareaEditada,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.black54),
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
