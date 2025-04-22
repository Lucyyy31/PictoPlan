// main.dart
import 'package:flutter/material.dart';
import 'pantallas/splash_screen.dart';
import 'pantallas/login.dart';
import 'pantallas/registro.dart';
import 'pantallas/recover_password.dart';
import 'pantallas/Rutina.dart';
import 'pantallas/diario.dart';
import 'pantallas/add_pictogram.dart';
import 'pantallas/entrada_diario.dart';
import 'pantallas/aprender.dart';
import 'pantallas/perfil.dart';
import 'pantallas/configuracion.dart';
import 'pantallas/ayuda.dart';
import 'pantallas/notificaciones.dart';

void main() => runApp(const PictoPlanApp());

class PictoPlanApp extends StatelessWidget {
  const PictoPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PictoPlan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/recover': (context) => const RecoverPasswordScreen(),
        '/Rutina': (context) => const HomeScreen(),
        '/diaio': (context) => const DiarioScreen(),
        '/add_pictogram': (context) => const AddPictogramaScreen(),
        '/entrada_diario': (context) => const AddEntryScreen(),
        '/aprender': (context) => const AprenderScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/configuracion': (context) => const ConfiguracionScreen(),
        '/ayuda': (context) => const AyudaScreen(),
        '/notificaciones': (context) => const NotificacionesScreen(),
      },
    );
  }
}

