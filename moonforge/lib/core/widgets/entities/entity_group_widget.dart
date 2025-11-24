import 'package:flutter/material.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/entities/entity_badges.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

class EntityGroupWidget extends StatelessWidget {
  const EntityGroupWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.entities,
  });

  final String title;
  final IconData icon;
  final List<EntityWithOrigin> entities;

  @override
  Widget build(BuildContext context) {
    return SurfaceContainer(
      title: SectionHeader(title: title, icon: icon),
      child: Column(
        children: [
          ...entities.map((entityWithOrigin) {
            final entity = entityWithOrigin.entity;
            final origin = entityWithOrigin.origin;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        EntityRouteData(entityId: entity.id).push(context);
                      },
                      hoverColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHigh,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            entity.name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          KindChip(kind: entity.kind),
                          if (origin != null) ...[
                            const SizedBox(width: 6),
                            OriginBadge(origin: origin),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
