import 'dart:io';
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

void main() async {
  final paths = [
    r'C:\Users\HP\.gemini\antigravity-ide\brain\b41114d8-8dab-4be4-b641-021b66e1513c\.system_generated\steps\2114\content.md',
    r'C:\Users\HP\.gemini\antigravity-ide\brain\b41114d8-8dab-4be4-b641-021b66e1513c\.system_generated\steps\2118\content.md',
    r'C:\Users\HP\.gemini\antigravity-ide\brain\b41114d8-8dab-4be4-b641-021b66e1513c\.system_generated\steps\2119\content.md',
    r'C:\Users\HP\.gemini\antigravity-ide\brain\b41114d8-8dab-4be4-b641-021b66e1513c\.system_generated\steps\2120\content.md',
    r'C:\Users\HP\.gemini\antigravity-ide\brain\b41114d8-8dab-4be4-b641-021b66e1513c\.system_generated\steps\2121\content.md',
  ];

  List<Map<String, dynamic>> results = [];

  for (var path in paths) {
    final file = File(path);
    if (!await file.exists()) {
      print('File not found: $path');
      continue;
    }
    String content = await file.readAsString();
    // find html start
    int htmlStart = content.indexOf('<!DOCTYPE html>');
    if (htmlStart == -1) {
      print('No HTML found in $path');
      continue;
    }
    String htmlContent = content.substring(htmlStart);
    var document = parse(htmlContent);

    // Get Title
    var titleEl = document.querySelector('h1');
    String title = titleEl?.text.trim() ?? 'Khutbah Jumat';

    // Get article content
    var articleContent = document.querySelector('.article-content');
    if (articleContent == null) {
      print('No article content in $path');
      continue;
    }

    List<Map<String, String>> sections = [];
    String currentText = '';
    Map<String, String>? currentArabic;

    void flushText() {
      if (currentText.trim().isNotEmpty) {
        sections.add({
          'type': 'text',
          'content': currentText.trim(),
        });
        currentText = '';
      }
    }

    void flushArabic() {
      if (currentArabic != null) {
        sections.add({
          'type': 'arabic',
          'content': currentArabic!['content'] ?? '',
          'translation': currentArabic!['translation'] ?? '',
        });
        currentArabic = null;
      }
    }

    for (var child in articleContent.children) {
      if (child.localName == 'p' && child.classes.contains('arabic')) {
        flushText();
        flushArabic();
        currentArabic = {
          'content': child.text.trim(),
          'translation': '',
        };
      } else if (child.localName == 'p') {
        String text = child.text.trim();
        if (text.startsWith('Artinya,') && currentArabic != null) {
          String trans = text.substring(8).trim();
          if (trans.startsWith('"') && trans.endsWith('"')) {
            trans = trans.substring(1, trans.length - 1);
          } else if (trans.startsWith('“') && trans.endsWith('”')) {
            trans = trans.substring(1, trans.length - 1);
          }
          currentArabic!['translation'] = trans;
          flushArabic();
        } else if (text.startsWith('Terjemahan:') && currentArabic != null) {
          String trans = text.substring(11).trim();
          currentArabic!['translation'] = trans;
          flushArabic();
        } else {
          flushArabic();
          if (currentText.isNotEmpty) currentText += '\n\n';
          currentText += text;
        }
      } else if (child.localName == 'h2' || child.localName == 'h3') {
        flushArabic();
        if (currentText.isNotEmpty) currentText += '\n\n';
        currentText += child.text.trim();
      } else if (child.localName == 'ul' || child.localName == 'ol') {
        flushArabic();
        for (var li in child.children) {
          if (li.localName == 'li') {
            if (currentText.isNotEmpty) currentText += '\n';
            currentText += '- ' + li.text.trim();
          }
        }
      }
    }
    flushText();
    flushArabic();

    results.add({
      'title': title,
      'date': '14 Ramadhan 1445 H', // Dummy date
      'sections': sections,
    });
  }

  // print out as Dart code
  StringBuffer sb = StringBuffer();
  sb.writeln('  final List<Map<String, dynamic>> _khutbahMenu = [');
  for (var r in results) {
    sb.writeln('    {');
    sb.writeln("      'title': '${r['title']?.replaceAll("'", "\\'")}',");
    sb.writeln("      'date': '${r['date']}',");
    sb.writeln("      'sections': [");
    for (var s in r['sections']) {
      sb.writeln('        {');
      sb.writeln("          'type': '${s['type']}',");
      sb.writeln("          'content': '''${s['content']}''',");
      if (s.containsKey('translation') && s['translation'].toString().isNotEmpty) {
        sb.writeln("          'translation': '''${s['translation']}''',");
      }
      sb.writeln('        },');
    }
    sb.writeln("      ]");
    sb.writeln('    },');
  }
  sb.writeln('  ];');

  File(r'd:\uas\lib\khutbah_data.dart.txt').writeAsStringSync(sb.toString());
  print('Done parsing. Output written to d:\\uas\\lib\\khutbah_data.dart.txt');
}
