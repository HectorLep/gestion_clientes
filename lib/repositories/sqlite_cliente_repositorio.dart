import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cliente.dart';
import '../models/tipo_cliente.dart';
import 'cliente_repositorio.dart';

class SqliteClienteRepositorio implements ClienteRepositorio {
  static const _dbName = 'uct_clientes.db';
  static const _dbVersion = 1;
  static const _tabla = 'clientes';

  Database? _db;

  Future<Database> get _database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tabla (
            rut           TEXT PRIMARY KEY,
            nombre        TEXT NOT NULL,
            email         TEXT NOT NULL,
            telefono      TEXT NOT NULL DEFAULT '',
            direccion     TEXT NOT NULL DEFAULT '',
            notas         TEXT NOT NULL DEFAULT '',
            tipo          TEXT NOT NULL DEFAULT 'nuevo',
            fechaRegistro TEXT NOT NULL,
            ultimaMod     TEXT NOT NULL,
            activo        INTEGER NOT NULL DEFAULT 1
          )
        ''');
        // Índices para búsqueda rápida
        await db.execute(
            'CREATE INDEX idx_email ON $_tabla (email)');
        await db.execute(
            'CREATE INDEX idx_activo ON $_tabla (activo)');
        await db.execute(
            'CREATE INDEX idx_tipo ON $_tabla (tipo)');
      },
    );
  }

  @override
  Future<List<Cliente>> cargarTodos() async {
    try {
      final db = await _database;
      final rows = await db.query(_tabla, orderBy: 'fechaRegistro DESC');
      return rows.map(_rowToCliente).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> guardarTodos(List<Cliente> clientes) async {
    final db = await _database;
    final batch = db.batch();

    // Upsert completo: borra todo y reinserta
    // Para producción real se haría upsert individual, pero aquí
    // el controller ya maneja la lista completa en memoria.
    batch.delete(_tabla);
    for (final c in clientes) {
      batch.insert(
        _tabla,
        _clienteToRow(c),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> limpiarTodo() async {
    final db = await _database;
    await db.delete(_tabla);
  }

  // ── Conversión ────────────────────────────────────────────

  Map<String, dynamic> _clienteToRow(Cliente c) => {
        'rut':           c.rut,
        'nombre':        c.nombre,
        'email':         c.email,
        'telefono':      c.telefono,
        'direccion':     c.direccion,
        'notas':         c.notas,
        'tipo':          c.tipo.name,
        'fechaRegistro': c.fechaRegistro.toIso8601String(),
        'ultimaMod':     c.ultimaModificacion.toIso8601String(),
        'activo':        c.activo ? 1 : 0,
      };

  Cliente _rowToCliente(Map<String, dynamic> row) => Cliente(
        rut:      row['rut'] as String,
        nombre:   row['nombre'] as String,
        email:    row['email'] as String,
        telefono: row['telefono'] as String? ?? '',
        direccion: row['direccion'] as String? ?? '',
        notas:    row['notas'] as String? ?? '',
        tipo: TipoCliente.values.firstWhere(
          (t) => t.name == (row['tipo'] as String? ?? ''),
          orElse: () => TipoCliente.nuevo,
        ),
        fechaRegistro: DateTime.parse(row['fechaRegistro'] as String),
        ultimaModificacion: DateTime.parse(row['ultimaMod'] as String),
        activo: (row['activo'] as int) == 1,
      );
}