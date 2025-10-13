import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien/alerts/delete_entretien_alertdialog.dart';
import 'package:furious_app/pages/entretien/alerts/detail_entretien_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';
import 'package:intl/intl.dart';

import '../../models/entretien.dart';

class EntretienItem extends StatefulWidget {
  const EntretienItem({
    super.key,
    required this.entretien,
    required this.deleteEnt,
    required this.updateEntretien,
  });

  final Entretien entretien;
  final void Function(String id) deleteEnt;
  final void Function(Entretien e) updateEntretien;

  @override
  State<EntretienItem> createState() => _EntretienItemState();
}

class _EntretienItemState extends State<EntretienItem> {
  // Optionnel: garder ces valeurs en local pour l'édition
  late int editKilometrage;
  late double editPrix;
  late String editType;
  late DateTime selectedDate;
  late final TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    editKilometrage = widget.entretien.kilometrage;
    editPrix = widget.entretien.prix;
    editType = widget.entretien.type;
    selectedDate = widget.entretien.date;
    dateController = TextEditingController(text: _formatDate(widget.entretien.date));
  }

  @override
  void didUpdateWidget(covariant EntretienItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entretien != widget.entretien) {
      editKilometrage = widget.entretien.kilometrage;
      editPrix = widget.entretien.prix;
      editType = widget.entretien.type;
      selectedDate = widget.entretien.date;
      dateController.text = _formatDate(widget.entretien.date);
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
          builder: (ctx) => DetailEntretienAlertDialog(
            // colorMap supprimé: le dialog doit aussi lire Theme.of(context)
            entretien: widget.entretien,
            selectedDate: selectedDate,
            editKilometrage: editKilometrage,
            editPrix: editPrix,
            editType: editType,
            updateEntretien: widget.updateEntretien,
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
            color: cs.surface, // ex- cardColor
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Infos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre + prix
                  Row(
                    children: [
                      CustomCarnetText(
                        color: text.titleMedium?.color ?? cs.onSurface,
                        text:
                        '${widget.entretien.type[0].toUpperCase()}${widget.entretien.type.substring(1).trim()} : ',
                        isBold: true,
                      ),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: cs.primary, // ex- Colors.green
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.entretien.prix}€',
                          style: text.labelLarge?.copyWith(color: cs.onPrimary) ??
                              const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatDate(selectedDate),
                        style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${widget.entretien.kilometrage} km',
                        style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
              // Delete
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => DeleteEntretienAlertDialog(
                      // colorMap supprimé: le dialog doit aussi lire Theme.of(context)
                      ctx: ctx,
                      entretien: widget.entretien,
                      deleteEntretien: widget.deleteEnt,
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
