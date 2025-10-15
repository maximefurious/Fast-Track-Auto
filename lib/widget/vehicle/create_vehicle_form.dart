import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:furious_app/services/impl/api_client.dart';
import 'package:furious_app/services/impl/session.dart';
import 'package:http/http.dart' as http;

class CreateVehicleForm extends StatefulWidget {
  const CreateVehicleForm({super.key});

  @override
  State<CreateVehicleForm> createState() => _CreateVehicleFormState();
}

class _CreateVehicleFormState extends State<CreateVehicleForm> {
  final _formKey = GlobalKey<FormState>();
  final _vinCtrl = TextEditingController();
  final _immatCtrl = TextEditingController();
  final _marqueCtrl = TextEditingController();
  final _modeleCtrl = TextEditingController();
  final _anneeCtrl = TextEditingController();
  String? _carburant;

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _vinCtrl.dispose();
    _immatCtrl.dispose();
    _marqueCtrl.dispose();
    _modeleCtrl.dispose();
    _anneeCtrl.dispose();
    super.dispose();
  }

  String? _validateVin(String? v) {
    if (v == null || v.trim().isEmpty) return 'VIN obligatoire';
    final s = v.trim().toUpperCase();
    if (s.length != 17) return 'VIN doit avoir 17 caractères';
    return null;
  }

  String? _validateImmat(String? v) {
    if (v == null || v.trim().isEmpty) return 'Immatriculation obligatoire';
    final s = v.trim().toUpperCase().replaceAll('-', '');
    final reg = RegExp(r'^[A-Z]{2}[0-9]{3}[A-Z]{2}$'); // format FR simplifié
    if (!reg.hasMatch(s)) return 'Format FR attendu ex: AB-123-CD';
    return null;
  }

  String? _validateText(String? v, String label, {int min = 1}) {
    if (v == null || v.trim().length < min) return '$label obligatoire';
    return null;
  }

  String? _validateAnnee(String? v) {
    if (v == null || v.isEmpty) return 'Année obligatoire';
    final n = int.tryParse(v);
    final nowYear = DateTime.now().year;
    if (n == null || n < 1900 || n > nowYear + 1) return 'Année invalide';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = Session.instance.userId;
    if (userId == null) {
      setState(() => _error = 'Veuillez vous connecter avant de créer un véhicule.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final body = {
        'user_id': userId,
        'vin': _vinCtrl.text.trim().toUpperCase(),
        'immatriculation': _immatCtrl.text.trim().toUpperCase(),
        'marque': _marqueCtrl.text.trim(),
        'modele': _modeleCtrl.text.trim(),
        'annee': int.parse(_anneeCtrl.text.trim()),
        'carburant': _carburant ?? 'Inconnu',
      };

      final uri = Uri.parse('${ApiClient.baseUrl}${ApiClient.vehiclesPath}/');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (resp.statusCode == 201) {
        if (mounted) Navigator.pop(context, true);
      } else {
        final payload = jsonDecode(resp.body);
        setState(() => _error = payload['error']?.toString() ?? 'Erreur ${resp.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Erreur réseau: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Créer un véhicule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _vinCtrl,
                    decoration: const InputDecoration(labelText: 'VIN (17 caractères)'),
                    textCapitalization: TextCapitalization.characters,
                    validator: _validateVin,
                  ),
                  TextFormField(
                    controller: _immatCtrl,
                    decoration: const InputDecoration(labelText: 'Immatriculation (ex: AB-123-CD)'),
                    textCapitalization: TextCapitalization.characters,
                    validator: _validateImmat,
                  ),
                  TextFormField(
                    controller: _marqueCtrl,
                    decoration: const InputDecoration(labelText: 'Marque'),
                    validator: (v) => _validateText(v, 'Marque'),
                  ),
                  TextFormField(
                    controller: _modeleCtrl,
                    decoration: const InputDecoration(labelText: 'Modèle'),
                    validator: (v) => _validateText(v, 'Modèle'),
                  ),
                  TextFormField(
                    controller: _anneeCtrl,
                    decoration: const InputDecoration(labelText: 'Année'),
                    keyboardType: TextInputType.number,
                    validator: _validateAnnee,
                  ),
                  DropdownButtonFormField<String>(
                    value: _carburant,
                    decoration: const InputDecoration(labelText: 'Carburant'),
                    items: const [
                      DropdownMenuItem(value: 'Essence', child: Text('Essence')),
                      DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
                      DropdownMenuItem(value: 'Hybride', child: Text('Hybride')),
                      DropdownMenuItem(value: 'Électrique', child: Text('Électrique')),
                      DropdownMenuItem(value: 'GPL', child: Text('GPL')),
                    ],
                    onChanged: (v) => setState(() => _carburant = v),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Créer'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
