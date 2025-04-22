import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            CircleAvatar(radius: 50),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: 'Usuario')),
            TextField(decoration: InputDecoration(labelText: 'Email')),
            TextField(decoration: InputDecoration(labelText: 'Contraseña')),
          ],
        ),
      ),
    );
  }
}