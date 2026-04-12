import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String?> exportCsvFile(String content, String fileName) async {
  final downloadsDir = await getDownloadsDirectory();
  final docsDir = await getApplicationDocumentsDirectory();
  final dir = downloadsDir ?? docsDir;

  final path = '${dir.path}/$fileName';
  final file = File(path);
  await file.writeAsString(content);
  return path;
}