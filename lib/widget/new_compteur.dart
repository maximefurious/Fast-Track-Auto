import 'package:flutter/material.dart';

import '../widget/adaptative_flat_button.dart';

class NewCompteur extends StatefulWidget {
  final Function addCompteur;
  final int isDark;

  NewCompteur(this.addCompteur, this.isDark);

  @override
  _NewCompteurState createState() => _NewCompteurState();
}

class _NewCompteurState extends State<NewCompteur> {
  final globalCtrl = GlobalKey<FormState>();
  final _kilometrageController = TextEditingController();
  final _kilometrageParcouruController = TextEditingController();
  final _moyConsommationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _NewCompteurState() {
    print('Constructor NewCompteur State');
  }

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
        _moyConsommationController.text.isEmpty ||
        _selectedDate == null) {
      return;
    }
    final enteredKilometrage = int.parse(_kilometrageController.text);
    final enteredKilometrageParcouru =
        int.parse(_kilometrageParcouruController.text);
    final enteredMoyConsommation =
        double.parse(_moyConsommationController.text);

    if (enteredKilometrage <= 0 ||
        enteredKilometrageParcouru <= 0 ||
        enteredMoyConsommation <= 0 ||
        _selectedDate == null) {
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
            color: widget.isDark == 1 ? Colors.grey[800] : Colors.white,
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
                    color: widget.isDark == 1 ? Colors.white : Colors.black,
                  ),
                ),
                controller: _kilometrageController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.isDark == 1 ? Colors.white : Colors.black,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Kilometrage Parcouru',
                  labelStyle: TextStyle(
                    color: widget.isDark == 1 ? Colors.white : Colors.black,
                  ),
                ),
                controller: _kilometrageParcouruController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.isDark == 1 ? Colors.white : Colors.black,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Moyenne Consommation',
                  labelStyle: TextStyle(
                    color: widget.isDark == 1 ? Colors.white : Colors.black,
                  ),
                ),
                controller: _moyConsommationController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
                autofocus: true,
                style: TextStyle(
                  color: widget.isDark == 1 ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Pas de date choisie !'
                            : 'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(
                          color:
                              widget.isDark == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    AdaptiveFlatButton('Choisir Date', _presentDatePicker),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: Text(
                  'Ajouter Kilomètrage',
                  style: TextStyle(
                      color: widget.isDark == 1 ? Colors.black : Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).textTheme.labelLarge!.color,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
