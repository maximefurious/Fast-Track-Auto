// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:furious_app/widget/custom_text/custom_carnet_text.dart';

import '../../widget/adaptative_flat_button.dart';

class NewCompteur extends StatefulWidget {
  final Function addCompteur;
  final HashMap<String, Color> colorMap;

  const NewCompteur(this.addCompteur, this.colorMap, {Key? key})
      : super(key: key);

  @override
  _NewCompteurState createState() => _NewCompteurState();
}

class _NewCompteurState extends State<NewCompteur> {
  final globalCtrl = GlobalKey<FormState>();
  final _kilometrageController = TextEditingController();
  final _kilometrageParcouruController = TextEditingController();
  final _moyConsommationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewCompteur oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submitData() {
    if (_kilometrageController.text.isEmpty ||
        _kilometrageParcouruController.text.isEmpty ||
        _moyConsommationController.text.isEmpty) {
      return;
    }
    final enteredKilometrage = int.parse(_kilometrageController.text);
    final enteredKilometrageParcouru =
        int.parse(_kilometrageParcouruController.text);
    final enteredMoyConsommation =
        double.parse(_moyConsommationController.text);

    if (enteredKilometrage <= 0 ||
        enteredKilometrageParcouru <= 0 ||
        enteredMoyConsommation <= 0) {
      return;
    }

    widget.addCompteur(
      enteredKilometrage,
      _selectedDate,
      enteredKilometrageParcouru,
      enteredMoyConsommation,
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
                  labelText: 'Kilometrage',
                  labelStyle: TextStyle(
                    color: widget.colorMap['text'],
                  ),
                  fillColor: widget.colorMap['primaryColor']!,
                ),
                controller: _kilometrageController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.colorMap['text'],
                ),
                cursorColor: widget.colorMap['primaryColor']!,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Kilometrage Parcouru',
                  labelStyle: TextStyle(
                    color: widget.colorMap['text'],
                  ),
                  focusColor: widget.colorMap['primaryColor']!,
                ),
                controller: _kilometrageParcouruController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.colorMap['text'],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Moyenne Consommation',
                  labelStyle: TextStyle(
                    color: widget.colorMap['text'],
                  ),
                  focusColor: widget.colorMap['primaryColor']!,
                ),
                controller: _moyConsommationController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                      child: CustomCarnetText(
                        color: widget.colorMap['text']!.withOpacity(0.8),
                        text: 'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                    AdaptiveFlatButton(
                      'Choisir Date',
                      _presentDatePicker,
                      widget.colorMap,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: widget.colorMap['textFieldColor'],
                  backgroundColor: widget.colorMap['primaryColor'],
                ),
                child: const Text('Ajouter Kilomètrage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
