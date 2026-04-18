import 'package:flutter/material.dart';
import '../models/tipo_cliente.dart';

class PanelFormulario extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nombreCtrl;
  final TextEditingController rutCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController telefonoCtrl;
  final TextEditingController direccionCtrl;
  final TextEditingController notasCtrl;
  final TipoCliente tipoSeleccionado;
  final void Function(TipoCliente) onTipoChanged;
  final String? rutPreview;
  final bool modoEdicion;
  final VoidCallback onGuardar;
  final VoidCallback? onCancelar;

  final String? Function(String?) validarNombre;
  final String? Function(String?) validarRut;
  final String? Function(String?) validarEmail;
  final String? Function(String?) validarTelefono;
  final String? Function(String?) validarDireccion;

  const PanelFormulario({
    super.key,
    required this.formKey,
    required this.nombreCtrl,
    required this.rutCtrl,
    required this.emailCtrl,
    required this.telefonoCtrl,
    required this.direccionCtrl,
    required this.notasCtrl,
    required this.tipoSeleccionado,
    required this.onTipoChanged,
    required this.validarNombre,
    required this.validarRut,
    required this.validarEmail,
    required this.validarTelefono,
    required this.validarDireccion,
    required this.rutPreview,
    required this.modoEdicion,
    required this.onGuardar,
    this.onCancelar,
  });

  @override
  State<PanelFormulario> createState() => _PanelFormularioState();
}

class _PanelFormularioState extends State<PanelFormulario> {
  bool _mostrarMas = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final esMovil = constraints.maxWidth < 600;

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: widget.modoEdicion ? const Color(0xFF1A5C9A) : Colors.grey.shade200,
              width: widget.modoEdicion ? 1.5 : 0.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(esMovil ? 12 : 14),
            child: Form(
              key: widget.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.modoEdicion)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Color(0xFF1A5C9A),
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'Editando cliente',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A5C9A),
                              ),
                            ),
                          ),
                          if (widget.onCancelar != null)
                            TextButton(
                              onPressed: widget.onCancelar,
                              child: const Text('Cancelar'),
                            ),
                        ],
                      ),
                    ),

                  TextFormField(
                    controller: widget.nombreCtrl,
                    validator: widget.validarNombre,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    maxLength: 80,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: widget.rutCtrl,
                    enabled: !widget.modoEdicion,
                    validator: widget.modoEdicion ? null : widget.validarRut,
                    decoration: InputDecoration(
                      labelText: 'RUT *',
                      prefixIcon: const Icon(Icons.badge_outlined),
                      helperText: widget.modoEdicion
                          ? 'RUT no modificable'
                          : (widget.rutPreview ?? 'Ej: 12.345.678-9 o 5126663K'),
                    ),
                    maxLength: 12,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: widget.emailCtrl,
                    validator: widget.validarEmail,
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    maxLength: 120,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 4),

                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _mostrarMas = !_mostrarMas),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _mostrarMas ? Icons.expand_less : Icons.expand_more,
                            color: const Color(0xFF1A5C9A),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _mostrarMas ? 'Ocultar más detalles' : 'Mostrar más detalles',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A5C9A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 220),
                    crossFadeState: _mostrarMas
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Column(
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: widget.telefonoCtrl,
                          validator: widget.validarTelefono,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: Icon(Icons.phone_outlined),
                            helperText: 'Ej: +56912345678',
                          ),
                          maxLength: 20,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: widget.direccionCtrl,
                          validator: widget.validarDireccion,
                          decoration: const InputDecoration(
                            labelText: 'Dirección',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          maxLength: 150,
                          keyboardType: TextInputType.streetAddress,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<TipoCliente>(
                          value: widget.tipoSeleccionado,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de cliente',
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          items: TipoCliente.values
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(
                                    t.etiqueta,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (t) {
                            if (t != null) widget.onTipoChanged(t);
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: widget.notasCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Notas internas',
                            prefixIcon: Icon(Icons.notes_outlined),
                            helperText: 'Ej: motivo de baja, observaciones',
                          ),
                          maxLength: 300,
                          maxLines: esMovil ? 3 : 2,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ],
                    ),
                    secondChild: const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: widget.onGuardar,
                    icon: Icon(
                      widget.modoEdicion ? Icons.save_outlined : Icons.person_add_outlined,
                    ),
                    label: Text(
                      widget.modoEdicion ? 'GUARDAR CAMBIOS' : 'REGISTRAR CLIENTE',
                    ),
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: esMovil ? 16 : 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}