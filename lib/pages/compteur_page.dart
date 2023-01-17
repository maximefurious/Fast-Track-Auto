import 'package:flutter/material.dart';
import 'package:furious_app/widget/line_chart_widget.dart';

class CompteurPage extends StatefulWidget {
  final Widget compteurListWidget;
  final Function startAddNewCompteur;

  CompteurPage(this.compteurListWidget, this.startAddNewCompteur);

  @override
  State<CompteurPage> createState() => _CompteurPageState();
}

class _CompteurPageState extends State<CompteurPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Expanded(
          child: widget.compteurListWidget,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => widget.startAddNewCompteur(context),
              child: const Text('Ajouter Kilomètrage'),
            ),
          ],
        ),
      ]),
    );
  }
}
