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

  bool mostrarNuevaContrasena = false;
  bool mostrarRepetirContrasena = false;

  // Estados para validación
  bool tieneLongitud = false;
  bool tieneMayuscula = false;
  bool tieneMinuscula = false;
  bool tieneNumero = false;
  bool tieneEspecial = false;
// Función para validad la contraseña
  void _actualizarValidaciones(String contrasena) {
    setState(() {
      tieneLongitud = contrasena.length >= 8;
      tieneMayuscula = contrasena.contains(RegExp(r'[A-Z]'));
      tieneMinuscula = contrasena.contains(RegExp(r'[a-z]'));
      tieneNumero = contrasena.contains(RegExp(r'\d'));
      tieneEspecial = contrasena.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    });
  }

  bool _contrasenaValida() {
    return tieneLongitud && tieneMayuscula && tieneMinuscula && tieneNumero && tieneEspecial;
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }
// Función para cambiar la contraseña
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

    if (!_contrasenaValida()) {
      _mostrarMensaje('La contraseña no cumple con los requisitos.');
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
      Navigator.pop(context);
    } catch (e) {
      _mostrarMensaje('Error al actualizar: $e');
    }
  }
// Vista de la pantalla
  Widget _validacionItem(bool condicion, String texto) {
    return Row(
      children: [
        Icon(condicion ? Icons.check_circle : Icons.cancel,
            color: condicion ? Colors.green : Colors.red, size: 18),
        const SizedBox(width: 8),
        Text(texto, style: TextStyle(color: condicion ? Colors.green : Colors.red)),
      ],
    );
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
              const Text('Recuperar Contraseña', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Correo electrónico
              TextField(
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
              ),
              const SizedBox(height: 12),

              // Nueva contraseña
              TextField(
                controller: nuevaContrasenaController,
                obscureText: !mostrarNuevaContrasena,
                onChanged: _actualizarValidaciones,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(mostrarNuevaContrasena ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => mostrarNuevaContrasena = !mostrarNuevaContrasena),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Validaciones visuales
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _validacionItem(tieneLongitud, 'Al menos 8 caracteres'),
                  _validacionItem(tieneMayuscula, 'Al menos una letra mayúscula'),
                  _validacionItem(tieneMinuscula, 'Al menos una letra minúscula'),
                  _validacionItem(tieneNumero, 'Al menos un número'),
                  _validacionItem(tieneEspecial, 'Al menos un carácter especial'),
                ],
              ),
              const SizedBox(height: 12),

              // Repetir nueva contraseña
              TextField(
                controller: repetirContrasenaController,
                obscureText: !mostrarRepetirContrasena,
                decoration: InputDecoration(
                  labelText: 'Repetir nueva contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(mostrarRepetirContrasena ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => mostrarRepetirContrasena = !mostrarRepetirContrasena),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botón cambiar contraseña
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
      ),
    );
  }
}
