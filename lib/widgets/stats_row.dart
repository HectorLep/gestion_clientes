import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final int total;
  final int filtrados;
  final int inactivos;

  const StatsRow({
    super.key,
    required this.total,
    required this.filtrados,
    required this.inactivos,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(valor: total, etiqueta: 'registrados')),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(valor: filtrados, etiqueta: 'en búsqueda')),
        const SizedBox(width: 8),
        Expanded(child: _StatCard(valor: inactivos, etiqueta: 'inactivos')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int valor;
  final String etiqueta;

  const _StatCard({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$valor',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          Text(
            etiqueta,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}