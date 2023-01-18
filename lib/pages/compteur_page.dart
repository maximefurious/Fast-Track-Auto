import 'package:flutter/material.dart';
import 'package:furious_app/widget/line_chart_widget.dart';

class CompteurPage extends StatefulWidget {
  final Widget compteurListWidget;
  final Function startAddNewCompteur;
  final int isDark;

  CompteurPage(this.compteurListWidget, this.startAddNewCompteur, this.isDark);

  @override
  State<CompteurPage> createState() => _CompteurPageState();
}

class _CompteurPageState extends State<CompteurPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: widget.isDark == 1 ? Colors.grey[800] : Colors.white,
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
      ),
    );
  }
}
