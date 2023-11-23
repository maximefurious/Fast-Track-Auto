import 'dart:collection';

import 'package:flutter/material.dart';

class CarnetPage extends StatefulWidget {
  final Widget entListWidget;
  final Widget compteurListWidget;
  final Function startAddNewEntretien;
  final Function startAddNewCompteur;
  final HashMap<String, Color> colorMap;
  final Map<String, dynamic> vehiculeMap;

  const CarnetPage(
    this.entListWidget,
    this.compteurListWidget,
    this.startAddNewEntretien,
    this.startAddNewCompteur,
    this.colorMap,
    this.vehiculeMap, {
    Key? key,
  }) : super(key: key);

  @override
  State<CarnetPage> createState() => _CarnetPageState();
}

class _CarnetPageState extends State<CarnetPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Widget listItemWitdget(listWidget, startAddNewItem) {
    return Container(
      color: widget.colorMap['backgroundCard'],
      child: Column(
        children: [
          Expanded(
            child: listWidget,
          ),
          ButtonBar(
            children: [
              FloatingActionButton(
                onPressed: () => startAddNewItem(context),
                backgroundColor: widget.colorMap['primaryColor'],
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.colorMap['secondaryColor'],
          // for the title icon + text
          title: Row(
            children: [
              const Icon(Icons.car_crash, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                '${widget.vehiculeMap['title'].toString().split(' ')[0]} - ${widget.vehiculeMap['title'].toString().split(' ')[1]}',
                style: TextStyle(
                  color: widget.colorMap['text'],
                ),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 5,
          bottom: TabBar(
            controller: _tabController,
            labelColor: widget.colorMap['primaryColor']!,
            unselectedLabelColor:
                widget.colorMap['primaryColor']!.withOpacity(0.5),
            indicatorColor: widget.colorMap['primaryColor']!,
            tabs: const [
              Tab(text: 'Entretien/Frais'),
              Tab(text: 'Compteur/Kilométrage'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            listItemWitdget(widget.entListWidget, widget.startAddNewEntretien),
            listItemWitdget(
                widget.compteurListWidget, widget.startAddNewCompteur),
          ],
        ),
      ),
    );
  }
}
