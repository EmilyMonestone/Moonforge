import 'package:firestore_odm/firestore_odm.dart';
import 'package:moonforge/core/models/campaign.dart';

part 'schema.g.dart';

@Schema()
@Collection<Campaign>("campaigns")
final appSchema = _$AppSchema;
