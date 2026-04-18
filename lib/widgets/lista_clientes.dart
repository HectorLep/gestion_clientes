import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../models/tipo_cliente.dart';

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
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _ClienteTile(
        cliente: clientes[i],
        onEditar: () => onEditar(clientes[i]),
        onDarDeBaja: () => onDarDeBaja(clientes[i]),
        onReactivar: () => onReactivar(clientes[i]),
      ),
    );
  }
}

class _ClienteTile extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onEditar;
  final VoidCallback onDarDeBaja;
  final VoidCallback onReactivar;

  const _ClienteTile({
    required this.cliente,
    required this.onEditar,
    required this.onDarDeBaja,
    required this.onReactivar,
  });

  @override
  Widget build(BuildContext context) {
    final c = cliente;
    final colorTexto = c.activo ? Colors.black87 : Colors.grey.shade500;

    return LayoutBuilder(
      builder: (context, constraints) {
        final esMovil = constraints.maxWidth < 600;

        return Card(
          elevation: 0,
          color: c.activo ? null : Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: esMovil
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: c.activo
                                ? TipoClienteHelper.colorFondo(c.tipo)
                                : Colors.grey.shade200,
                            child: Text(
                              c.iniciales,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: c.activo
                                    ? TipoClienteHelper.color(c.tipo)
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              c.nombre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: colorTexto,
                                decoration:
                                    c.activo ? null : TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: c.activo ? onEditar : null,
                            tooltip: 'Editar',
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            icon: Icon(
                              c.activo
                                  ? Icons.person_remove_outlined
                                  : Icons.restart_alt,
                              size: 19,
                            ),
                            color: c.activo
                                ? Colors.orange.shade700
                                : Colors.green.shade700,
                            onPressed: c.activo ? onDarDeBaja : onReactivar,
                            tooltip: c.activo ? 'Dar de baja' : 'Reactivar',
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: TipoClienteHelper.colorFondo(c.tipo),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: TipoClienteHelper.color(c.tipo)
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  TipoClienteHelper.icono(c.tipo),
                                  size: 12,
                                  color: TipoClienteHelper.color(c.tipo),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  TipoClienteHelper.etiqueta(c.tipo),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: TipoClienteHelper.color(c.tipo),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'RUT: ${c.rutFormateado}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                      Text(
                        c.email,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                      if (c.telefono.isNotEmpty)
                        Text(
                          'Tel: ${c.telefono}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      if (c.direccion.isNotEmpty)
                        Text(
                          c.direccion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        'Registro: ${c.fechaFormateada}',
                        style: TextStyle(
                          color: c.activo
                              ? Colors.teal.shade700
                              : Colors.orange.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Modificado: ${c.ultimaModificacionFormateada}',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                      if (c.notas.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Notas: ${c.notas}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: c.activo
                            ? TipoClienteHelper.colorFondo(c.tipo)
                            : Colors.grey.shade200,
                        child: Text(
                          c.iniciales,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: c.activo
                                ? TipoClienteHelper.color(c.tipo)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    c.nombre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: colorTexto,
                                      decoration: c.activo
                                          ? null
                                          : TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TipoClienteHelper.colorFondo(c.tipo),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: TipoClienteHelper.color(c.tipo)
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        TipoClienteHelper.icono(c.tipo),
                                        size: 11,
                                        color: TipoClienteHelper.color(c.tipo),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        TipoClienteHelper.etiqueta(c.tipo),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: TipoClienteHelper.color(c.tipo),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'RUT: ${c.rutFormateado}  •  ${c.email}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            if (c.telefono.isNotEmpty)
                              Text(
                                'Tel: ${c.telefono}',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                              ),
                            if (c.direccion.isNotEmpty)
                              Text(
                                c.direccion,
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'Registro: ${c.fechaFormateada}  •  Mod: ${c.ultimaModificacionFormateada}',
                              style: TextStyle(
                                color: c.activo
                                    ? Colors.teal.shade700
                                    : Colors.orange.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (c.notas.isNotEmpty)
                              Text(
                                'Notas: ${c.notas}',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: c.activo ? onEditar : null,
                            tooltip: 'Editar',
                          ),
                          IconButton(
                            icon: Icon(
                              c.activo
                                  ? Icons.person_remove_outlined
                                  : Icons.restart_alt,
                              size: 19,
                            ),
                            color: c.activo
                                ? Colors.orange.shade700
                                : Colors.green.shade700,
                            onPressed: c.activo ? onDarDeBaja : onReactivar,
                            tooltip: c.activo ? 'Dar de baja' : 'Reactivar',
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}