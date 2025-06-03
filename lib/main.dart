import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

import 'database_helper.dart';
import 'lista_pictogramas.dart';
import 'app_themes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final pictosCargados = prefs.getBool('pictogramas_cargados') ?? false;

  if (!pictosCargados) {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertAllPictogramas(pictogramas);
      print('Pictogramas insertados correctamente.');
      await prefs.setBool('pictogramas_cargados', true);
    } catch (e) {
      print('Error al insertar pictogramas: $e');
    }
  } else {
    print('ℹPictogramas ya cargados.');
  }

  runApp(const PictoPlanApp());
}

class PictoPlanApp extends StatelessWidget {
  const PictoPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Session.darkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'PictoPlan',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
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
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', ''), // Español
            Locale('en', ''), // Inglés
          ],
        );
      },
    );
  }
}
