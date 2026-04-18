import '../models/cliente.dart';

/// Contrato del repositorio.
/// Cualquier implementación (SQLite, SharedPrefs, API REST)
/// debe cumplir esta interfaz sin que la UI se entere del cambio.
abstract class ClienteRepositorio {
  Future<List<Cliente>> cargarTodos();
  Future<void> guardarTodos(List<Cliente> clientes);
  Future<void> limpiarTodo();
}