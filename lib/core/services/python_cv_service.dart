import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PythonCVService {
  final String serverUrl;

  PythonCVService({this.serverUrl = 'http://172.....:5001/parse_cv'});

  Future<Map<String, String?>> parseCV(File pdfFile) async {
    final request = http.MultipartRequest('POST', Uri.parse(serverUrl));
    request.files.add(await http.MultipartFile.fromPath('file', pdfFile.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(respStr);
      return {
        'name': data['name'],
        'email': data['email'],
        'phone': data['phone'],
      };
    } else {
      throw Exception('Failed to parse CV: $respStr');
    }
  }
}
