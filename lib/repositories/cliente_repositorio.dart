import '../models/cliente.dart';

/// Contrato del repositorio.
abstract class ClienteRepositorio {
  Future<List<Cliente>> cargarTodos();
  Future<void> guardarTodos(List<Cliente> clientes);
  Future<void> limpiarTodo();
}