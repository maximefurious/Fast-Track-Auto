import 'package:flutter/material.dart';

import '../widget/adaptative_flat_button.dart';

class NewEntretien extends StatefulWidget {
  final Function addEntretien;

  NewEntretien(this.addEntretien);

  @override
  _NewEntretienState createState() => _NewEntretienState();
}

class _NewEntretienState extends State<NewEntretien> {
  final globalCtrl = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _prixController = TextEditingController();
  final _kilometrageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _NewEntretienState() {
    print('Constructor NewEntretien State');
  }

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
        _kilometrageController.text.isEmpty ||
        _selectedDate == null) {
      return;
    }
    final enteredType = _typeController.text;
    final enteredPrix = double.parse(_prixController.text);
    final enteredKilometrage = int.parse(_kilometrageController.text);

    if (enteredType.isEmpty ||
        enteredPrix <= 0 ||
        enteredKilometrage <= 0 ||
        _selectedDate == null) {
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
        child: Card(
          elevation: 5,
          child: Container(
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
                  decoration: const InputDecoration(labelText: 'Type'),
                  controller: _typeController,
                  onSubmitted: (_) => _submitData(),
                  autofocus: true,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Prix'),
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                  autofocus: true,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Kilometrage'),
                  controller: _kilometrageController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                  autofocus: true,                  
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen!'
                              : 'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                      ),
                      AdaptiveFlatButton('Choisir Date', _presentDatePicker),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Ajouter Entretien'),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    onPrimary: Theme.of(context).textTheme.button!.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
