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

  Widget _styledContainer({required Widget child}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

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
                _styledContainer(
                  child: ElevatedButton.icon(
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: theme.cardColor,
                      foregroundColor: textColor,
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Aún no hay eventos guardados.',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eventos importantes',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor),
            ),
            const SizedBox(height: 20),
            _styledContainer(
              child: ElevatedButton.icon(
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: theme.cardColor,
                  foregroundColor: textColor,
                  elevation: 0,
                ),
              ),
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
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageBytes != null
                ? Image.memory(imageBytes!,
                width: 50, height: 50, fit: BoxFit.cover)
                : Container(
              width: 50,
              height: 50,
              color: Colors.grey[400],
              child: const Icon(Icons.image, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                const SizedBox(height: 4),
                Text(date,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20, color: textColor),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 20, color: textColor),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
