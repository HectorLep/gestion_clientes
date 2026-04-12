import 'package:flutter/services.dart';

class RutInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.toUpperCase().replaceAll(RegExp(r'[^0-9K]'), '');

    if (raw.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    String formatted;

    if (raw.length == 1) {
      formatted = raw;
    } else {
      final dv = raw.substring(raw.length - 1);
      final cuerpo = raw.substring(0, raw.length - 1);
      final buffer = StringBuffer();

      for (int i = 0; i < cuerpo.length; i++) {
        if (i > 0 && (cuerpo.length - i) % 3 == 0) {
          buffer.write('.');
        }
        buffer.write(cuerpo[i]);
      }

      formatted = '${buffer.toString()}-$dv';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}   