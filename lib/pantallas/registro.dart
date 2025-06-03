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

  bool mostrarContrasena = false;
  bool mostrarRepetirContrasena = false;

  // Estado de validaciones
  bool tieneLongitud = false;
  bool tieneMayuscula = false;
  bool tieneMinuscula = false;
  bool tieneNumero = false;
  bool tieneEspecial = false;
// Función para actualizar los valores de la contraseña a medida que se escribe
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
// Función para registrar un usuario
  void _registrarUsuario() async {
    String usuario = usuarioController.text.trim();
    String correo = correoController.text.trim();
    String contrasena = contrasenaController.text;
    String repetir = repetirContrasenaController.text;

    if (usuario.isEmpty || correo.isEmpty || contrasena.isEmpty || repetir.isEmpty) {
      _mostrarMensaje('Completa todos los campos.');
      return;
    }

    if (contrasena != repetir) {
      _mostrarMensaje('Las contraseñas no coinciden.');
      return;
    }

    if (!_contrasenaValida()) {
      _mostrarMensaje('La contraseña no cumple con los requisitos.');
      return;
    }

    try {
      await dbHelper.insertUsuario({
        'nombreUsuario': usuario,
        'correoElectronico': correo,
        'contrasena': contrasena,
      });

      Session.correoUsuario = correo;
      Navigator.pushReplacementNamed(context, '/Rutina', arguments: correo);
    } catch (e) {
      _mostrarMensaje('Error al registrar: $e');
    }
  }
// Vista de la pantalla
  Widget _validacionItem(bool condicion, String texto) {
    return Row(
      children: [
        Icon(condicion ? Icons.check_circle : Icons.cancel, color: condicion ? Colors.green : Colors.red, size: 18),
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
              const Text('Crea tu cuenta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(controller: usuarioController, decoration: const InputDecoration(labelText: 'Usuario')),
              const SizedBox(height: 12),
              TextField(controller: correoController, decoration: const InputDecoration(labelText: 'Correo electrónico')),
              const SizedBox(height: 12),

              // Contraseña
              TextField(
                controller: contrasenaController,
                obscureText: !mostrarContrasena,
                onChanged: _actualizarValidaciones,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(mostrarContrasena ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => mostrarContrasena = !mostrarContrasena),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Reglas de contraseña
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

              // Repetir contraseña
              TextField(
                controller: repetirContrasenaController,
                obscureText: !mostrarRepetirContrasena,
                decoration: InputDecoration(
                  labelText: 'Repetir contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(mostrarRepetirContrasena ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => mostrarRepetirContrasena = !mostrarRepetirContrasena),
                  ),
                ),
              ),

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
