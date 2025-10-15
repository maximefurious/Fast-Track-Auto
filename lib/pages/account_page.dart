import 'package:flutter/material.dart';

import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/models/entretien.dart';
import 'package:furious_app/methods/mobile.dart';
import 'package:furious_app/services/impl/pdf_report_service.dart';
import 'package:furious_app/services/service_manager.dart';
import 'package:furious_app/services/impl/session.dart';
import 'package:furious_app/widget/auth/auth_dialog.dart';
import 'package:furious_app/widget/vehicle/create_vehicle_form.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  final Function setImmatriculation; // (String) — conservé si besoin
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
  TextStyle _tileTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    return theme.textTheme.bodyLarge!.copyWith(
      color: theme.colorScheme.onSurface,
      fontSize: 16,
    );
  }

  Future<void> _openAuthDialog() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AuthDialog(
        baseUrl: 'http://147.79.118.75:5000', // adapte ici
        onDone: (AuthResult res) {
        // Tu récupères ici userId/token/isLogin
        // Exemple: context.read<AuthService>().save(res);
        // print('AuthResult: $res');
        },
      )
    );
    if (ok == true && mounted) setState(() {}); // rafraîchir l’affichage (userId)
  }

  Future<void> _openCreateVehicleSheet() async {
    if (!Session.instance.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter d’abord.')),
      );
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AuthDialog(
          baseUrl: 'http://147.79.118.75:5000', // adapte ici
            onDone: (AuthResult res) {
              // Tu récupères ici userId/token/isLogin
              // Exemple: context.read<AuthService>().save(res);
              // print('AuthResult: $res');
            },
          ),
      );
      if (ok != true) return;
    }

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreateVehicleForm(),
    );

    if (created == true) {
      widget.updateData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Véhicule créé avec succès')),
        );
      }
    }
  }

  ListTile _buildAuthTile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final userId = Session.instance.userId;
    final isConnected = userId != null;

    return ListTile(
      title: Text(isConnected ? 'Connecté' : 'Connexion / Inscription', style: _tileTextStyle(context)),
      subtitle: isConnected
          ? Text('Utilisateur: $userId', style: TextStyle(color: cs.onSurfaceVariant))
          : const Text('Authentifiez-vous pour gérer vos véhicules'),
      tileColor: cs.surface,
      trailing: Icon(isConnected ? Icons.verified_user : Icons.login, color: cs.primary),
      onTap: _openAuthDialog,
      onLongPress: () {
        // astuce: long press pour se déconnecter rapidement (dev)
        Session.instance.clear();
        setState(() {});
      },
    );
  }

  ListTile _buildCreateVehicleTile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = Session.instance.isAuthenticated;
    return ListTile(
      title: Text('Ajouter un véhicule', style: _tileTextStyle(context)),
      subtitle: enabled ? null : Text('Requiert une connexion', style: TextStyle(color: cs.onSurfaceVariant)),
      tileColor: cs.surface,
      trailing: Icon(Icons.directions_car_filled, color: enabled ? cs.primary : cs.onSurfaceVariant),
      onTap: enabled ? _openCreateVehicleSheet : _openAuthDialog,
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
                _buildAuthTile(context),
                Divider(height: 1, color: cs.outlineVariant),
                _buildCreateVehicleTile(context),
                Divider(height: 1, color: cs.outlineVariant),
                _buildGeneratePDFButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
