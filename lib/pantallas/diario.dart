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
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: events.isEmpty
            ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const AddEntryScreen(),
                      ),
                    );
                    _loadEvents();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Añadir evento',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Aún no hay eventos guardados.',
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eventos importantes',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const AddEntryScreen(),
                      ),
                    );
                    _loadEvents();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Añadir evento',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return EventCard(
                    date: event.date,
                    name: event.name,
                    imageBytes: event.imageBytes,
                    onDelete: () async {
                      await DatabaseHelper()
                          .deleteEvent(event.id);
                      setState(() {
                        events.removeAt(index);
                      });
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddEntryScreen(eventId: event.id),
                        ),
                      ).then((_) => _loadEvents());
                    },
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

class EventCard extends StatelessWidget {
  final String date;
  final String name;
  final Uint8List? imageBytes;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EventCard({
    super.key,
    required this.date,
    required this.name,
    required this.imageBytes,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          imageBytes != null
              ? Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Image.memory(imageBytes!),
          )
              : Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.image, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: Colors.black54),
                onPressed: onEdit,
              ),
              const SizedBox(height: 12),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Colors.black54),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
