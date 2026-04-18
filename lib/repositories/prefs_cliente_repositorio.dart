import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cliente.dart';
import 'cliente_repositorio.dart';

class PrefsClienteRepositorio implements ClienteRepositorio {
  static const _key = 'uct_clientes_v5';

  @override
  Future<List<Cliente>> cargarTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return [];
      final lista = json.decode(raw) as List<dynamic>;
      return lista
          .map((e) => Cliente.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> guardarTodos(List<Cliente> clientes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      json.encode(clientes.map((c) => c.toJson()).toList()),
    );
  }

  @override
  Future<void> limpiarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}