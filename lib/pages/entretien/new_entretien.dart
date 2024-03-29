// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';

import 'package:flutter/material.dart';

import '../../widget/adaptative_flat_button.dart';

class NewEntretien extends StatefulWidget {
  final Function addEntretien;
  final HashMap<String, Color> colorMap;

  const NewEntretien(this.addEntretien, this.colorMap, {Key? key})
      : super(key: key);

  @override
  _NewEntretienState createState() => _NewEntretienState();
}

class _NewEntretienState extends State<NewEntretien> {
  final globalCtrl = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _prixController = TextEditingController();
  final _kilometrageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewEntretien oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submitData() {
    if (_typeController.text.isEmpty ||
        _prixController.text.isEmpty ||
        _kilometrageController.text.isEmpty) {
      return;
    }
    final enteredType = _typeController.text;
    final enteredPrix = double.parse(_prixController.text);
    final enteredKilometrage = int.parse(_kilometrageController.text);

    if (enteredType.isEmpty || enteredPrix <= 0 || enteredKilometrage <= 0) {
      return;
    }

    widget.addEntretien(
      enteredKilometrage,
      enteredType,
      enteredPrix,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: widget.colorMap['primaryColor']!,
            dialogBackgroundColor: widget.colorMap['cardColor']!,
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: widget.colorMap['primaryColor']!,
            ),
            colorScheme: ColorScheme.dark(
              primary: widget.colorMap['primaryColor']!,
              onPrimary: widget.colorMap['textFieldColor']!,
              surface: widget.colorMap['background']!,
              onSurface: widget.colorMap['text']!,
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: globalCtrl,
        child: Container(
          decoration: BoxDecoration(
            color: widget.colorMap['cardColor'],
          ),
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Type',
                  labelStyle: TextStyle(
                    color: widget.colorMap['text'],
                  ),
                ),
                controller: _typeController,
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.colorMap['text'],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Prix',
                  labelStyle: TextStyle(
                    color: widget.colorMap['text'],
                  ),
                ),
                controller: _prixController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.colorMap['text'],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Kilometrage',
                  labelStyle: TextStyle(
                    color: widget.colorMap['text'],
                  ),
                ),
                controller: _kilometrageController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.colorMap['text'],
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(
                          color: widget.colorMap['text'],
                        ),
                      ),
                    ),
                    AdaptiveFlatButton(
                        'Choisir Date', _presentDatePicker, widget.colorMap),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: widget.colorMap['textFieldColor'],
                  backgroundColor: widget.colorMap['primaryColor'],
                ),
                child: const Text('Ajouter Entretien'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
