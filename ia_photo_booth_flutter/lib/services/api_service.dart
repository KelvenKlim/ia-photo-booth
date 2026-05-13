import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../config.dart';
import '../models/api_models.dart';

class ApiService {
  static Future<EditImageResponse> editImage({
    required File image,
    required String theme,
    required String extraInstructions,
    required String size,
  }) async {
    final uri = Uri.parse('$kApiBaseUrl/api/edit-image');
    final request = http.MultipartRequest('POST', uri);

    request.fields['theme'] = theme;
    request.fields['extra_instructions'] = extraInstructions;
    request.fields['size'] = size;
    final ext = image.path.split('.').last.toLowerCase();
    final mime = ext == 'png' ? 'image/png' : ext == 'webp' ? 'image/webp' : 'image/jpeg';
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType.parse(mime),
    ));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode}: ${response.reasonPhrase}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return EditImageResponse.fromJson(data);
  }

  static Future<void> sendEmail({
    required String toEmail,
    required String imageBase64,
  }) async {
    final uri = Uri.parse('$kApiBaseUrl/api/send-email');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'to_email': toEmail,
        'image_base64': imageBase64,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao enviar e-mail: ${response.reasonPhrase}');
    }
  }
}
