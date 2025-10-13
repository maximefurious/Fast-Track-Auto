import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien/entretien_item.dart';
import '../../models/entretien.dart';

class EntretienList extends StatelessWidget {
  final List<Entretien> entretienList;
  final void Function(String id) onDelete;
  final void Function(Entretien e) onUpdate;

  const EntretienList(this.entretienList, this.onDelete, this.onUpdate, {super.key,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (entretienList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aucun entretien',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                // onSurface = couleur de texte par défaut pour un fond surface
                color: theme.textTheme.titleMedium?.color ?? cs.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: Image.asset(
                'assets/images/waiting.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: entretienList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ent = entretienList[index];
        return EntretienItem(
          key: ValueKey(ent.id),
          entretien: ent,
          deleteEnt: onDelete,
          updateEntretien: onUpdate,
          // plus de colorMap ici
        );
      },
    );
  }
}
