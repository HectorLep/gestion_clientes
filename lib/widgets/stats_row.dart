import 'package:flutter/material.dart';
import '../models/tipo_cliente.dart';

class StatsRow extends StatelessWidget {
  final int totalActivos;
  final int totalInactivos;
  final int totalFiltrados;
  final double crecimientoMensual;
  final Map<TipoCliente, int> distribucion;

  const StatsRow({
    super.key,
    required this.totalActivos,
    required this.totalInactivos,
    required this.totalFiltrados,
    required this.crecimientoMensual,
    required this.distribucion,
  });

  @override
  Widget build(BuildContext context) {
    final signo = crecimientoMensual >= 0 ? '+' : '';
    final colorC = crecimientoMensual >= 0 ? Colors.green.shade700 : Colors.red.shade700;

    return LayoutBuilder(
      builder: (context, constraints) {
        final esMovil = constraints.maxWidth < 600;
        final anchoCard = esMovil ? (constraints.maxWidth - 12) / 2 : (constraints.maxWidth - 18) / 4;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                SizedBox(width: anchoCard, child: _StatCard(valor: totalActivos, etiqueta: 'activos')),
                SizedBox(width: anchoCard, child: _StatCard(valor: totalInactivos, etiqueta: 'inactivos')),
                SizedBox(width: anchoCard, child: _StatCard(valor: totalFiltrados, etiqueta: 'en vista')),
                SizedBox(
                  width: anchoCard,
                  child: _StatCard(
                    valorTexto: '$signo${crecimientoMensual.toStringAsFixed(0)}%',
                    etiqueta: 'crec. mensual',
                    colorValor: colorC,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: TipoCliente.values.map((t) {
                final count = distribucion[t] ?? 0;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: TipoClienteHelper.colorFondo(t),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: TipoClienteHelper.color(t).withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(TipoClienteHelper.icono(t), size: 14, color: TipoClienteHelper.color(t)),
                      const SizedBox(width: 5),
                      Text(
                        '${TipoClienteHelper.etiqueta(t)}: $count',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: TipoClienteHelper.color(t),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final int? valor;
  final String? valorTexto;
  final String etiqueta;
  final Color? colorValor;

  const _StatCard({
    this.valor,
    this.valorTexto,
    required this.etiqueta,
    this.colorValor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valorTexto ?? '${valor ?? 0}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colorValor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}