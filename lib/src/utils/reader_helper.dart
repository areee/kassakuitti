import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';

/// Read a text file and return as a [List<String>].
Future<List<String>> readTextFile(String filePath) async {
  try {
    var file = File(filePath);
    return await file.readAsLines();
  } on Exception {
    rethrow;
  }
}

/// Read a HTML file and return as a [Document].
Future<Document> readHTMLFile(String filePath) async {
  try {
    var file = File(filePath);
    var html = await file.readAsString();
    return parse(html);
  } on Exception {
    rethrow;
  }
}
