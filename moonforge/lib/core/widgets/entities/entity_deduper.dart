import 'package:moonforge/core/services/entity_gatherer.dart';

List<EntityWithOrigin> dedupeEntities(List<EntityWithOrigin> entities) {
  // Copy the dedupe logic from EntitiesWidget into a reusable function.
  int rank(EntityOrigin? o) {
    if (o == null) return 0;
    switch (o.partType) {
      case 'scene':
        return 5;
      case 'encounter':
        return 4;
      case 'adventure':
        return 3;
      case 'chapter':
        return 2;
      case 'campaign':
        return 1;
      default:
        return 1;
    }
  }

  final byId = <String, EntityWithOrigin>{};
  for (final ewo in entities) {
    final id = ewo.entity.id;
    final existing = byId[id];

    bool isTrueOrigin(EntityWithOrigin e) {
      return e.origin != null && e.entity.originId == e.origin!.partId;
    }

    if (existing == null) {
      byId[id] = ewo;
      continue;
    }

    final existingTrue = isTrueOrigin(existing);
    final newTrue = isTrueOrigin(ewo);

    if (existingTrue && !newTrue) continue;
    if (newTrue && !existingTrue) {
      byId[id] = ewo;
      continue;
    }

    if (rank(ewo.origin) > rank(existing.origin)) {
      byId[id] = ewo;
    }
  }

  return byId.values.toList(growable: false);
}
