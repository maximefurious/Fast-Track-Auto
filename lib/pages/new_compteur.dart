// lib/pages/compteur/new_compteur_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furious_app/models/compteur.dart';

class NewCompteurPage extends StatefulWidget {
  const NewCompteurPage({super.key});

  @override
  State<NewCompteurPage> createState() => _NewCompteurPageState();
}

class _NewCompteurPageState extends State<NewCompteurPage> {
  final _formKey = GlobalKey<FormState>();

  final _kilometrageCtrl = TextEditingController();
  final _parcouruCtrl = TextEditingController();
  final _consoCtrl = TextEditingController();

  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _kilometrageCtrl.dispose();
    _parcouruCtrl.dispose();
    _consoCtrl.dispose();
    super.dispose();
  }

  // Simple générateur, pour éviter de dépendre de uuid
  String _genId() {
    final ms = DateTime.now().microsecondsSinceEpoch;
    final r = Random().nextInt(1 << 32);
    return '$ms-$r';
  }

  int? _toInt(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return int.tryParse(v.trim());
  }

  double? _toDoubleFr(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return double.tryParse(v.trim().replaceAll(',', '.'));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    final kilometrage = _toInt(_kilometrageCtrl.text)!;
    final parcouru = _toInt(_parcouruCtrl.text) ?? 0;
    final conso = _toDoubleFr(_consoCtrl.text) ?? 0.0;

    final c = Compteur(
      id: _genId(),
      kilometrage: kilometrage,
      date: _date,
      kilometrageParcouru: parcouru,
      moyConsommation: conso,
    );

    Navigator.of(context).pop(c);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau compteur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Enregistrer',
            onPressed: _save,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Kilométrage total
              TextFormField(
                controller: _kilometrageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kilométrage (km)',
                  prefixIcon: Icon(Icons.speed),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  final x = _toInt(v);
                  if (x == null) return 'Saisir un entier';
                  if (x < 0) return 'Doit être positif';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Kilométrage parcouru (optionnel)
              TextFormField(
                controller: _parcouruCtrl,
                decoration: const InputDecoration(
                  labelText: 'Kilométrage parcouru (km)',
                  helperText: 'Depuis le dernier plein/entretien (optionnel)',
                  prefixIcon: Icon(Icons.route),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final x = _toInt(v);
                  if (x == null) return 'Entier invalide';
                  if (x < 0) return 'Doit être positif';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Conso moyenne (optionnel)
              TextFormField(
                controller: _consoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Conso moyenne (L/100km)',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final d = _toDoubleFr(v);
                  if (d == null) return 'Nombre invalide (ex: 6,2)';
                  if (d < 0) return 'Doit être positif';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date
              Row(
                children: [
                  const Icon(Icons.event),
                  const SizedBox(width: 12),
                  Text(
                    '${_date.day.toString().padLeft(2, '0')}/'
                        '${_date.month.toString().padLeft(2, '0')}/'
                        '${_date.year}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text('Choisir la date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bouton principal
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Enregistrer'),
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
