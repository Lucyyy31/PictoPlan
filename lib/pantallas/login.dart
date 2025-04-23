import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/imagenes/logo.png', height: 160),
            const SizedBox(height: 40),

            const Text(
              'PictoPlan',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 30),

            // Botón más grande, azul claro y letras en mayúsculas
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
                'INICIAR SESIÓN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('¿Aún no tienes cuenta? Regístrate aquí'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/recover'),
              child: const Text('¿Has olvidado tu contraseña?'),
            ),
          ],
        ),
      ),
    );
  }
}
