// lib/pages/compteur/compteur_item.dart
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:furious_app/pages/compteur/alerts/delete_compteur_alertdialog.dart';
import 'package:furious_app/pages/compteur/alerts/detail_compteur_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_list_item_text.dart';
import 'package:intl/intl.dart';

import '../../models/compteur.dart';

class CompteurItem extends StatefulWidget {
  const CompteurItem({
    super.key,
    required this.compteur,
    required this.deleteCompteur,
    required this.updateCompteur,
  });

  final Compteur compteur;
  final void Function(String id) deleteCompteur;
  final void Function(Compteur c) updateCompteur;

  @override
  State<CompteurItem> createState() => _CompteurItemState();
}

class _CompteurItemState extends State<CompteurItem> {
  late int editKilometrage;
  late double editMoyConsommation;
  late int editKilometrageParcouru;
  late DateTime selectedDate;
  late final TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    editKilometrage = widget.compteur.kilometrage;
    editMoyConsommation = widget.compteur.moyConsommation;
    editKilometrageParcouru = widget.compteur.kilometrageParcouru;
    selectedDate = widget.compteur.date;
    dateController = TextEditingController(text: _formatDate(widget.compteur.date));
  }

  @override
  void didUpdateWidget(covariant CompteurItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.compteur != widget.compteur) {
      editKilometrage = widget.compteur.kilometrage;
      editMoyConsommation = widget.compteur.moyConsommation;
      editKilometrageParcouru = widget.compteur.kilometrageParcouru;
      selectedDate = widget.compteur.date;
      dateController.text = _formatDate(widget.compteur.date);
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => DetailCompteurAlertDialog(
            compteur: widget.compteur,
            selectedDate: selectedDate,
            editKilometrage: editKilometrage,
            editKilometrageParcouru: editKilometrageParcouru,
            editMoyConsommation: editMoyConsommation,
            updateCompteur: widget.updateCompteur,
            dateController: dateController,
          ),
        );
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: cs.surface,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cs.surface,
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomListItemText(
                    color: text.titleMedium?.color ?? cs.onSurface,
                    text: '${widget.compteur.kilometrage} Km',
                    isBig: true,
                    isBold: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(selectedDate),
                    style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.compteur.kilometrageParcouru} Km parcouru',
                    style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.compteur.moyConsommation} L/100Km',
                    style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),

              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => DeleteCompteurAlertDialog(
                      compteur: widget.compteur,
                      deleteCompteur: widget.deleteCompteur,
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
                color: cs.error,
                iconSize: MediaQuery.of(context).size.width * 0.08,
                tooltip: 'Supprimer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
