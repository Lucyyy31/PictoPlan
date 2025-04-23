import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class AprenderScreen extends StatelessWidget {
  const AprenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: Column(
        children: [
          // CABECERA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'lib/imagenes/logo.png',
                  height: 50,
                ),
                const Text(
                  'PictoPlan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Icon(Icons.menu, size: 35),
              ],
            ),
          ),

          // CONTENIDO PRINCIPAL
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // SIMULACIÓN DE IMAGEN (Rectángulo)
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Aquí va la imagen',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'Elige la palabra correcta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // OPCIONES
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildOption('feliz', Colors.lightBlueAccent),
                            _buildOption('triste', Colors.lightGreenAccent),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildOption('enfadada', Colors.yellowAccent),
                            _buildOption('cansada', Colors.lightGreen),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Botón de opción estilizado
  Widget _buildOption(String text, Color color) {
    return Container(
      width: 150,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          // lógica de respuesta
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
