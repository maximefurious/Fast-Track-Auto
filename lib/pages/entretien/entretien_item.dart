import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien/alerts/delete_entretien_alertdialog.dart';
import 'package:furious_app/pages/entretien/alerts/detail_entretien_alertdialog.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';
import 'package:intl/intl.dart';

import '../../composant/Entretien.dart';

class EntretienItem extends StatefulWidget {
  const EntretienItem({
    Key? key,
    required this.entretien,
    required this.deleteEnt,
    required this.updateEntretien,
    required this.colorMap,
  }) : super(key: key);

  final Function deleteEnt;
  final Function updateEntretien;
  final Entretien entretien;
  final HashMap<String, Color> colorMap;

  @override
  State<EntretienItem> createState() => _EntretienItemState();
}

class _EntretienItemState extends State<EntretienItem> {
  @override
  Widget build(BuildContext context) {
    String formatedDate(DateTime date) {
      return DateFormat('dd/MM/yyyy').format(date);
    }

    int editKilometrage = widget.entretien.kilometrage;
    double editPrix = widget.entretien.prix;
    String editType = widget.entretien.type;
    TextEditingController dateController = TextEditingController();
    dateController.text = formatedDate(widget.entretien.date);
    DateTime selectedDate = widget.entretien.date;

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
                  Row(
                    children: [
                      CustomCarnetText(
                        color: widget.colorMap['text']!,
                        text:
                            '${widget.entretien.type[0].toUpperCase()}${widget.entretien.type.substring(1).trim()} : ',
                        isBold: true,
                      ),
                      Container(
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7.0),
                            topRight: Radius.circular(7.0),
                            bottomLeft: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.entretien.prix}€',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        formatedDate(selectedDate),
                        style: TextStyle(
                          color: widget.colorMap['text'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${widget.entretien.kilometrage} km',
                        style: TextStyle(
                          color: widget.colorMap['text'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  // display a dialog to confirm deletion
                  showDialog(
                    context: context,
                    builder: (ctx) => DeleteEntretienAlertDialog(
                      ctx: ctx,
                      colorMap: widget.colorMap,
                      entretien: widget.entretien,
                      deleteEntretien: widget.deleteEnt,
                    ),
                  );
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
        // dialog that display the details of the entretien with 2 buttons 1 that close the dialog and the other that close the current dialog and reopen and other for editing every field
        showDialog(
          context: context,
          builder: (ctx) => DetailEntretienAlertDialog(
              colorMap: widget.colorMap,
              entretien: widget.entretien,
              selectedDate: selectedDate,
              context: context,
              editKilometrage: editKilometrage,
              editPrix: editPrix,
              editType: editType,
              updateEntretien: widget.updateEntretien,
              dateController: dateController),
        );
      },
    );
  }
}
