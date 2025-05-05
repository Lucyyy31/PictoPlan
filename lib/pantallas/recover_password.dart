import 'package:flutter/material.dart';
import '../database_helper.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController nuevaContrasenaController = TextEditingController();
  final TextEditingController repetirContrasenaController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _cambiarContrasena() async {
    String correo = correoController.text.trim();
    String nueva = nuevaContrasenaController.text;
    String repetir = repetirContrasenaController.text;

    if (correo.isEmpty || nueva.isEmpty || repetir.isEmpty) {
      _mostrarMensaje('Completa todos los campos.');
      return;
    }

    if (nueva != repetir) {
      _mostrarMensaje('Las contraseñas no coinciden.');
      return;
    }

    try {
      final usuarios = await dbHelper.getUsuarios();
      final usuario = usuarios.firstWhere(
            (u) => u['correoElectronico'] == correo,
        orElse: () => {},
      );

      if (usuario.isEmpty) {
        _mostrarMensaje('Correo no encontrado.');
        return;
      }

      final db = await dbHelper.database;
      await db.update(
        DatabaseHelper.tableUsuario,
        {'contrasena': nueva},
        where: 'correoElectronico = ?',
        whereArgs: [correo],
      );

      _mostrarMensaje('Contraseña actualizada correctamente.');
      Navigator.pop(context); // Volver a la pantalla anterior
    } catch (e) {
      _mostrarMensaje('Error al actualizar: $e');
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
            const Text('Recuperar Contraseña', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nuevaContrasenaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: repetirContrasenaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Repetir nueva contraseña'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[300],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _cambiarContrasena,
              child: const Text('CAMBIAR CONTRASEÑA', style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Volver a inicio de sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
