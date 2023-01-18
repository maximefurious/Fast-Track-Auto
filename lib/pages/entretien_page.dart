import 'package:flutter/material.dart';

class EntretienPage extends StatefulWidget {
  final Widget entListWidget;
  final Function startAddNewEntretien;
  final int isDark;

  EntretienPage(this.entListWidget, this.startAddNewEntretien, this.isDark);

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
    return Container(
      color: widget.isDark == 1 ? Colors.grey[800] : Colors.white,
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
