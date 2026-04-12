import 'dart:async';
import 'package:flutter/material.dart';

import '../models/cliente.dart';
import '../repositories/cliente_repositorio.dart';
import '../services/csv_service.dart';
import '../utils/validadores.dart';
import '../widgets/buscador_field.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/lista_clientes.dart';
import '../widgets/panel_formulario.dart';
import '../widgets/stats_row.dart';

enum OrdenClientes { nombre, fechaReciente }

class RegistroClientesPage extends StatefulWidget {
  const RegistroClientesPage({super.key});

  @override
  State<RegistroClientesPage> createState() => _RegistroClientesPageState();
}

class _RegistroClientesPageState extends State<RegistroClientesPage> {
  List<Cliente> _clientes = [];
  List<Cliente> _filtrados = [];
  bool _cargando = true;
  bool _mostrarInactivos = true;

  final _nombreCtrl = TextEditingController();
  final _rutCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  String? _errorNombre;
  String? _errorRut;
  String? _errorEmail;
  String? _editandoRut;

  Timer? _debounce;
  OrdenClientes _ordenActual = OrdenClientes.fechaReciente;

  final _repo = ClienteRepositorio();

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nombreCtrl.dispose();
    _rutCtrl.dispose();
    _emailCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  bool get _modoEdicion => _editandoRut != null;

  Future<void> _cargarClientes() async {
    final lista = await _repo.cargarTodos();
    if (!mounted) return;
    setState(() {
      _clientes = lista;
      _cargando = false;
    });
    _aplicarFiltros();
  }

  Future<void> _guardarClientes() async {
    try {
      await _repo.guardarTodos(_clientes);
    } catch (_) {
      _notificar('Error al guardar — almacenamiento lleno', Colors.red);
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _aplicarFiltros);
  }

  void _aplicarOrden(List<Cliente> lista) {
    switch (_ordenActual) {
      case OrdenClientes.nombre:
        lista.sort((a, b) => a.nombre.compareTo(b.nombre));
        break;
      case OrdenClientes.fechaReciente:
        lista.sort((a, b) => b.fechaRegistro.compareTo(a.fechaRegistro));
        break;
    }
  }

  void _aplicarFiltros() {
    final q = _searchCtrl.text.toLowerCase().trim();

    final base = _mostrarInactivos
        ? List<Cliente>.from(_clientes)
        : _clientes.where((c) => c.activo).toList();

    final filtrada = q.isEmpty
        ? base
        : base.where((c) {
            return c.nombre.toLowerCase().contains(q) ||
                c.rut.contains(q) ||
                c.rutFormateado.toLowerCase().contains(q) ||
                c.email.toLowerCase().contains(q);
          }).toList();

    _aplicarOrden(filtrada);

    setState(() {
      _filtrados = filtrada;
    });
  }

  void _iniciarEdicion(Cliente c) {
    setState(() {
      _editandoRut = c.rut;
      _nombreCtrl.text = c.nombre;
      _emailCtrl.text = c.email;
      _rutCtrl.text = c.rutFormateado;
      _errorNombre = null;
      _errorRut = null;
      _errorEmail = null;
    });
  }

  void _cancelarEdicion() {
    setState(() {
      _editandoRut = null;
      _nombreCtrl.clear();
      _rutCtrl.clear();
      _emailCtrl.clear();
      _errorNombre = null;
      _errorRut = null;
      _errorEmail = null;
    });
  }

  void _guardarFormulario() async {
    if (_modoEdicion) {
      await _actualizarCliente();
    } else {
      await _registrarCliente();
    }
  }

  Future<void> _registrarCliente() async {
    final errNombre = Validadores.validarNombre(_nombreCtrl.text);
    final errRut = Validadores.validarRut(_rutCtrl.text);
    final errEmail = Validadores.validarEmail(_emailCtrl.text);

    setState(() {
      _errorNombre = errNombre;
      _errorRut = errRut;
      _errorEmail = errEmail;
    });

    if (errNombre != null || errRut != null || errEmail != null) {
      _notificar('Corrige los errores antes de continuar', Colors.orange);
      return;
    }

    final nombre = _nombreCtrl.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final rut = Validadores.normalizarRut(_rutCtrl.text);
    final email = _emailCtrl.text.trim().toLowerCase();

    if (_clientes.any((c) => c.rut == rut)) {
      setState(() => _errorRut = 'Este RUT ya está registrado.');
      _notificar('RUT duplicado', Colors.red);
      return;
    }

    if (_clientes.any((c) => c.email.toLowerCase() == email)) {
      setState(() => _errorEmail = 'Este email ya está registrado.');
      _notificar('Email duplicado', Colors.red);
      return;
    }

    final nombreNorm = nombre.toLowerCase();
    if (_clientes.any((c) => c.nombre.toLowerCase() == nombreNorm)) {
      final ok = await _confirmar(
        titulo: 'Nombre duplicado',
        mensaje: 'Ya existe "$nombre". ¿Registrar igualmente?',
      );
      if (!ok) return;
    }

    setState(() {
      _clientes.add(
        Cliente(
          nombre: nombre,
          rut: rut,
          email: email,
          fechaRegistro: DateTime.now(),
          activo: true,
        ),
      );
    });

    _limpiarFormulario();
    _aplicarFiltros();
    await _guardarClientes();
    _notificar('$nombre registrado correctamente', Colors.green);
  }

