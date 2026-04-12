import 'package:flutter/material.dart';
import '../models/cliente.dart';

class ListaClientes extends StatelessWidget {
  final List<Cliente> clientes;
  final void Function(Cliente) onEditar;
  final void Function(Cliente) onDarDeBaja;
  final void Function(Cliente) onReactivar;

  const ListaClientes({
    super.key,
    required this.clientes,
    required this.onEditar,
    required this.onDarDeBaja,
    required this.onReactivar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: clientes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, i) {
        final c = clientes[i];
        final colorTexto = c.activo ? null : Colors.grey.shade500;

        return Card(
          elevation: 0,
          color: c.activo ? null : Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: c.activo ? const Color(0xFFB5D4F4) : Colors.grey.shade300,
              child: Text(
                c.iniciales,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.activo ? const Color(0xFF0C447C) : Colors.grey.shade700,
                ),
              ),
            ),
            title: Text(
              c.nombre,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: colorTexto,
                decoration: c.activo ? null : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  'RUT: ${c.rutFormateado}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Text(
                  c.email,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Registro: ${c.fechaFormateada} • ${c.activo ? 'Activo' : 'Inactivo'}',
                  style: TextStyle(
                    color: c.activo ? Colors.teal.shade700 : Colors.orange.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  c.activo ? Icons.verified : Icons.pause_circle_outline,
                  color: c.activo ? const Color(0xFF185FA5) : Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 2),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  color: Colors.grey.shade500,
                  tooltip: 'Editar',
                  onPressed: c.activo ? () => onEditar(c) : null,
                ),
                IconButton(
                  icon: Icon(
                    c.activo ? Icons.person_remove_outlined : Icons.restart_alt,
                    size: 18,
                  ),
                  color: c.activo ? Colors.orange.shade700 : Colors.green.shade700,
                  tooltip: c.activo ? 'Dar de baja' : 'Reactivar',
                  onPressed: () => c.activo ? onDarDeBaja(c) : onReactivar(c),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}