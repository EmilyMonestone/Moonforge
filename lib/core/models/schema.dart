import 'package:firestore_odm/firestore_odm.dart';
import 'package:moonforge/core/models/adventure.dart';
import 'package:moonforge/core/models/campaign.dart';
import 'package:moonforge/core/models/chapter.dart';
import 'package:moonforge/core/models/encounter.dart';
import 'package:moonforge/core/models/entity.dart';
import 'package:moonforge/core/models/join_code.dart';
import 'package:moonforge/core/models/media_asset.dart';
import 'package:moonforge/core/models/scene.dart';
import 'package:moonforge/core/models/session.dart';

part 'schema.g.dart';

@Schema()
@Collection<Campaign>("campaigns")
@Collection<ChapterDoc>('campaigns/*/chapters')
@Collection<AdventureDoc>('campaigns/*/chapters/*/adventures')
@Collection<SceneDoc>('campaigns/*/chapters/*/adventures/*/scenes')
@Collection<EntityDoc>('campaigns/*/entities')
@Collection<EncounterDoc>('campaigns/*/encounters')
@Collection<SessionDoc>('campaigns/*/sessions')
@Collection<MediaAssetDoc>('campaigns/*/media')
@Collection<JoinCode>('joins')
final appSchema = _$AppSchema;
