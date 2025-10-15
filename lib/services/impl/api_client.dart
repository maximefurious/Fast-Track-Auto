import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Adapte pour ton backend
  static const String baseUrl = 'http://147.79.118.75:5000';
  static const String vehiclesPath = '/api/vehicles';
  static const String loginPath = '/api/login';
  static const String registerPath = '/api/register';

  static Uri _u(String path) => Uri.parse('$baseUrl$path');

  static Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final resp = await http.post(
      _u(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final payload = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw ApiException(
        statusCode: resp.statusCode,
        message: payload['error']?.toString() ?? 'Erreur HTTP ${resp.statusCode}',
        payload: payload,
      );
    }
    return payload as Map<String, dynamic>;
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? payload;
  ApiException({required this.statusCode, required this.message, this.payload});
  @override
  String toString() => 'ApiException($statusCode): $message';
}
