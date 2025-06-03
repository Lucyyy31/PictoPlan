import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  // Popup de contacto
  void _mostrarPopupContacto(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(
            "Atención al Cliente",
            style: theme.textTheme.titleLarge,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Correo: ayuda@tusitio.com", style: theme.textTheme.bodyMedium),
              Text("Teléfono: +123456789", style: theme.textTheme.bodyMedium),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar', style: TextStyle(color: colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  // Guía de funcionalidades
  Widget _guiaDeFunciones(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check, color: theme.iconTheme.color),
          title: Text('Rutinas Diarias', style: theme.textTheme.titleMedium),
          subtitle: Text(
            'Crea rutinas diarias para los niños, añade tareas, asigna pictogramas y horas, y edítalas o elimínalas.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        ListTile(
          leading: Icon(Icons.event_note, color: theme.iconTheme.color),
          title: Text('Diario de Experiencias', style: theme.textTheme.titleMedium),
          subtitle: Text(
            'Registra los eventos y experiencias diarias. Puedes añadir pictogramas relacionados con los momentos y editarlos más tarde.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        ListTile(
          leading: Icon(Icons.quiz, color: theme.iconTheme.color),
          title: Text('Aprender - Quiz', style: theme.textTheme.titleMedium),
          subtitle: Text(
            'Relaciona imágenes con palabras y selecciona la respuesta correcta. Puedes modificar los temas en configuración.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        ListTile(
          leading: Icon(Icons.settings, color: theme.iconTheme.color),
          title: Text('Configuración', style: theme.textTheme.titleMedium),
          subtitle: Text(
            'Cambia el tema del quiz (objetos, sentimientos o general) desde la configuración.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
// Vista de la pantalla
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        elevation: 1,
        title: Text(
          'Ayuda',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              '¿En qué podemos ayudarte?',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            _guiaDeFunciones(context),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _mostrarPopupContacto(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(200, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('BUSCAR AYUDA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
