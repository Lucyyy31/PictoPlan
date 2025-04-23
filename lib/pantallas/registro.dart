import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              const SizedBox(height: 40),

              const Text(
                'Crea tu cuenta',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              const TextField(decoration: InputDecoration(labelText: 'Usuario')),
              const SizedBox(height: 12),

              const TextField(decoration: InputDecoration(labelText: 'Correo electrónico')),
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

              // Botón más grande y con azul claro
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[300],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pushReplacementNamed(context, '/Rutina'),
                child: const Text(
                  'REGISTRARSE',
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
                child: const Text('¿Ya tienes cuenta? Inicia sesión aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
