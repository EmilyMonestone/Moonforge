import 'package:firestore_odm/firestore_odm.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/chapter.dart';
import 'package:moonforge/data/firebase/models/encounter.dart';
import 'package:moonforge/data/firebase/models/entity.dart';
import 'package:moonforge/data/firebase/models/join_code.dart';
import 'package:moonforge/data/firebase/models/media_asset.dart';
import 'package:moonforge/data/firebase/models/party.dart';
import 'package:moonforge/data/firebase/models/player.dart';
import 'package:moonforge/data/firebase/models/scene.dart';
import 'package:moonforge/data/firebase/models/session.dart';
import 'package:moonforge/data/firebase/models/user.dart';

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
