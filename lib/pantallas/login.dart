import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoUsuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper();

  void _iniciarSesion() async {
    String correoUsuario = correoUsuarioController.text.trim();
    String contrasena = contrasenaController.text;

    if (correoUsuario.isEmpty || contrasena.isEmpty) {
      _mostrarMensaje('Completa todos los campos');
      return;
    }

    try {
      final usuarios = await dbHelper.getUsuarios();

      // Buscar el usuario que coincida con el correo y la contraseña
      final userMatch = usuarios.firstWhere(
            (u) =>
        u['correoElectronico'] == correoUsuario && u['contrasena'] == contrasena,
        orElse: () => {},
      );

      if (userMatch.isNotEmpty) {
        // Si se encuentra el usuario, guardamos el correo en la sesión
        Session.correoUsuario = userMatch['correoElectronico'];
        Navigator.pushReplacementNamed(context, '/Rutina');
      } else {
        _mostrarMensaje('Usuario o contraseña incorrectos');
      }
    } catch (e) {
      _mostrarMensaje('Error al iniciar sesión: $e');
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

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
            const Text('PictoPlan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: correoUsuarioController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contrasenaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[300],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _iniciarSesion,
              child: const Text('INICIAR SESIÓN', style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.5)),
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
