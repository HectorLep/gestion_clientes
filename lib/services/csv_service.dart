import '../models/cliente.dart';
import 'csv_exporter_stub.dart'
    if (dart.library.io) 'csv_exporter_io.dart'
    if (dart.library.html) 'csv_exporter_web.dart';

class CsvService {
  static String generar(List<Cliente> clientes) {
    final sb = StringBuffer();
    sb.writeln('Nombre,RUT,Email,Fecha Registro,Estado');

    for (final c in clientes) {
      sb.writeln(
        '"${_escape(c.nombre)}","${_escape(c.rutFormateado)}","${_escape(c.email)}","${_escape(c.fechaFormateada)}","${_escape(c.activo ? 'Activo' : 'Inactivo')}"',
      );
    }

    return sb.toString();
  }

  static Future<String?> exportarYDescargar(List<Cliente> clientes) async {
    final contenido = generar(clientes);
    final fileName = 'clientes_uct_${DateTime.now().millisecondsSinceEpoch}.csv';
    return exportCsvFile(contenido, fileName);
  }

  static String _escape(String value) {
    var safe = value.replaceAll('"', '""');
    if (safe.isNotEmpty && RegExp(r'^[=+\-@]').hasMatch(safe)) {
      safe = "'$safe";
    }
    return safe;
  }
}