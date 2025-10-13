import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:furious_app/models/entretien.dart';

class NewEntretienPage extends StatefulWidget {
  const NewEntretienPage({super.key});

  @override
  State<NewEntretienPage> createState() => _NewEntretienPageState();
}

class _NewEntretienPageState extends State<NewEntretienPage> {
  final _formKey = GlobalKey<FormState>();
  final _type = TextEditingController();
  final _km = TextEditingController();
  final _prix = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _type.dispose();
    _km.dispose();
    _prix.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final e = Entretien(
      id: const Uuid().v4(),
      type: _type.text.trim(),
      kilometrage: int.parse(_km.text.trim()),
      prix: double.parse(_prix.text.trim().replaceAll(',', '.')),
      date: _date,
    );
    Navigator.of(context).pop(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvel entretien')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            TextFormField(
              controller: _km,
              decoration: const InputDecoration(labelText: 'Kilométrage'),
              keyboardType: TextInputType.number,
              validator: (v) => int.tryParse(v ?? '') == null ? 'Nombre invalide' : null,
            ),
            TextFormField(
              controller: _prix,
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
              validator: (v) => double.tryParse((v ?? '').replaceAll(',', '.')) == null ? 'Nombre invalide' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Date: ${_date.day.toString().padLeft(2,'0')}/${_date.month.toString().padLeft(2,'0')}/${_date.year}'),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2019),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: const Text('Choisir'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}
