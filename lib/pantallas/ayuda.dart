import 'package:flutter/material.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            '¿En qué podemos ayudarte?',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('BUSCAR AYUDA'),
          ),
        ],
      ),
    );
  }
}
