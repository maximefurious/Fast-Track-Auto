import 'package:flutter/material.dart';

import '../../composant/Entretien.dart';

class EntretienItem extends StatefulWidget {
  const EntretienItem({
    Key? key,
    required this.entretien,
    required this.deleteEnt,
    required this.isDark,
  }) : super(key: key);

  final Function deleteEnt;
  final Entretien entretien;
  final bool isDark;

  @override
  State<EntretienItem> createState() => _EntretienItemState();
}

class _EntretienItemState extends State<EntretienItem> {
  String get _formatedDate {
    final dayLessThan10 = widget.entretien.date.day < 10 ? '0' : '';
    final monthLessThan10 = widget.entretien.date.month < 10 ? '0' : '';
    return '$dayLessThan10${widget.entretien.date.day}/$monthLessThan10${widget.entretien.date.month}/${widget.entretien.date.year}';
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.isDark ? Colors.grey[900] : Colors.white,
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
                    Text(
                      '${widget.entretien.type} : ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      '${widget.entretien.prix}€',
                      style: TextStyle(
                        fontSize: 18,
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      _formatedDate,
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.entretien.kilometrage} km',
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
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
                  builder: (ctx) => AlertDialog(
                    backgroundColor:
                        widget.isDark ? Colors.grey[800] : Colors.white,
                    title: Text(
                      'Etes vous sur ?',
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    content: Text(
                      'Voulez-vous vraiment supprimer cette entretien de la liste ?',
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: const Text(
                          'Non',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: const Text(
                          'Oui',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value) {
                    widget.deleteEnt(widget.entretien.id);
                  }
                });
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              iconSize: MediaQuery.of(context).size.width * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
