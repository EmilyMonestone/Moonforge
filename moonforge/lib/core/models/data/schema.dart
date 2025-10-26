import 'package:firestore_odm/firestore_odm.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/core/models/data/encounter.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/core/models/data/join_code.dart';
import 'package:moonforge/core/models/data/media_asset.dart';
import 'package:moonforge/core/models/data/party.dart';
import 'package:moonforge/core/models/data/player.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/core/models/data/user.dart';

part 'schema.g.dart';

@Schema()
// Campaign and its subcollections
@Collection<Campaign>("campaigns")
@Collection<Party>("campaigns/*/parties")
@Collection<Player>("campaigns/*/players")
@Collection<Chapter>("campaigns/*/chapters")
@Collection<Adventure>("campaigns/*/chapters/*/adventures")
@Collection<Scene>("campaigns/*/chapters/*/adventures/*/scenes")
@Collection<Entity>("campaigns/*/entities")
@Collection<Encounter>("campaigns/*/encounters")
@Collection<Session>("campaigns/*/sessions")
@Collection<MediaAsset>("campaigns/*/media")
// Users and subcollections
@Collection<User>("users")
// Other
@Collection<JoinCode>("joins")
final appSchema = _$AppSchema;
