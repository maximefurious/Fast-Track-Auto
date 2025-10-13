import 'package:flutter/material.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/methods/mobile.dart';

import '../services/impl/pdf_report_service.dart';
import '../services/service_manager.dart';

class AccountPage extends StatefulWidget {
  final Function setImmatriculation; // attend (String)
  final Function updateData;

  final List<Entretien> _entretienList;
  final List<Compteur> _compteurList;

  final Map<String, dynamic> vehiculeMap;

  const AccountPage(
      this.setImmatriculation,
      this.updateData,
      this.vehiculeMap,
      this._entretienList,
      this._compteurList, {
        super.key,
      });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  String newImmatriculation = '';

  void   _submitImmatriculation(String value) {
    widget.setImmatriculation(value);
    widget.updateData();
    Navigator.of(context).pop();
  }

  TextStyle _tileTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onSurface,
      fontSize: 16,
    );
  }

  ListTile _buildImmatriculationListTile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final immat = (widget.vehiculeMap['immatriculation'] ?? 'Inconnue').toString();

    return ListTile(
      title: Text('Immatriculation', style: _tileTextStyle(context)),
      tileColor: cs.surface,
      trailing: Text(immat, style: _tileTextStyle(context)),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Immatriculation', style: _tileTextStyle(ctx)),
              backgroundColor: cs.surface,
              content: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: immat,
                  style: _tileTextStyle(ctx),
                  decoration: InputDecoration(
                    hintText: 'Immatriculation',
                    hintStyle: _tileTextStyle(ctx).copyWith(
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: cs.outline),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: cs.primary),
                    ),
                  ),
                  onChanged: (value) => newImmatriculation = value,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: cs.onSurface),
                  child: Text('Annuler', style: _tileTextStyle(ctx)),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: cs.primary),
                  child: Text('Valider', style: _tileTextStyle(ctx)),
                  onPressed: () => _submitImmatriculation(newImmatriculation),
                ),
              ],
            );
          },
        );
      },
    );
  }

  ListTile _buildGeneratePDFButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      title: Text('Générer PDF', style: _tileTextStyle(context)),
      tileColor: cs.surface,
      trailing: Icon(Icons.picture_as_pdf, color: cs.primary),
      onTap: () async {
        final pdfSvc = ServiceManager.instance.get<PdfReportService>();
        final bytes = await pdfSvc.buildVehicleReport(
          vehicule: widget.vehiculeMap,
          compteurs: widget._compteurList,
          entretiens: widget._entretienList,
        );
        saveAndLaunchFile(bytes, 'Output.pdf');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Paramètres',
              style: theme.textTheme.titleLarge?.copyWith(color: cs.onSurface),
            ),
          ),
          Card(
            color: cs.surface,
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildImmatriculationListTile(context),
                Divider(height: 1, color: cs.outlineVariant),
                _buildGeneratePDFButton(context),
                // Divider(height: 1, color: cs.outlineVariant),
                // _buildBluetoothConnexion(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
