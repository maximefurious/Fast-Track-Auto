import 'package:flutter/material.dart';

class EntretienPage extends StatefulWidget {
  final Widget entListWidget;
  final Function startAddNewEntretien;
  final bool isDark;
  final Color backgroundColor;

  const EntretienPage(this.entListWidget, this.startAddNewEntretien,
      this.isDark, this.backgroundColor,
      {Key? key})
      : super(key: key);

  @override
  State<EntretienPage> createState() => _EntretienPageState();
}

class _EntretienPageState extends State<EntretienPage> {
  final globalCtrl = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isDark ? Colors.grey[800] : Colors.white,
      child: Column(
        children: [
          Expanded(
            child: widget.entListWidget,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => widget.startAddNewEntretien(context),
                child: const Text('Ajouter un entretien'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
