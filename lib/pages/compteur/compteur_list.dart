    import 'package:flutter/material.dart';
    import 'package:furious_app/models/compteur.dart';
    import 'package:furious_app/pages/compteur/compteur_item.dart';
    import 'package:furious_app/services/impl/compteur_service.dart';
    import 'package:furious_app/services/service_manager.dart';

    class CompteurList extends StatelessWidget {
      final List<Compteur> compteurList;

      final Map<String, Color> colorMap;

      const CompteurList(this.compteurList, this.colorMap, {super.key});

      void _deleteCompteur(String id) => ServiceManager.instance.get<CompteurService>().delete(id);
      void _updateCompteur(Compteur c) => ServiceManager.instance.get<CompteurService>().update(c);

      @override
      Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final cs = theme.colorScheme;

        if (compteurList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aucun Kilometrage enregistré',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color ?? cs.onSurface,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/images/waiting.png',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          );
        }

        return ListView.separated(
          itemCount: compteurList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final ent = compteurList[index];
            return CompteurItem(
              key: ValueKey(ent.id),
              compteur: ent,
              deleteCompteur: _deleteCompteur,
              updateCompteur: _updateCompteur,
            );
          },
        );
      }
    }
