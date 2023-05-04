import 'package:flutter/material.dart';

class CompteurPage extends StatefulWidget {
  final Widget compteurListWidget;
  final Function startAddNewCompteur;
  final bool isDark;
  final Color backgroundColor;

  const CompteurPage(this.compteurListWidget, this.startAddNewCompteur,
      this.isDark, this.backgroundColor,
      {Key? key})
      : super(key: key);

  @override
  State<CompteurPage> createState() => _CompteurPageState();
}

class _CompteurPageState extends State<CompteurPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: widget.isDark ? Colors.grey[800] : Colors.white,
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
