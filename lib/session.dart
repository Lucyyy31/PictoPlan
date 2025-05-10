import 'package:flutter/material.dart';

class Session {
  static String correoUsuario = "";
  static ValueNotifier<bool> darkMode = ValueNotifier(false);
  static ValueNotifier<bool> notifications = ValueNotifier(true);
  static ValueNotifier<String> learningTypeNotifier = ValueNotifier('General');

  static String get learningType => learningTypeNotifier.value;
  static set learningType(String type) => learningTypeNotifier.value = type;
  static final ValueNotifier<List<String>> selectedColors = ValueNotifier<List<String>>([
    'rosa', 'amarillo', 'verde', 'azul' // valores por defecto
  ]);
}
