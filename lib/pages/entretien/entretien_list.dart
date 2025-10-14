
import 'package:flutter/material.dart';
import 'package:furious_app/pages/entretien/entretien_item.dart';
import 'package:furious_app/services/impl/entretien_service.dart';
import 'package:furious_app/services/service_manager.dart';
import '../../models/entretien.dart';

class EntretienList extends StatelessWidget {
  final List<Entretien> entretienList;

  const EntretienList(this.entretienList, {super.key,});

  void _deleteEntretien(String id) => ServiceManager.instance.get<EntretienService>().delete(id);
  void _updateEntretien(Entretien e) => ServiceManager.instance.get<EntretienService>().update(e);

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
          deleteEnt: _deleteEntretien,
          updateEntretien: _updateEntretien,
        );
      },
    );
  }
}
