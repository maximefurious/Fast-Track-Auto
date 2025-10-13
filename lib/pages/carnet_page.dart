import 'package:flutter/material.dart';

class CarnetPage extends StatefulWidget {
  final Widget entListWidget;
  final Widget compteurListWidget;
  final Function startAddNewEntretien; // garde la même signature (avec BuildContext)
  final Function startAddNewCompteur;
  final Map<String, dynamic> vehiculeMap;

  const CarnetPage(
      this.entListWidget,
      this.compteurListWidget,
      this.startAddNewEntretien,
      this.startAddNewCompteur,
      this.vehiculeMap, {
        super.key,
      });

  @override
  State<CarnetPage> createState() => _CarnetPageState();
}

class _CarnetPageState extends State<CarnetPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Widget listItemWidget(BuildContext context, Widget listWidget, Function startAddNewItem) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface, // ou cs.surfaceVariant si tu veux plus de contraste
      child: Column(
        children: [
          Expanded(child: listWidget),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () => startAddNewItem(context),
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _titleFromVehiculeMap(Map<String, dynamic> vehiculeMap) {
    final raw = (vehiculeMap['title'] ?? 'Ma voiture').toString().trim();
    final parts = raw.split(RegExp(r'\s+'));
    return parts.length >= 2 ? '${parts[0]} - ${parts[1]}' : raw;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cs.surface, // laisse null si tu veux le comportement par défaut Material 3
          elevation: 5,
          title: Row(
            children: [
              Icon(Icons.car_crash, color: cs.onSurface),
              const SizedBox(width: 10),
              Text(
                _titleFromVehiculeMap(widget.vehiculeMap),
                style: theme.textTheme.titleMedium?.copyWith(color: cs.onSurface),
              ),
            ],
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurfaceVariant,
            indicatorColor: cs.primary,
            tabs: const [
              Tab(text: 'Entretien/Frais'),
              Tab(text: 'Compteur/Kilométrage'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            listItemWidget(context, widget.entListWidget, widget.startAddNewEntretien),
            listItemWidget(context, widget.compteurListWidget, widget.startAddNewCompteur),
          ],
        ),
      ),
    );
  }
}
