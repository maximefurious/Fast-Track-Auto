import 'dart:collection';

import 'package:flutter/material.dart';

class CompteurPage extends StatefulWidget {
  final Widget compteurListWidget;
  final Function startAddNewCompteur;

  final HashMap<String, Color> colorMap;

  const CompteurPage(
      this.compteurListWidget, this.startAddNewCompteur, this.colorMap,
      {Key? key})
      : super(key: key);

  @override
  State<CompteurPage> createState() => _CompteurPageState();
}

class _CompteurPageState extends State<CompteurPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.colorMap['backgroundCard'],
      child: Column(
        children: [
          Expanded(
            child: widget.compteurListWidget,
          ),
          ButtonBar(
            children: [
              FloatingActionButton(
                onPressed: () => widget.startAddNewCompteur(context),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
