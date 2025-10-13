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
    required this.colorMap,
  });

  final Function deleteCompteur;
  final Function updateCompteur;
  final Compteur compteur;
  final Map<String, Color> colorMap;

  @override
  State<CompteurItem> createState() => _CompteurItemState();
}

class _CompteurItemState extends State<CompteurItem> {
  late final TextEditingController dateController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.compteur.date;
    dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(widget.compteur.date),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Couleurs avec valeurs de repli pour éviter les null
    final scheme = Theme.of(context).colorScheme;
    final textColor = widget.colorMap['text'] ?? scheme.onSurface;
    final cardColor = widget.colorMap['cardColor'] ?? scheme.surface;

    // Copie locale pour l’édition
    int editKilometrage = widget.compteur.kilometrage;
    double editMoyConsommation = widget.compteur.moyConsommation;
    int editKilometrageParcouru = widget.compteur.kilometrageParcouru;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => DetailCompteurAlertDialog(
            colorMap: widget.colorMap,
            compteur: widget.compteur,
            selectedDate: selectedDate,
            context: ctx,
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cardColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Colonne textes
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomListItemText(
                    color: textColor,
                    text: '${widget.compteur.kilometrage} Km',
                    isBig: true,
                    isBold: true,
                  ),
                  CustomListItemText(
                    color: textColor,
                    text: '${widget.compteur.kilometrageParcouru} Km parcouru',
                  ),
                  CustomListItemText(
                    color: textColor,
                    text: '${widget.compteur.moyConsommation} L/100Km',
                  ),
                ],
              ),

              // Bouton supprimer
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => DeleteCompteurAlertDialog(
                      colorMap: widget.colorMap,
                      compteur: widget.compteur,
                      deleteCompteur: widget.deleteCompteur,
                      ctx: ctx,
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
                color: scheme.error,
                iconSize: MediaQuery.of(context).size.width * 0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
