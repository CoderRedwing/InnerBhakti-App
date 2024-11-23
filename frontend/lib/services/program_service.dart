import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/program_model.dart';

class ProgramService {
  static final String? _baseUrl = dotenv.env['BASE_URL_PROGRAMS'];

  static Future<List<Program>> fetchPrograms() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl!));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((program) => Program.fromJson(program)).toList();
      } else {
        throw Exception('Failed to load programs: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching programs: $e');
      }
      return [];
    }
  }
}
