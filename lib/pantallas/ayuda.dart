import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  // Método para el Popup de contacto
  void _mostrarPopupContacto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Atención al Cliente"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Correo: ayuda@tusitio.com"),
              Text("Teléfono: +123456789"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Método para construir la guía de funcionalidades
  Widget _guiaDeFunciones() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.check),
          title: const Text('Rutinas Diarias'),
          subtitle: const Text(
              'Crea rutinas diarias para los niños, añade tareas, asigna pictogramas y horas, y edítalas o elimínalas.'),
        ),
        ListTile(
          leading: const Icon(Icons.event_note),
          title: const Text('Diario de Experiencias'),
          subtitle: const Text(
              'Registra los eventos y experiencias diarias. Puedes añadir pictogramas relacionados con los momentos y editarlos más tarde.'),
        ),
        ListTile(
          leading: const Icon(Icons.quiz),
          title: const Text('Aprender - Quiz'),
          subtitle: const Text(
              'Relaciona imágenes con palabras y selecciona la respuesta correcta. Puedes modificar los temas en configuración.'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configuración'),
          subtitle: const Text(
              'Cambia el tema del quiz (objetos, sentimientos o general) desde la configuración.'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: SingleChildScrollView( // Hacemos que la pantalla sea desplazable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              '¿En qué podemos ayudarte?',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            _guiaDeFunciones(), // Mostrar la guía de funciones
            const SizedBox(height: 20),
            // Centramos el botón y lo hacemos más grande
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 60), // Tamaño más grande
                  textStyle: const TextStyle(fontSize: 20), // Aumentar tamaño del texto
                ),
                onPressed: () {
                  _mostrarPopupContacto(context); // Mostrar el popup de contacto al pulsar "Buscar Ayuda"
                },
                child: const Text('BUSCAR AYUDA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
