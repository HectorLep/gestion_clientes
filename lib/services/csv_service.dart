import '../models/cliente.dart';
import '../models/tipo_cliente.dart';
import 'csv_exporter_stub.dart'
    if (dart.library.io) 'csv_exporter_io.dart'
    if (dart.library.html) 'csv_exporter_web.dart';

class CsvService {
  static String generar(List<Cliente> clientes, {TipoCliente? filtroTipo}) {
    final lista = filtroTipo == null
        ? clientes
        : clientes.where((c) => c.tipo == filtroTipo).toList();

    final sb = StringBuffer();
    sb.writeln('Nombre,RUT,Email,Teléfono,Dirección,Tipo,'
        'Fecha Registro,Última Modificación,Estado,Notas');
    for (final c in lista) {
      sb.writeln([
        _e(c.nombre),
        _e(c.rutFormateado),
        _e(c.email),
        _e(c.telefono),
        _e(c.direccion),
        _e(c.tipo.etiqueta),
        _e(c.fechaFormateada),
        _e(c.ultimaModificacionFormateada),
        _e(c.activo ? 'Activo' : 'Inactivo'),
        _e(c.notas),
      ].map((v) => '"$v"').join(','));
    }
    return sb.toString();
  }

  static Future<String?> exportar(
      List<Cliente> clientes, {TipoCliente? filtroTipo}) async {
    final contenido = generar(clientes, filtroTipo: filtroTipo);
    final sufijo = filtroTipo != null ? '_${filtroTipo.name}' : '';
    final fileName =
        'clientes_uct${sufijo}_${DateTime.now().millisecondsSinceEpoch}.csv';
    return exportCsvFile(contenido, fileName);
  }

  /// Escapa comillas y protege contra CSV Injection
  static String _e(String value) {
    var v = value.replaceAll('"', '""');
    if (v.startsWith(RegExp(r'[=+\-@]'))) v = "'$v";
    return v;
  }
}