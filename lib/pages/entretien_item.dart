import 'package:flutter/material.dart';

import '../composant/Entretien.dart';

class EntretienItem extends StatefulWidget {
  const EntretienItem({
    Key? key,
    @required this.entretien,
    @required this.deleteEnt,
  }) : super(key: key);

  final Entretien? entretien;
  final Function? deleteEnt;

  @override
  State<EntretienItem> createState() => _EntretienItemState();
}

class _EntretienItemState extends State<EntretienItem> {
  String get _formatedDate {
    final dayLessThan10 = widget.entretien!.date.day < 10 ? '0' : '';
    final monthLessThan10 = widget.entretien!.date.month < 10 ? '0' : '';
    return dayLessThan10 +
        widget.entretien!.date.day.toString() +
        '/' +
        monthLessThan10 +
        widget.entretien!.date.month.toString() +
        '/' +
        widget.entretien!.date.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.entretien!.type + ' :',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      widget.entretien!.prix.toString() + '€',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(_formatedDate),
                  ],
                ),
                Row(
                  children: [
                    Text(widget.entretien!.kilometrage.toString() + ' km'),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                // display a dialog to confirm deletion
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Etes vous sur ?'),
                    content: const Text(
                        'Voulez-vous vraiment supprimer cette entretien de la liste ?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: const Text('Non'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: const Text('Oui'),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value) {
                    widget.deleteEnt!(widget.entretien!.id);
                  }
                });
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              iconSize: MediaQuery.of(context).size.width * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
