import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CVParserService {
  Future<Map<String, String?>> parseCVFromFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);

      String text = '';
      for (int i = 0; i < document.pages.count; i++) {
        final page = document.pages[i];
        final extractor = PdfTextExtractor(page as PdfDocument);
        text += extractor.extractText();
      }

      document.dispose();

      return _extractInformation(text);
    } catch (e) {
      return {
        'name': null,
        'email': null,
        'phone': null,
      };
    }
  }

  Map<String, String?> _extractInformation(String text) {
    final emailRegex = RegExp(
        r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final phoneRegex =
        RegExp(r'(\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}');

    final emailMatch = emailRegex.firstMatch(text);
    final phoneMatch = phoneRegex.firstMatch(text);

    final lines = text.split('\n');
    String? name;
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.length > 2 &&
          trimmed.length < 50 &&
          !trimmed.contains('@') &&
          RegExp(r'^[A-Za-z\s]+$').hasMatch(trimmed)) {
        name = trimmed;
        break;
      }
    }

    return {
      'name': name,
      'email': emailMatch?.group(0),
      'phone': phoneMatch?.group(0),
    };
  }
}
