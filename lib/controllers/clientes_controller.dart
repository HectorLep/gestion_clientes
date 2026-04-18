import 'package:flutter/foundation.dart';
import '../models/cliente.dart';
import '../models/tipo_cliente.dart';
import '../repositories/cliente_repositorio.dart';
import '../repositories/cliente_repositorio_factory.dart';  // ← este faltaba
import '../utils/validadores.dart';

enum OrdenClientes { nombre, fechaReciente }

class ClientesController extends ChangeNotifier {
  final ClienteRepositorio _repo;

  ClientesController({ClienteRepositorio? repo})
      : _repo = repo ?? ClienteRepositorioFactory.crear();

  // ... el resto del archivo igual, no toques nada más abajo

  List<Cliente> _clientes = [];
  List<Cliente> _filtrados = [];
  bool cargando = true;
  bool guardando = false;

  String _busqueda = '';
  bool mostrarInactivos = true;
  OrdenClientes orden = OrdenClientes.fechaReciente;
  TipoCliente? filtroTipo;

  List<Cliente> get filtrados => List.unmodifiable(_filtrados);
  List<Cliente> get todos => List.unmodifiable(_clientes);

  int get totalActivos   => _clientes.where((c) => c.activo).length;
  int get totalInactivos => _clientes.where((c) => !c.activo).length;
  int get totalFiltrados => _filtrados.length;

  double get crecimientoMensual {
    final ahora = DateTime.now();
    final mesActual = _clientes.where((c) =>
        c.fechaRegistro.year == ahora.year &&
        c.fechaRegistro.month == ahora.month).length;
    final anteriorDate = DateTime(ahora.year, ahora.month - 1);
    final mesAnterior = _clientes.where((c) =>
        c.fechaRegistro.year == anteriorDate.year &&
        c.fechaRegistro.month == anteriorDate.month).length;
    if (mesAnterior == 0) return mesActual > 0 ? 100.0 : 0.0;
    return ((mesActual - mesAnterior) / mesAnterior) * 100;
  }

  Map<TipoCliente, int> get distribucionTipos => {
    for (final t in TipoCliente.values)
      t: _clientes.where((c) => c.activo && c.tipo == t).length,
  };

  Future<void> inicializar() async {
    cargando = true;
    notifyListeners();
    _clientes = await _repo.cargarTodos();
    cargando = false;
    _aplicarFiltros();
  }

  void setBusqueda(String q) {
    _busqueda = q.toLowerCase().trim();
    _aplicarFiltros();
  }

  void setOrden(OrdenClientes o) {
    orden = o;
    _aplicarFiltros();
  }

  void setMostrarInactivos(bool v) {
    mostrarInactivos = v;
    _aplicarFiltros();
  }

  void setFiltroTipo(TipoCliente? t) {
    filtroTipo = t;
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    var base = mostrarInactivos
        ? List<Cliente>.from(_clientes)
        : _clientes.where((c) => c.activo).toList();

    if (filtroTipo != null) {
      base = base.where((c) => c.tipo == filtroTipo).toList();
    }

    if (_busqueda.isNotEmpty) {
      base = base.where((c) =>
          c.nombre.toLowerCase().contains(_busqueda) ||
          c.rut.contains(_busqueda) ||
          c.rutFormateado.toLowerCase().contains(_busqueda) ||
          c.email.toLowerCase().contains(_busqueda) ||
          c.telefono.contains(_busqueda) ||
          c.tipo.etiqueta.toLowerCase().contains(_busqueda)).toList();
    }

    switch (orden) {
      case OrdenClientes.nombre:
        base.sort((a, b) => a.nombre.compareTo(b.nombre));
        break;
      case OrdenClientes.fechaReciente:
        base.sort((a, b) => b.fechaRegistro.compareTo(a.fechaRegistro));
        break;
    }

    _filtrados = base;
    notifyListeners();
  }

