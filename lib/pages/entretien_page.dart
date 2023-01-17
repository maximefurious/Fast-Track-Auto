import 'package:flutter/material.dart';

class EntretienPage extends StatefulWidget {
  final Widget entListWidget;
  final Function startAddNewEntretien;

  EntretienPage(this.entListWidget, this.startAddNewEntretien);

  @override
  State<EntretienPage> createState() => _EntretienPageState();
}

class _EntretienPageState extends State<EntretienPage> {
  final globalCtrl = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  void _submitSearch() {
    print(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
