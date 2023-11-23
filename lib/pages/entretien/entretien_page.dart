import 'dart:collection';

import 'package:flutter/material.dart';

class EntretienPage extends StatefulWidget {
  final Widget entListWidget;
  final Function startAddNewEntretien;
  final HashMap<String, Color> colorMap;

  const EntretienPage(
      this.entListWidget, this.startAddNewEntretien, this.colorMap,
      {Key? key})
      : super(key: key);

  @override
  State<EntretienPage> createState() => _EntretienPageState();
}

class _EntretienPageState extends State<EntretienPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.colorMap['backgroundCard'],
      child: Column(
        children: [
          Expanded(
            child: widget.entListWidget,
          ),
          ButtonBar(
            children: [
              FloatingActionButton(
                onPressed: () => widget.startAddNewEntretien(context),
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
