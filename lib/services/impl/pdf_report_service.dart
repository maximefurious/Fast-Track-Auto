// lib/services/pdf_report_service.dart
import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/foundation.dart';

import 'package:furious_app/services/service.dart';
import 'package:furious_app/models/compteur.dart';
import 'package:furious_app/models/entretien.dart';

class PdfReportService extends Service {
  String get name => 'PdfReportService';

  final String title;
  final PdfColor headerColor;
  final PdfColor gridHeaderBg;
  final PdfColor gridHeaderText;
  final PdfFont titleFont;
  final PdfFont h1Font;
  final PdfFont h2Font;
  final PdfFont bodyFont;

  PdfReportService({
    String? title,
    PdfColor? headerColor,
    PdfColor? gridHeaderBg,
    PdfColor? gridHeaderText,
    PdfFont? titleFont,
    PdfFont? h1Font,
    PdfFont? h2Font,
    PdfFont? bodyFont,
  })  : title = title ?? 'Carnet d’entretien',
        // No `const` here because these constructors aren’t const.
        headerColor = headerColor ?? PdfColor(0, 0, 0),
        gridHeaderBg = gridHeaderBg ?? PdfColor(230, 230, 230),
        gridHeaderText = gridHeaderText ?? PdfColor(0, 0, 0),
        titleFont = titleFont ?? PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold),
        h1Font = h1Font ?? PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold),
        h2Font = h2Font ?? PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
        bodyFont = bodyFont ?? PdfStandardFont(PdfFontFamily.helvetica, 12);

  // API principale: construit le PDF et retourne les bytes.
  Future<Uint8List> buildVehicleReport({
    required Map<String, dynamic> vehicule,
    required List<Compteur> compteurs,
    required List<Entretien> entretiens,
  }) async {
    // heavy work hors UI
    return compute<_PdfInput, Uint8List>(_buildPdfIsolate, _PdfInput(
      vehicule: vehicule,
      compteurs: compteurs,
      entretiens: entretiens,
      config: _PdfConfig(
        title: title,
        headerColor: headerColor,
        gridHeaderBg: gridHeaderBg,
        gridHeaderText: gridHeaderText,
      ),
    ));
  }
}

// Données envoyées à l’isolate
class _PdfInput {
  final Map<String, dynamic> vehicule;
  final List<Compteur> compteurs;
  final List<Entretien> entretiens;
  final _PdfConfig config;

  _PdfInput({
    required this.vehicule,
    required this.compteurs,
    required this.entretiens,
    required this.config,
  });
}

class _PdfConfig {
  final String title;
  final PdfColor headerColor;
  final PdfColor gridHeaderBg;
  final PdfColor gridHeaderText;

  _PdfConfig({
    required this.title,
    required this.headerColor,
    required this.gridHeaderBg,
    required this.gridHeaderText,
  });
}

// Fonction exécutée dans un isolate pour ne pas bloquer l'UI
Uint8List _buildPdfIsolate(_PdfInput input) {
  final document = PdfDocument();
  final page = document.pages.add();

  final titleFont = PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold);
  final h1Font    = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
  final h2Font    = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
  final bodyFont  = PdfStandardFont(PdfFontFamily.helvetica, 12);

  // HEADER
  page.graphics.drawString(
    input.config.title,
    titleFont,
    brush: PdfSolidBrush(input.config.headerColor),
    bounds: Rect.fromLTWH(0, 20, page.getClientSize().width, 40),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );

  // Infos véhicule
  final immat = (input.vehicule['immatriculation'] ?? '').toString();
  final marqueModele = (input.vehicule['title'] ?? '').toString();
  final owner = (input.vehicule['owner'] ?? '').toString();

  final yStart = 80.0;
  page.graphics.drawString('Véhicule', h1Font,
      bounds: Rect.fromLTWH(0, yStart, page.getClientSize().width, 24));
  var cursorY = yStart + 26;

  void line(String label, String value) {
    page.graphics.drawString(
      '$label: $value',
      bodyFont,
      bounds: Rect.fromLTWH(0, cursorY, page.getClientSize().width, 18),
    );
    cursorY += 18;
  }

  if (marqueModele.isNotEmpty) line('Modèle', marqueModele);
  if (immat.isNotEmpty)        line('Immatriculation', immat);
  if (owner.isNotEmpty)        line('Propriétaire', owner);

  cursorY += 10;

  // Tableau des compteurs
  page.graphics.drawString('Historique des compteurs', h2Font,
      bounds: Rect.fromLTWH(0, cursorY, page.getClientSize().width, 20));
  cursorY += 24;

  final grid1 = PdfGrid();
  grid1.columns.add(count: 3);
  grid1.headers.add(1);

  // header style
  grid1.style = PdfGridStyle(
    font: bodyFont,
    cellPadding: PdfPaddings(left: 5, right: 5, top: 3, bottom: 3),
  );
  final header1 = grid1.headers[0];
  header1.style = PdfGridRowStyle(
    backgroundBrush: PdfSolidBrush(input.config.gridHeaderBg),
    textBrush: PdfSolidBrush(input.config.gridHeaderText),
    font: PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  );
  header1.cells[0].value = 'Date';
  header1.cells[1].value = 'Kilométrage';
  header1.cells[2].value = 'Conso. Moy.';

  for (final c in input.compteurs) {
    final r = grid1.rows.add();
    final date = '${c.date.day}/${c.date.month}/${c.date.year}';
    r.cells[0].value = date;
    r.cells[1].value = '${c.kilometrage} km';
    r.cells[2].value = (c.moyConsommation).toString();
  }

  final grid1Result = grid1.draw(
    page: page,
    bounds: Rect.fromLTWH(0, cursorY, page.getClientSize().width, 0),
  )!;
  cursorY = grid1Result.bounds.bottom + 20;

  // Tableau des entretiens
  page.graphics.drawString('Historique des entretiens', h2Font,
      bounds: Rect.fromLTWH(0, cursorY, page.getClientSize().width, 20));
  cursorY += 24;

  final grid2 = PdfGrid();
  grid2.columns.add(count: 4);
  grid2.headers.add(1);
  grid2.style = PdfGridStyle(
    font: bodyFont,
    cellPadding: PdfPaddings(left: 5, right: 5, top: 3, bottom: 3),
  );

  final header2 = grid2.headers[0];
  header2.style = PdfGridRowStyle(
    backgroundBrush: PdfSolidBrush(input.config.gridHeaderBg),
    textBrush: PdfSolidBrush(input.config.gridHeaderText),
    font: PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  );
  header2.cells[0].value = 'Type';
  header2.cells[1].value = 'Kilométrage';
  header2.cells[2].value = 'Prix';
  header2.cells[3].value = 'Date';

  for (final e in input.entretiens) {
    final r = grid2.rows.add();
    r.cells[0].value = e.type;
    r.cells[1].value = '${e.kilometrage} km';
    r.cells[2].value = '${e.prix} €';
    r.cells[3].value = '${e.date.day}/${e.date.month}/${e.date.year}';
  }

  grid2.draw(
    page: page,
    bounds: Rect.fromLTWH(0, cursorY, page.getClientSize().width, 0),
  );

  final bytes = document.saveSync();
  document.dispose();
  return Uint8List.fromList(bytes);
}
