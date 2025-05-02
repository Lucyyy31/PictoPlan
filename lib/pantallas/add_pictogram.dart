import 'package:flutter/material.dart';
import 'datosTarea.dart';

class AddPictogramaScreen extends StatelessWidget {
  const AddPictogramaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categorias = [
      'Colegio',
      'Desayuno',
      'Comer',
      'Merienda',
      'Cena',
      'Despertarse',
      'Jugar',
      'Baño',
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona la tarea que deseas realizar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // Botón simulado para subir imagen
            ElevatedButton.icon(
              onPressed: () {
                // Aquí podrías abrir una pantalla futura
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Subir imagen desde dispositivo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(height: 16),

            // Grid de tareas / pictogramas
            Expanded(
              child: GridView.builder(
                itemCount: categorias.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DatosTareaScreen(tareaNombre: categorias[index]),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black26),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.image, size: 50, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          categorias[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
