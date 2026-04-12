import 'package:flutter/material.dart';

class EstadoVacio extends StatelessWidget {
  final bool haClientes;

  const EstadoVacio({super.key, required this.haClientes});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            haClientes ? Icons.search_off : Icons.people_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            haClientes
                ? 'Sin resultados para esa búsqueda.'
                : 'No hay clientes registrados aún.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}