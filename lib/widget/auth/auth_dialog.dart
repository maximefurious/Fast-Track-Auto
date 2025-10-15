import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// MODELE — si tu as déjà un modèle, importe-le à la place
class AuthResult {
  final String userId;
  final String token;   // Pas de vrai token ici (backend non fourni), on laisse vide
  final bool isLogin;   // true: login, false: signup

  AuthResult({
    required this.userId,
    required this.token,
    required this.isLogin,
  });

  @override
  String toString() => 'AuthResult(userId: $userId, token: $token, isLogin: $isLogin)';
}

class AuthDialog extends StatefulWidget {
  const AuthDialog({
    super.key,
    required this.onDone,
    this.baseUrl = 'http://147.79.118.75:5000', // ← adapte pour iOS/Prod (ex: https://api.tondomaine.com)
  });

  /// Callback qui reçoit l’AuthResult quand l’action réussit
  final void Function(AuthResult result) onDone;

  /// Base URL de ton API Flask (sans le suffixe /users)
  final String baseUrl;

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController(); // utilisé pour l’inscription

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _fullNameCtrl.dispose();
    super.dispose();
  }

  Uri _usersUri() => Uri.parse('${widget.baseUrl}/api/users/');

  /// Appelle POST /api/users/ pour créer un utilisateur
  Future<AuthResult> _signup(String email, {String? fullName}) async {
    final resp = await http.post(
      _usersUri(),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        if (fullName != null && fullName.trim().isNotEmpty) 'full_name': fullName.trim(),
      }),
    );

    if (resp.statusCode == 201) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final user = (data['user'] ?? {}) as Map<String, dynamic>;
      final id = (user['id'] ?? '').toString();
      if (id.isEmpty) {
        throw Exception('Réponse serveur invalide: id manquant');
      }
      return AuthResult(userId: id, token: '', isLogin: false);
    }

    // Gère erreurs connues renvoyées par ton backend
    try {
      final data = jsonDecode(resp.body);
      final msg = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : resp.body;
      if (resp.statusCode == 409) {
        // Email déjà utilisé → il nous manque un endpoint pour récupérer l’utilisateur par email
        throw Exception('Email déjà utilisé. Il faut un endpoint de connexion ou de recherche par email.');
      }
      throw Exception('Echec inscription (${resp.statusCode}): $msg');
    } catch (_) {
      throw Exception('Echec inscription (${resp.statusCode}).');
    }
  }

  /// Connexion: sans endpoint /auth/login ou /users?email=..., on ne peut pas terminer.
  Future<AuthResult> _login(String email, String password) async {
    // Ici, on indique clairement le manque côté backend.
    throw Exception(
      'Aucun endpoint de connexion disponible. '
          'Expose /auth/login (POST email/mot_de_passe) ou /users?email=... pour récupérer l’utilisateur.',
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text; // non utilisé côté backend actuel
    final fullName = _fullNameCtrl.text.trim().isEmpty ? null : _fullNameCtrl.text.trim();

    try {
      AuthResult result;
      if (_isLogin) {
        result = await _login(email, password);
      } else {
        result = await _signup(email, fullName: fullName);
      }

      // Notifie l’appelant puis ferme le dialog avec un bool (true)
      widget.onDone(result);
      if (mounted) {
        Navigator.of(context).pop<bool>(true);
      }
    } catch (e) {
      setState(() => _errorText = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _cancel() {
    Navigator.of(context).pop<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isLogin ? 'Connexion' : 'Inscription',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fermer',
                      onPressed: _cancel,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email requis';
                    final email = v.trim();
                    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
                    if (!ok) return 'Email invalide';
                    return null;
                  },
                ),

                // Mot de passe (pas utilisé côté backend actuel mais on garde l’UI)
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (v) {
                    if (_isLogin) {
                      if (v == null || v.isEmpty) return 'Mot de passe requis';
                    } else {
                      if (v == null || v.isEmpty) return 'Mot de passe requis';
                      if (v.length < 6) return 'Au moins 6 caractères';
                    }
                    return null;
                  },
                ),

                // Full name pour inscription
                if (!_isLogin) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fullNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nom complet (optionnel)',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                ],

                const SizedBox(height: 8),

                if (_errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorText!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () => setState(() => _isLogin = !_isLogin),
                      icon: const Icon(Icons.swap_horiz),
                      label: Text(_isLogin ? 'Créer un compte' : 'J’ai déjà un compte'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _submit,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.check),
                      label: Text(_isLogin ? 'Se connecter' : 'S’inscrire'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
