import 'dart:async';
import 'package:flutter/material.dart';
import '../controllers/clientes_controller.dart';
import '../models/cliente.dart';
import '../models/tipo_cliente.dart';
import '../services/csv_service.dart';
import '../utils/validadores.dart';
import '../widgets/buscador_field.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/lista_clientes.dart';
import '../widgets/panel_formulario.dart';
import '../widgets/stats_row.dart';

class RegistroClientesPage extends StatefulWidget {
  const RegistroClientesPage({super.key});

  @override
  State<RegistroClientesPage> createState() => _RegistroClientesPageState();
}

class _RegistroClientesPageState extends State<RegistroClientesPage> {
  late final ClientesController _ctrl;

  final _formKey       = GlobalKey<FormState>();
  final _nombreCtrl    = TextEditingController();
  final _rutCtrl       = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _telefonoCtrl  = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _notasCtrl     = TextEditingController();
  final _searchCtrl    = TextEditingController();

  String?     _rutPreview;
  String?     _editandoRut;
  TipoCliente _tipoSeleccionado = TipoCliente.nuevo;
  Timer?      _debounce;

  bool get _modoEdicion => _editandoRut != null;

  // ─────────────────────────────── lifecycle ───────────────────────────────

  @override
  void initState() {
    super.initState();
    _ctrl = ClientesController();
    _ctrl.addListener(() {
      if (mounted) setState(() {});
    });
    _ctrl.inicializar();
    _searchCtrl.addListener(_onSearchChanged);
    _rutCtrl.addListener(_actualizarRutPreview);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    for (final c in [
      _nombreCtrl, _rutCtrl, _emailCtrl,
      _telefonoCtrl, _direccionCtrl, _notasCtrl, _searchCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ─────────────────────────────── helpers ─────────────────────────────────

  void _actualizarRutPreview() {
    final rut = Validadores.normalizarRut(_rutCtrl.text);
    if (rut.length >= 7 && Validadores.validarRut(_rutCtrl.text) == null) {
      final preview = Cliente(
        nombre: '', rut: rut, email: '',
        fechaRegistro: DateTime.now(),
        ultimaModificacion: DateTime.now(),
      );
      setState(() => _rutPreview = '✓ ${preview.rutFormateado}');
    } else {
      setState(() => _rutPreview = null);
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _ctrl.setBusqueda(_searchCtrl.text),
    );
  }

  void _limpiarFormulario() {
    _formKey.currentState?.reset();
    for (final c in [
      _nombreCtrl, _rutCtrl, _emailCtrl,
      _telefonoCtrl, _direccionCtrl, _notasCtrl,
    ]) {
      c.clear();
    }
    setState(() {
      _rutPreview       = null;
      _editandoRut      = null;
      _tipoSeleccionado = TipoCliente.nuevo;
    });
  }

  void _iniciarEdicion(Cliente c) {
    setState(() {
      _editandoRut         = c.rut;
      _nombreCtrl.text     = c.nombre;
      _emailCtrl.text      = c.email;
      _rutCtrl.text        = c.rutFormateado;
      _telefonoCtrl.text   = c.telefono;
      _direccionCtrl.text  = c.direccion;
      _notasCtrl.text      = c.notas;
      _tipoSeleccionado    = c.tipo;
    });
  }

  void _notificar(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
  }

  // ─────────────────────────────── acciones ────────────────────────────────

  Future<void> _guardarFormulario() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _notificar('Corrige los errores marcados en rojo', Colors.orange);
      return;
    }

    final bool estabaEditando = _modoEdicion;
    final String? err;

    if (estabaEditando) {
      err = await _ctrl.actualizar(
        rut:       _editandoRut!,
        nombre:    _nombreCtrl.text,
        email:     _emailCtrl.text,
        telefono:  _telefonoCtrl.text,
        direccion: _direccionCtrl.text,
        notas:     _notasCtrl.text,
        tipo:      _tipoSeleccionado,
      );
    } else {
      err = await _ctrl.registrar(
        nombre:    _nombreCtrl.text,
        rutRaw:    _rutCtrl.text,
        email:     _emailCtrl.text,
        telefono:  _telefonoCtrl.text,
        direccion: _direccionCtrl.text,
        notas:     _notasCtrl.text,
        tipo:      _tipoSeleccionado,
      );
    }

    if (err != null) {
      _notificar(err, Colors.red);
      return;
    }

    _limpiarFormulario();
    _notificar(
      estabaEditando ? 'Cliente actualizado' : 'Cliente registrado',
      Colors.green,
    );
  }

  Future<void> _darDeBaja(Cliente c) async {
    String motivo = '';
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Dar de baja: ${c.nombre}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('RUT: ${c.rutFormateado}'),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Motivo de baja (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLength: 200,
              onChanged: (v) => motivo = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Dar de baja'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;
    await _ctrl.darDeBaja(c.rut, notas: motivo.isNotEmpty ? motivo : null);
    _notificar('${c.nombre} dado de baja', Colors.orange);
  }

  Future<void> _reactivar(Cliente c) async {
    await _ctrl.reactivar(c.rut);
    _notificar('${c.nombre} reactivado', Colors.green);
  }

  Future<void> _exportarCSV({TipoCliente? filtroTipo}) async {
    if (_ctrl.todos.isEmpty) {
      _notificar('No hay datos para exportar', Colors.orange);
      return;
    }
    final resultado = await CsvService.exportar(
      _ctrl.todos,
      filtroTipo: filtroTipo,
    );
    if (!mounted) return;
    _notificar(
      resultado == null ? 'No se pudo exportar' : 'CSV exportado: $resultado',
      resultado == null ? Colors.red : const Color(0xFF1A5C9A),
    );
  }

  Future<void> _confirmarLimpiarBD() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Limpiar base de datos'),
        content: const Text(
          'Esta acción eliminará TODOS los clientes de forma permanente.\n\n'
          '¿Estás seguro?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('SÍ, ELIMINAR TODO'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _ctrl.limpiarTodo();
    _limpiarFormulario();
    _notificar('Base de datos limpiada', Colors.red);
  }

  // ─────────────────────────────── build ───────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final esMovil = MediaQuery.of(context).size.width < 600;
    final padding = esMovil ? 10.0 : 14.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Clientes UCT',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A5C9A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_ctrl.guardando)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          PopupMenuButton<String>(
            tooltip: 'Opciones',
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'exportar_todo':
                  _exportarCSV();
                  break;
                case 'exportar_vip':
                  _exportarCSV(filtroTipo: TipoCliente.vip);
                  break;
                case 'exportar_frecuente':
                  _exportarCSV(filtroTipo: TipoCliente.frecuente);
                  break;
                case 'orden_fecha':
                  _ctrl.setOrden(OrdenClientes.fechaReciente);
                  break;
                case 'orden_nombre':
                  _ctrl.setOrden(OrdenClientes.nombre);
                  break;
                case 'toggle_inactivos':
                  _ctrl.setMostrarInactivos(!_ctrl.mostrarInactivos);
                  break;
                case 'filtro_ninguno':
                  _ctrl.setFiltroTipo(null);
                  break;
                case 'limpiar_bd':
                  _confirmarLimpiarBD();
                  break;
                default:
                  final tipo = TipoCliente.values.firstWhere(
                    (t) => 'filtro_${t.name}' == value,
                    orElse: () => TipoCliente.nuevo,
                  );
                  _ctrl.setFiltroTipo(tipo);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'exportar_todo',
                child: Text('Exportar CSV — Todos'),
              ),
              const PopupMenuItem(
                value: 'exportar_vip',
                child: Text('Exportar CSV — Solo VIP'),
              ),
              const PopupMenuItem(
                value: 'exportar_frecuente',
                child: Text('Exportar CSV — Solo Frecuentes'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'orden_fecha',
                child: Text('Ordenar por fecha (recientes)'),
              ),
              const PopupMenuItem(
                value: 'orden_nombre',
                child: Text('Ordenar por nombre'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'filtro_ninguno',
                child: Text('Ver todos los tipos'),
              ),
              ...TipoCliente.values.map(
                (t) => PopupMenuItem(
                  value: 'filtro_${t.name}',
                  child: Row(
                    children: [
                      Icon(t.icono, size: 14, color: t.color),
                      const SizedBox(width: 8),
                      Text('Filtrar: ${t.etiqueta}'),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'toggle_inactivos',
                child: Text(
                  _ctrl.mostrarInactivos
                      ? 'Ocultar inactivos'
                      : 'Mostrar inactivos',
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'limpiar_bd',
                child: Text(
                  '⚠️ Limpiar BD (pruebas)',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: _ctrl.cargando
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PanelFormulario(
                              formKey:          _formKey,
                              nombreCtrl:       _nombreCtrl,
                              rutCtrl:          _rutCtrl,
                              emailCtrl:        _emailCtrl,
                              telefonoCtrl:     _telefonoCtrl,
                              direccionCtrl:    _direccionCtrl,
                              notasCtrl:        _notasCtrl,
                              tipoSeleccionado: _tipoSeleccionado,
                              onTipoChanged:    (t) => setState(() => _tipoSeleccionado = t),
                              validarNombre:    (v) => Validadores.validarNombre(v ?? ''),
                              validarRut:       (v) => Validadores.validarRut(v ?? ''),
                              validarEmail:     (v) => Validadores.validarEmail(v ?? ''),
                              validarTelefono:  (v) => Validadores.validarTelefono(v ?? ''),
                              validarDireccion: (v) => Validadores.validarDireccion(v ?? ''),
                              rutPreview:       _rutPreview,
                              modoEdicion:      _modoEdicion,
                              onGuardar:        _guardarFormulario,
                              onCancelar:       _modoEdicion ? _limpiarFormulario : null,
                            ),
                            const SizedBox(height: 10),
                            StatsRow(
                              totalActivos:       _ctrl.totalActivos,
                              totalInactivos:     _ctrl.totalInactivos,
                              totalFiltrados:     _ctrl.totalFiltrados,
                              crecimientoMensual: _ctrl.crecimientoMensual,
                              distribucion:       _ctrl.distribucionTipos,
                            ),
                            const SizedBox(height: 8),
                            BuscadorField(controller: _searchCtrl),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                        child: _ctrl.filtrados.isEmpty
                            ? EstadoVacio(haClientes: _ctrl.todos.isNotEmpty)
                            : ListaClientes(
                                clientes:     _ctrl.filtrados,
                                onEditar:     _iniciarEdicion,
                                onDarDeBaja:  _darDeBaja,
                                onReactivar:  _reactivar,
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
} // ← cierre de _RegistroClientesPageState