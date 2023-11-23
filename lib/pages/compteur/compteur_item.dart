// ignore_for_file: file_names

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:furious_app/pages/compteur/alerts/delete_compteur_alertdialog.dart';
import 'package:furious_app/pages/compteur/alerts/detail_compteur_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_list_item_text.dart';
import 'package:intl/intl.dart';

import '../../composant/Compteur.dart';

class CompteurItem extends StatefulWidget {
  const CompteurItem({
    Key? key,
    required this.compteur,
    required this.deleteCompteur,
    required this.updateCompteur,
    required this.colorMap,
  }) : super(key: key);

  final Function deleteCompteur;
  final Function updateCompteur;
  final Compteur compteur;
  final HashMap<String, Color> colorMap;

  @override
  State<CompteurItem> createState() => _CompteurItemState();
}

class _CompteurItemState extends State<CompteurItem> {
  @override
  Widget build(BuildContext context) {
    int editKilometrage = widget.compteur.kilometrage;
    double editMoyConsommation = widget.compteur.moyConsommation;
    int editKilometrageParcouru = widget.compteur.kilometrageParcouru;
    TextEditingController dateController = TextEditingController();
    dateController.text = DateFormat('dd/MM/yyyy').format(widget.compteur.date);
    DateTime selectedDate = widget.compteur.date;

    return GestureDetector(
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.colorMap['cardColor'],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomListItemText(
                    color: widget.colorMap['text']!,
                    text: '${widget.compteur.kilometrage} Km',
                    isBig: true,
                    isBold: true,
                  ),
                  CustomListItemText(
                    color: widget.colorMap['text']!,
                    text: '${widget.compteur.kilometrageParcouru} Km parcouru',
                  ),
                  CustomListItemText(
                    color: widget.colorMap['text']!,
                    text: '${widget.compteur.moyConsommation} L/100Km',
                  ),
                ],
              ),
              IconButton(
                onPressed: () => {
                  showDialog(
                    context: context,
                    builder: (ctx) => DeleteCompteurAlertDialog(
                      colorMap: widget.colorMap,
                      compteur: widget.compteur,
                      deleteCompteur: widget.deleteCompteur,
                      ctx: ctx,
                    )
                  ),
                },
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
                iconSize: MediaQuery.of(context).size.width * 0.08,
              ),
            ],
          ),
        ),
      ),
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
    );
  }
}