  Future<String?> registrar({
    required String nombre,
    required String rutRaw,
    required String email,
    String telefono = '',
    String direccion = '',
    String notas = '',
    TipoCliente tipo = TipoCliente.nuevo,
  }) async {
    final errNombre = Validadores.validarNombre(nombre);
    if (errNombre != null) return errNombre;
    final errRut = Validadores.validarRut(rutRaw);
    if (errRut != null) return errRut;
    final errEmail = Validadores.validarEmail(email);
    if (errEmail != null) return errEmail;
    final errTel = Validadores.validarTelefono(telefono);
    if (errTel != null) return errTel;
    final errDir = Validadores.validarDireccion(direccion);
    if (errDir != null) return errDir;

    final rut = Validadores.normalizarRut(rutRaw);
    final emailNorm = email.trim().toLowerCase();
    final nombreNorm = nombre.trim().replaceAll(RegExp(r'\s+'), ' ');

    if (_clientes.any((c) => c.rut == rut)) return 'RUT ya registrado.';
    if (_clientes.any((c) => c.email.toLowerCase() == emailNorm)) {
      return 'Email ya registrado.';
    }

    final ahora = DateTime.now();
    _clientes.add(Cliente(
      nombre: nombreNorm,
      rut: rut,
      email: emailNorm,
      telefono: telefono.trim(),
      direccion: direccion.trim(),
      notas: notas.trim(),
      tipo: tipo,
      fechaRegistro: ahora,
      ultimaModificacion: ahora,
    ));

    await _persist();
    return null;
  }

  Future<String?> actualizar({
    required String rut,
    required String nombre,
    required String email,
    String telefono = '',
    String direccion = '',
    String notas = '',
    TipoCliente? tipo,
  }) async {
    final errNombre = Validadores.validarNombre(nombre);
    if (errNombre != null) return errNombre;
    final errEmail = Validadores.validarEmail(email);
    if (errEmail != null) return errEmail;
    final errTel = Validadores.validarTelefono(telefono);
    if (errTel != null) return errTel;
    final errDir = Validadores.validarDireccion(direccion);
    if (errDir != null) return errDir;

    final emailNorm = email.trim().toLowerCase();
    if (_clientes.any((c) => c.rut != rut && c.email.toLowerCase() == emailNorm)) {
      return 'Email en uso por otro cliente.';
    }

    final idx = _clientes.indexWhere((c) => c.rut == rut);
    if (idx == -1) return 'Cliente no encontrado.';

    _clientes[idx] = _clientes[idx].copyWith(
      nombre: nombre.trim().replaceAll(RegExp(r'\s+'), ' '),
      email: emailNorm,
      telefono: telefono.trim(),
      direccion: direccion.trim(),
      notas: notas.trim(),
      tipo: tipo,
      ultimaModificacion: DateTime.now(),
    );

    await _persist();
    return null;
  }

  Future<void> darDeBaja(String rut, {String? notas}) async {
    final idx = _clientes.indexWhere((c) => c.rut == rut);
    if (idx == -1) return;
    _clientes[idx] = _clientes[idx].copyWith(
      activo: false,
      notas: (notas != null && notas.isNotEmpty) ? notas : _clientes[idx].notas,
      ultimaModificacion: DateTime.now(),
    );
    await _persist();
  }

  Future<void> reactivar(String rut) async {
    final idx = _clientes.indexWhere((c) => c.rut == rut);
    if (idx == -1) return;
    _clientes[idx] = _clientes[idx].copyWith(
      activo: true,
      ultimaModificacion: DateTime.now(),
    );
    await _persist();
  }

  Future<void> limpiarTodo() async {
    _clientes = [];
    await _repo.limpiarTodo();
    _aplicarFiltros();
  }

  Future<void> _persist() async {
    guardando = true;
    notifyListeners();
    try {
      await _repo.guardarTodos(_clientes);
    } catch (e) {
      debugPrint('[ClientesController] Error al persistir: $e');
    } finally {
      guardando = false;
      _aplicarFiltros();
    }
  }
}