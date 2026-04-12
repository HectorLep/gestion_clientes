import 'dart:convert';
import 'dart:html' as html;

Future<String?> exportCsvFile(String content, String fileName) async {
  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();

  html.Url.revokeObjectUrl(url);
  return 'Descarga iniciada en el navegador';
}