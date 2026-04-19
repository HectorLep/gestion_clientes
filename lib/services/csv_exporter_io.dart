import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> exportCsvFile(String content, String fileName) async {
  try {
    final dir = await _resolverDirectorio();
    if (dir == null) return null;

    final carpeta = Directory('${dir.path}/GestionClientes');
    if (!await carpeta.exists()) {
      await carpeta.create(recursive: true);
    }

    final file = File('${carpeta.path}/$fileName');
    await file.writeAsString(content, flush: true);
    return file.path;
  } catch (e) {
    return null;
  }
}

Future<Directory?> _resolverDirectorio() async {
  // Android 13+ (API 33): no necesita permisos para Documentos públicos
  // Android 10-12: necesita WRITE_EXTERNAL_STORAGE
  // Android 9-: igual
  if (Platform.isAndroid) {
    final sdkInt = await _getSdkInt();

    if (sdkInt >= 30) {
      // Android 11+ → usar MANAGE_EXTERNAL_STORAGE si está disponible,
      // si no, caer a documentos privados de la app
      final status = await Permission.manageExternalStorage.status;
      if (status.isGranted) {
        return Directory('/storage/emulated/0/Documents');
      }

      final result = await Permission.manageExternalStorage.request();
      if (result.isGranted) {
        return Directory('/storage/emulated/0/Documents');
      }

      // Sin permiso: usar directorio público de Downloads (siempre accesible)
      return Directory('/storage/emulated/0/Download');
    } else {
      // Android 10 y anteriores
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) return null;
      }
      return Directory('/storage/emulated/0/Documents');
    }
  }

  // Desktop (Windows/macOS/Linux)
  final docs = await getApplicationDocumentsDirectory();
  return docs;
}

Future<int> _getSdkInt() async {
  try {
    final result = await Process.run('getprop', ['ro.build.version.sdk']);
    return int.tryParse(result.stdout.toString().trim()) ?? 30;
  } catch (_) {
    return 30;
  }
}