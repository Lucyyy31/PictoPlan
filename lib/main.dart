import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'session.dart';
import 'pantallas/splash_screen.dart';
import 'pantallas/login.dart';
import 'pantallas/registro.dart';
import 'pantallas/recover_password.dart';
import 'pantallas/Rutina.dart';
import 'pantallas/diario.dart';
import 'pantallas/add_evento.dart';
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
    return ValueListenableBuilder<bool>(
      valueListenable: Session.darkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'PictoPlan',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.lightBlue,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/recover': (context) => const RecoverPasswordScreen(),
            '/Rutina': (context) => const HomeScreen(),
            '/diario': (context) => const DiarioScreen(),
            '/add_evento': (context) => const AddEventoScreen(),
            '/entrada_diario': (context) => const AddEntryScreen(),
            '/aprender': (context) => const AprenderScreen(),
            '/perfil': (context) => const PerfilScreen(),
            '/configuracion': (context) => const ConfiguracionScreen(),
            '/ayuda': (context) => const AyudaScreen(),
            '/notificaciones': (context) => const NotificacionesScreen(),
          },
          supportedLocales: [
            const Locale('es', 'ES'), // Español (España)
            const Locale('en', 'US'), // Inglés (EE.UU.)
          ],
         // locale: const Locale('es', 'ES'), // Aquí forzamos el idioma español
        );
      },
    );
  }
}
