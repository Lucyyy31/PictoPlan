import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'app_drawer.dart';
import 'entrada_diario.dart';
import '../database_helper.dart';
import '../session.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  List<EventData> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }
// Función para cargar eventos de la BBDD
  Future<void> _loadEvents() async {
    final email = Session.correoUsuario;

    if (email != null && email.isNotEmpty) {
      final eventRows = await DatabaseHelper().getEventosByEmail(email);
      List<EventData> loadedEvents = [];

      for (var e in eventRows) {
        Uint8List? imageBytes;

        if (e['pictograma_imagen'] != null) {
          imageBytes = e['pictograma_imagen'] as Uint8List;
        } else {
          final pictogramaId = e['pictograma_id'];
          if (pictogramaId != null) {
            imageBytes = await DatabaseHelper().getPictogramaImageById(pictogramaId);
          }
        }

        loadedEvents.add(EventData(
          date: e['fecha'] ?? '',
          name: e['nombre'] ?? '',
          imageBytes: imageBytes,
          id: e['id'],
        ));
      }

      setState(() {
        events = loadedEvents;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
// Vista de la interfaz
  Widget _styledCard({required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: theme.scaffoldBackgroundColor,
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
              style: theme.appBarTheme.titleTextStyle ??
                  TextStyle(
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
            icon: Icon(Icons.menu, color: theme.iconTheme.color, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: events.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _styledCard(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEntryScreen(),
                      ),
                    );
                    _loadEvents();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir evento', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: theme.cardColor,
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Todavía no tienes eventos en tu diario.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: textColor.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Eventos importantes',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: _styledCard(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEntryScreen(),
                      ),
                    );
                    _loadEvents();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir evento', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: theme.cardColor,
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return _styledCard(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: event.imageBytes != null
                              ? Image.memory(
                            event.imageBytes!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[400],
                            child: const Icon(Icons.image, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.date,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: theme.iconTheme.color),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEntryScreen(eventId: event.id),
                              ),
                            ).then((_) => _loadEvents());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: theme.iconTheme.color),
                          onPressed: () async {
                            await DatabaseHelper().deleteEvent(event.id);
                            setState(() {
                              events.removeAt(index);
                            });
                          },
                        ),
                      ],
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

class EventData {
  final String date;
  final String name;
  final Uint8List? imageBytes;
  final int id;

  EventData({
    required this.date,
    required this.name,
    this.imageBytes,
    required this.id,
  });
}
