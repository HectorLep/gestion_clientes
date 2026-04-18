import 'package:flutter/foundation.dart' show kIsWeb;
import 'cliente_repositorio.dart';
import 'prefs_cliente_repositorio.dart';
import 'sqlite_cliente_repositorio.dart';

class ClienteRepositorioFactory {
  ClienteRepositorioFactory._();

  /// En web usa SharedPreferences (sqflite no está disponible).
  /// En móvil y desktop usa SQLite.
  static ClienteRepositorio crear() {
    if (kIsWeb) {
      return PrefsClienteRepositorio();
    }
    return SqliteClienteRepositorio();
  }
}