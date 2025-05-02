import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../session.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController repetirContrasenaController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper();

  void _registrarUsuario() async {
    String usuario = usuarioController.text.trim();
    String correo = correoController.text.trim();
    String contrasena = contrasenaController.text;
    String repetir = repetirContrasenaController.text;

    if (usuario.isEmpty || correo.isEmpty || contrasena.isEmpty ||
        repetir.isEmpty) {
      _mostrarMensaje('Completa todos los campos.');
      return;
    }

    if (contrasena != repetir) {
      _mostrarMensaje('Las contraseñas no coinciden.');
      return;
    }

    try {
      await dbHelper.insertUsuario({
        'nombreUsuario': usuario,
        'correoElectronico': correo,
        'contrasena': contrasena,
      });

      // ✅ Guardar el correo en la sesión
      Session.correoUsuario = correo;

      // Llévalo a PerfilScreen
      Navigator.pushReplacementNamed(context, '/Rutina', arguments: correo);
    } catch (e) {
      _mostrarMensaje('Error al registrar: $e');
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Image.asset('lib/imagenes/logo.png', height: 160),
              const SizedBox(height: 40),
              const Text('Crea tu cuenta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(controller: usuarioController, decoration: const InputDecoration(labelText: 'Usuario')),
              const SizedBox(height: 12),
              TextField(controller: correoController, decoration: const InputDecoration(labelText: 'Correo electrónico')),
              const SizedBox(height: 12),
              TextField(controller: contrasenaController, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
              const SizedBox(height: 12),
              TextField(controller: repetirContrasenaController, obscureText: true, decoration: const InputDecoration(labelText: 'Repetir contraseña')),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[300],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _registrarUsuario,
                child: const Text('REGISTRARSE', style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.5)),
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
