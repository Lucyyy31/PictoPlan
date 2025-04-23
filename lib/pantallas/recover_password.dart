import 'package:flutter/material.dart';

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Logo más grande
              Image.asset('lib/imagenes/logo.png', height: 160),
              const SizedBox(height: 20),

              const Text(
                'Cambio de contraseña',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              const TextField(
                decoration: InputDecoration(labelText: 'Usuario'),
              ),
              const SizedBox(height: 12),

              const TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 12),

              const TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Repetir contraseña'),
              ),
              const SizedBox(height: 30),

              // Botón estilizado
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[300],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  'CONFIRMAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Volver a inicio de sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
