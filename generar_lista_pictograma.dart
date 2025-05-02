import 'dart:io';

void main() async {
  // Directorio donde se encuentra el script
  final scriptDir = Directory.current.path;
  print('Directorio actual: $scriptDir');  // Depuración para verificar que estamos en el directorio correcto

  // Ruta al directorio con los pictogramas
  final baseDir = Directory(r'C:\Users\lucia\StudioProjects\picto_plan\assets\pictogramas');
  print('Ruta absoluta del directorio: ${baseDir.path}'); // Depuración de la ruta completa

  // Verificar si el directorio existe
  if (!baseDir.existsSync()) {
    print('❌ No se encontró la carpeta: ${baseDir.path}');
    return;
  } else {
    print('✅ Carpeta encontrada: ${baseDir.path}');
  }

  // Archivo de salida donde se generará el código
  final outputFile = File('lib/lista_pictogramas.dart');

  // Crear el StringBuffer para ir almacenando el código
  final buffer = StringBuffer();
  buffer.writeln('final List<Map<String, String>> pictogramas = [');

  // Obtener todas las categorías (subdirectorios)
  final categorias = baseDir.listSync().whereType<Directory>();

  // Iterar sobre cada categoría
  for (final categoria in categorias) {
    final nombreCategoria = categoria.path.split(Platform.pathSeparator).last;

    // Obtener los archivos PNG dentro de cada categoría
    final archivos = categoria
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.png'));

    // Iterar sobre cada archivo PNG y agregarlo al buffer
    for (final archivo in archivos) {
      final nombreArchivo = archivo.uri.pathSegments.last;
      final nombreSinExtension = nombreArchivo.replaceAll('.png', '');
      buffer.writeln(
          "  {'nombre': '$nombreSinExtension', 'categoria': '$nombreCategoria'},");
    }
  }

  buffer.writeln('];');

  // Escribir el contenido en el archivo de salida
  await outputFile.writeAsString(buffer.toString());

  print('✅ Archivo lista_pictogramas.dart generado en lib/');
}