  Future<void> _actualizarCliente() async {
    final errNombre = Validadores.validarNombre(_nombreCtrl.text);
    final errEmail = Validadores.validarEmail(_emailCtrl.text);

    setState(() {
      _errorNombre = errNombre;
      _errorEmail = errEmail;
    });

    if (errNombre != null || errEmail != null) {
      _notificar('Corrige los errores antes de continuar', Colors.orange);
      return;
    }

    final nombre = _nombreCtrl.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final email = _emailCtrl.text.trim().toLowerCase();

    if (_clientes.any((c) => c.rut != _editandoRut && c.email.toLowerCase() == email)) {
      setState(() => _errorEmail = 'Este email ya está en uso por otro cliente.');
      _notificar('Email duplicado', Colors.red);
      return;
    }

    final idx = _clientes.indexWhere((c) => c.rut == _editandoRut);
    if (idx == -1) return;

    setState(() {
      _clientes[idx] = _clientes[idx].copyWith(nombre: nombre, email: email);
      _editandoRut = null;
    });

    _limpiarFormulario();
    _aplicarFiltros();
    await _guardarClientes();
    _notificar('Cliente actualizado correctamente', Colors.green);
  }

  Future<void> _darDeBaja(Cliente cliente) async {
    final ok = await _confirmar(
      titulo: 'Dar de baja cliente',
      mensaje: '¿Dar de baja a ${cliente.nombre} (${cliente.rutFormateado})?',
      destructivo: true,
    );
    if (!ok) return;

    final idx = _clientes.indexWhere((c) => c.rut == cliente.rut);
    if (idx == -1) return;

    setState(() {
      _clientes[idx] = _clientes[idx].copyWith(activo: false);
    });

    _aplicarFiltros();
    await _guardarClientes();
    _notificar('Cliente dado de baja', Colors.orange);
  }

  Future<void> _reactivar(Cliente cliente) async {
    final idx = _clientes.indexWhere((c) => c.rut == cliente.rut);
    if (idx == -1) return;

    setState(() {
      _clientes[idx] = _clientes[idx].copyWith(activo: true);
    });

    _aplicarFiltros();
    await _guardarClientes();
    _notificar('Cliente reactivado', Colors.green);
  }

  Future<void> _exportarCSV() async {
    if (_clientes.isEmpty) {
      _notificar('No hay datos para exportar', Colors.orange);
      return;
    }

    final resultado = await CsvService.exportarYDescargar(_clientes);
    if (!mounted) return;

    _notificar(
      resultado == null ? 'No se pudo exportar el archivo' : 'CSV exportado correctamente',
      resultado == null ? Colors.red : const Color(0xFF185FA5),
    );
  }

  void _limpiarFormulario() {
    _nombreCtrl.clear();
    _rutCtrl.clear();
    _emailCtrl.clear();
    setState(() {
      _errorNombre = null;
      _errorRut = null;
      _errorEmail = null;
      _editandoRut = null;
    });
  }

  void _notificar(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }

  Future<bool> _confirmar({
    required String titulo,
    required String mensaje,
    bool destructivo = false,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                style: destructivo
                    ? TextButton.styleFrom(foregroundColor: Colors.red)
                    : null,
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final inactivos = _clientes.where((c) => !c.activo).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Clientes UCT'),
        centerTitle: true,
        backgroundColor: const Color(0xFFB5D4F4),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            onSelected: (value) {
              if (value == 'exportar') {
                _exportarCSV();
              } else if (value == 'orden_nombre') {
                setState(() => _ordenActual = OrdenClientes.nombre);
                _aplicarFiltros();
              } else if (value == 'orden_fecha') {
                setState(() => _ordenActual = OrdenClientes.fechaReciente);
                _aplicarFiltros();
              } else if (value == 'toggle_inactivos') {
                setState(() => _mostrarInactivos = !_mostrarInactivos);
                _aplicarFiltros();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'exportar', child: Text('Exportar CSV')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'orden_fecha',
                child: Text('Ordenar por fecha (recientes)'),
              ),
              const PopupMenuItem(
                value: 'orden_nombre',
                child: Text('Ordenar por nombre'),
              ),
              PopupMenuItem(
                value: 'toggle_inactivos',
                child: Text(_mostrarInactivos ? 'Ocultar inactivos' : 'Mostrar inactivos'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PanelFormulario(
                        nombreCtrl: _nombreCtrl,
                        rutCtrl: _rutCtrl,
                        emailCtrl: _emailCtrl,
                        errorNombre: _errorNombre,
                        errorRut: _errorRut,
                        errorEmail: _errorEmail,
                        modoEdicion: _modoEdicion,
                        onGuardar: _guardarFormulario,
                        onCancelar: _modoEdicion ? _cancelarEdicion : null,
                      ),
                      const SizedBox(height: 10),
                      StatsRow(
                        total: _clientes.length,
                        filtrados: _filtrados.length,
                        inactivos: inactivos,
                      ),
                      const SizedBox(height: 8),
                      BuscadorField(controller: _searchCtrl),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _filtrados.isEmpty
                            ? EstadoVacio(haClientes: _clientes.isNotEmpty)
                            : ListaClientes(
                                clientes: _filtrados,
                                onEditar: _iniciarEdicion,
                                onDarDeBaja: _darDeBaja,
                                onReactivar: _reactivar,
                              ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}