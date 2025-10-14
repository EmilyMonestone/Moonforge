import 'package:firestore_odm/firestore_odm.dart';
import 'package:moonforge/core/models/adventure.dart';
import 'package:moonforge/core/models/campaign.dart';
import 'package:moonforge/core/models/chapter.dart';
import 'package:moonforge/core/models/encounter.dart';
import 'package:moonforge/core/models/entity.dart';
import 'package:moonforge/core/models/join_code.dart';
import 'package:moonforge/core/models/media_asset.dart';
import 'package:moonforge/core/models/player.dart';
import 'package:moonforge/core/models/party.dart';
import 'package:moonforge/core/models/scene.dart';
import 'package:moonforge/core/models/session.dart';

part 'schema.g.dart';

@Schema()
// Root collections
@Collection<Campaign>("campaigns")
@Collection<JoinCode>("joins")
// Subcollections under campaigns
@Collection<Party>("campaigns/*/parties")
@Collection<Player>("campaigns/*/players")
@Collection<Chapter>("campaigns/*/chapters")
@Collection<Adventure>("campaigns/*/chapters/*/adventures")
@Collection<Scene>("campaigns/*/chapters/*/adventures/*/scenes")
@Collection<Entity>("campaigns/*/entities")
@Collection<Encounter>("campaigns/*/encounters")
@Collection<Session>("campaigns/*/sessions")
@Collection<MediaAsset>("campaigns/*/media")
final appSchema = _$AppSchema;
