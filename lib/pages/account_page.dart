import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:furious_app/composant/Compteur.dart';
import 'package:furious_app/composant/Entretien.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:furious_app/methods/mobile.dart';

class AccountPage extends StatefulWidget {
  final Function setIsDark;
  final Function setImmatriculation;
  final Function updateData;

  final bool isDark;

  final List<Entretien> _entretienList;
  final List<Compteur> _compteurList;
  
  final HashMap<String, Color> colorMap;
  final Map<String, dynamic> vehiculeMap;


  const AccountPage(
      this.setIsDark,
      this.setImmatriculation,
      this.updateData,
      this.isDark,
      this.colorMap,
      this.vehiculeMap,
      this._entretienList,
      this._compteurList,
      {Key? key})
      : super(key: key);
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  String newImmatriculation = '';

  void _submitImmatriculation(value) {
    widget.setImmatriculation(value);
    widget.updateData();
    Navigator.of(context).pop();
  }

  TextStyle _buildTextStyle() {
    return TextStyle(fontSize: 16, color: widget.colorMap['text']);
  }

  ListTile _buildDarkModeSwitch() {
    return ListTile(
      title: Text('Theme sombre', style: _buildTextStyle()),
      tileColor: widget.colorMap['cardColor'],
      trailing: Switch(
        value: widget.isDark,
        thumbIcon: MaterialStateProperty.all(
          widget.isDark
              ? const Icon(Icons.brightness_2, color: Colors.yellow)
              : const Icon(Icons.sunny, color: Colors.black),
        ),
        activeTrackColor: Colors.blue[100],
        onChanged: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isDark', value);
          widget.setIsDark(value);
        },
      ),
    );
  }

  ListTile _buildImmatriculationListTile() {
    return ListTile(
      title: Text('Immatriculation', style: _buildTextStyle()),
      tileColor: widget.colorMap['cardColor'],
      trailing: Text(widget.vehiculeMap['immatriculation']!, style: _buildTextStyle()),
      onTap: () => {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Immatriculation', style: _buildTextStyle()),
              backgroundColor: widget.colorMap['cardColor'],
              content: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: widget.vehiculeMap['immatriculation']!,
                  style: _buildTextStyle(),
                  decoration: InputDecoration(
                    hintText: 'Immatriculation',
                    hintStyle: _buildTextStyle(),
                  ),
                  onChanged: (value) => newImmatriculation = value,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style:
                      TextButton.styleFrom(foregroundColor: widget.colorMap['text']),
                  child: Text('Annuler', style: _buildTextStyle()),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  style:
                      TextButton.styleFrom(foregroundColor: widget.colorMap['text']),
                  child: Text('Valider', style: _buildTextStyle()),
                  onPressed: () => _submitImmatriculation(newImmatriculation),
                ),
              ],
            );
          },
        ),
      },
    );
  }

  ListTile _buildGeneratePDFButton() {
    return ListTile(
      title: Text('Générer PDF', style: _buildTextStyle()),
      tileColor: widget.colorMap['cardColor'],
      onTap: () => {
        _generatePDF(),
      },
    );
  }

  // ListTile _buildBluetoothConnexion() {
  //   return ListTile(
  //     title: Text('Connexion bluetooth', style: _buildTextStyle()),
  //     tileColor: widget.colorMap['cardColor'],
  //     onTap: () => {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => DiscoveryPage(),
  //         ),
  //       ),
  //     },
  //   );
  // }

  Future<void> _generatePDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawString(
      'Fiche technique',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 50),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    page.graphics.drawString(
      'Véhicule : ${widget.vehiculeMap['title']}',
      PdfStandardFont(PdfFontFamily.helvetica, 20),
      bounds: Rect.fromLTWH(0, 50, page.getClientSize().width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    page.graphics.drawString(
      'Immatriculation : ${widget.vehiculeMap['immatriculation']}',
      PdfStandardFont(PdfFontFamily.helvetica, 20),
      bounds: Rect.fromLTWH(0, 80, page.getClientSize().width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    page.graphics.drawString(
      'Cylindre : ${widget.vehiculeMap['cylindrer']}',
      PdfStandardFont(PdfFontFamily.helvetica, 20),
      bounds: Rect.fromLTWH(0, 110, page.getClientSize().width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    page.graphics.drawString(
      'Date de mise en circulation : ${widget.vehiculeMap['dateMiseEnCirculation']}',
      PdfStandardFont(PdfFontFamily.helvetica, 20),
      bounds: Rect.fromLTWH(0, 140, page.getClientSize().width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    page.graphics.drawString(
      'Carburant : ${widget.vehiculeMap['carburant']}',
      PdfStandardFont(PdfFontFamily.helvetica, 20),
      bounds: Rect.fromLTWH(0, 170, page.getClientSize().width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.left),
    );

    page.graphics.drawString(
      'Historique Kilomètrage',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      bounds: Rect.fromLTWH(0, 200, page.getClientSize().width, 50),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    PdfGrid grid = PdfGrid();
    grid.style.cellPadding = PdfPaddings(left: 5, right: 5);
    grid.style.font = PdfStandardFont(PdfFontFamily.helvetica, 20);

    int totalCellSize = 50;

    grid.columns.add(count: 4);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Kilométrage';
    header.cells[1].value = 'Kilometre parcouru';
    header.cells[2].value = 'Litres/100km';
    header.cells[3].value = 'Date';

    PdfGridRow row = grid.rows.add();
    // foreach Compteur in compteurList
    for (int i = 0; i < widget._compteurList.length; i++) {
      row.cells[0].value = "${widget._compteurList[i].kilometrage} km";
      row.cells[1].value = "${widget._compteurList[i].kilometrageParcouru} km";
      row.cells[2].value = "${widget._compteurList[i].moyConsommation} L/100km";
      row.cells[3].value =
          "${widget._compteurList[i].date.day}/${widget._compteurList[i].date.month}/${widget._compteurList[i].date.year}";
      totalCellSize += 50;
      if (i < widget._compteurList.length - 1) {
        row = grid.rows.add();
      }
    }

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 250, page.getClientSize().width, 0),
    );

    page.graphics.drawString(
      'Historique Des Entretiens',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      bounds: Rect.fromLTWH(
          0, 250 + totalCellSize.toDouble(), page.getClientSize().width, 50),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    // generate another grid
    PdfGrid grid2 = PdfGrid();
    grid2.style.cellPadding = PdfPaddings(left: 5, right: 5);
    grid2.style.font = PdfStandardFont(PdfFontFamily.helvetica, 20);

    grid2.columns.add(count: 4);
    grid2.headers.add(1);

    PdfGridRow header2 = grid2.headers[0];
    header2.cells[0].value = 'Type';
    header2.cells[1].value = 'Kilometrage';
    header2.cells[2].value = 'Prix';
    header2.cells[3].value = 'Date';

    PdfGridRow row2 = grid2.rows.add();
    // foreach Compteur in compteurList
    for (int i = 0; i < widget._entretienList.length; i++) {
      row2.cells[0].value = widget._entretienList[i].type;
      row2.cells[1].value = "${widget._entretienList[i].kilometrage} km";
      row2.cells[2].value = "${widget._entretienList[i].prix} €";
      row2.cells[3].value =
          "${widget._entretienList[i].date.day}/${widget._entretienList[i].date.month}/${widget._entretienList[i].date.year}";
      if (i < widget._entretienList.length - 1) {
        row2 = grid2.rows.add();
      }
    }

    grid2.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 300 + totalCellSize.toDouble(), page.getClientSize().width, 0),
    );

    final List<int> bytes = document.saveSync();
    document.dispose();

    saveAndLaunchFile(bytes, 'Output.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Paramètres',
                style: TextStyle(fontSize: 20, color: widget.colorMap['text'])),
          ),
          Card(
            child: Column(
              children: <Widget>[
                _buildDarkModeSwitch(),
                Divider(height: 1, color: widget.colorMap['text']),
                _buildImmatriculationListTile(),
                Divider(height: 1, color: widget.colorMap['text']),
                _buildGeneratePDFButton(),
                // Divider(height: 1, color: widget.colorMap['text']),
                // _buildBluetoothConnexion(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
