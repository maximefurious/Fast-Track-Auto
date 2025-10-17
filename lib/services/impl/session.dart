import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// Modèle minimal côté UI
class AuthResult {
  final String userId;
  final String token;
  final bool isLogin;
  AuthResult({required this.userId, required this.token, required this.isLogin});
}

class Session {
  Session._();
  static final Session instance = Session._();

  // Stockage sécurisé
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _kUserId = 'auth_user_id';
  static const _kToken  = 'auth_token';

  String? _userId;
  String? _token;

  String? get userId => _userId;
  String? get token  => _token;
  bool get isAuthenticated => _userId != null && _token != null && _token!.isNotEmpty;

  // Charge depuis le stockage sécurisé (à appeler au boot de l’app)
  Future<void> load() async {
    _userId = await _storage.read(key: _kUserId);
    _token  = await _storage.read(key: _kToken);
  }

  // Sauvegarde à partir d’un AuthResult (login/signup)
  Future<void> saveAuth(AuthResult result) async {
    _userId = result.userId;
    _token  = result.token;
    await _storage.write(key: _kUserId, value: _userId);
    await _storage.write(key: _kToken,  value: _token);
  }

  // Déconnexion
  Future<void> clear() async {
    _userId = null;
    _token  = null;
    await _storage.delete(key: _kUserId);
    await _storage.delete(key: _kToken);
  }

  // Helpers HTTP: ajout automatique du Bearer token si connecté
  Map<String, String> _authHeaders([Map<String, String>? base]) {
    final headers = <String, String>{};
    if (base != null) headers.addAll(base);
    if (isAuthenticated) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) {
    return http.get(uri, headers: _authHeaders(headers));
  }

  Future<http.Response> post(Uri uri, {Object? body, Map<String, String>? headers}) {
    final h = _authHeaders({'Content-Type': 'application/json', ...?headers});
    return http.post(uri, headers: h, body: body);
  }

  Future<http.Response> put(Uri uri, {Object? body, Map<String, String>? headers}) {
    final h = _authHeaders({'Content-Type': 'application/json', ...?headers});
    return http.put(uri, headers: h, body: body);
  }

  Future<http.Response> delete(Uri uri, {Object? body, Map<String, String>? headers}) {
    final h = _authHeaders({'Content-Type': 'application/json', ...?headers});
    return http.delete(uri, headers: h, body: body);
  }
}
