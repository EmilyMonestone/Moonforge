// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $CampaignsTable extends Campaigns
    with TableInfo<$CampaignsTable, Campaign> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CampaignsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($CampaignsTable.$convertercontentn);
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
  memberUids = GeneratedColumn<String>(
    'member_uids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<String>?>($CampaignsTable.$convertermemberUidsn);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> entityIds =
      GeneratedColumn<String>(
        'entity_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($CampaignsTable.$converterentityIds);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    content,
    ownerUid,
    memberUids,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'campaigns';
  @override
  VerificationContext validateIntegrity(
    Insertable<Campaign> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Campaign map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Campaign(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      content: $CampaignsTable.$convertercontentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        ),
      ),
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      ),
      memberUids: $CampaignsTable.$convertermemberUidsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}member_uids'],
        ),
      ),
      entityIds: $CampaignsTable.$converterentityIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_ids'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $CampaignsTable createAlias(String alias) {
    return $CampaignsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $convertercontent = quillConv;
  static JsonTypeConverter2<
    Map<String, dynamic>?,
    String?,
    Map<String, dynamic>?
  >
  $convertercontentn = JsonTypeConverter2.asNullable($convertercontent);
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertermemberUids = const StringListConverter();
  static JsonTypeConverter2<List<String>?, String?, List<dynamic>?>
  $convertermemberUidsn = JsonTypeConverter2.asNullable($convertermemberUids);
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterentityIds = const StringListConverter();
}

class Campaign extends DataClass implements Insertable<Campaign> {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic>? content;
  final String? ownerUid;
  final List<String>? memberUids;
  final List<String> entityIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  const Campaign({
    required this.id,
    required this.name,
    required this.description,
    this.content,
    this.ownerUid,
    this.memberUids,
    required this.entityIds,
    this.createdAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(
        $CampaignsTable.$convertercontentn.toSql(content),
      );
    }
    if (!nullToAbsent || ownerUid != null) {
      map['owner_uid'] = Variable<String>(ownerUid);
    }
    if (!nullToAbsent || memberUids != null) {
      map['member_uids'] = Variable<String>(
        $CampaignsTable.$convertermemberUidsn.toSql(memberUids),
      );
    }
    {
      map['entity_ids'] = Variable<String>(
        $CampaignsTable.$converterentityIds.toSql(entityIds),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  CampaignsCompanion toCompanion(bool nullToAbsent) {
    return CampaignsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      ownerUid: ownerUid == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerUid),
      memberUids: memberUids == null && nullToAbsent
          ? const Value.absent()
          : Value(memberUids),
      entityIds: Value(entityIds),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory Campaign.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Campaign(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      content: $CampaignsTable.$convertercontentn.fromJson(
        serializer.fromJson<Map<String, dynamic>?>(json['content']),
      ),
      ownerUid: serializer.fromJson<String?>(json['ownerUid']),
      memberUids: $CampaignsTable.$convertermemberUidsn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['memberUids']),
      ),
      entityIds: $CampaignsTable.$converterentityIds.fromJson(
        serializer.fromJson<List<dynamic>>(json['entityIds']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'content': serializer.toJson<Map<String, dynamic>?>(
        $CampaignsTable.$convertercontentn.toJson(content),
      ),
      'ownerUid': serializer.toJson<String?>(ownerUid),
      'memberUids': serializer.toJson<List<dynamic>?>(
        $CampaignsTable.$convertermemberUidsn.toJson(memberUids),
      ),
      'entityIds': serializer.toJson<List<dynamic>>(
        $CampaignsTable.$converterentityIds.toJson(entityIds),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  Campaign copyWith({
    String? id,
    String? name,
    String? description,
    Value<Map<String, dynamic>?> content = const Value.absent(),
    Value<String?> ownerUid = const Value.absent(),
    Value<List<String>?> memberUids = const Value.absent(),
    List<String>? entityIds,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => Campaign(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    content: content.present ? content.value : this.content,
    ownerUid: ownerUid.present ? ownerUid.value : this.ownerUid,
    memberUids: memberUids.present ? memberUids.value : this.memberUids,
    entityIds: entityIds ?? this.entityIds,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  Campaign copyWithCompanion(CampaignsCompanion data) {
    return Campaign(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      content: data.content.present ? data.content.value : this.content,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      memberUids: data.memberUids.present
          ? data.memberUids.value
          : this.memberUids,
      entityIds: data.entityIds.present ? data.entityIds.value : this.entityIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Campaign(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('memberUids: $memberUids, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    content,
    ownerUid,
    memberUids,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Campaign &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.content == this.content &&
          other.ownerUid == this.ownerUid &&
          other.memberUids == this.memberUids &&
          other.entityIds == this.entityIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class CampaignsCompanion extends UpdateCompanion<Campaign> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<Map<String, dynamic>?> content;
  final Value<String?> ownerUid;
  final Value<List<String>?> memberUids;
  final Value<List<String>> entityIds;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const CampaignsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.content = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.memberUids = const Value.absent(),
    this.entityIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CampaignsCompanion.insert({
    required String id,
    required String name,
    required String description,
    this.content = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.memberUids = const Value.absent(),
    required List<String> entityIds,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description),
       entityIds = Value(entityIds),
       rev = Value(rev);
  static Insertable<Campaign> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? content,
    Expression<String>? ownerUid,
    Expression<String>? memberUids,
    Expression<String>? entityIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (content != null) 'content': content,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (memberUids != null) 'member_uids': memberUids,
      if (entityIds != null) 'entity_ids': entityIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CampaignsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<Map<String, dynamic>?>? content,
    Value<String?>? ownerUid,
    Value<List<String>?>? memberUids,
    Value<List<String>>? entityIds,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return CampaignsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      content: content ?? this.content,
      ownerUid: ownerUid ?? this.ownerUid,
      memberUids: memberUids ?? this.memberUids,
      entityIds: entityIds ?? this.entityIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
        $CampaignsTable.$convertercontentn.toSql(content.value),
      );
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (memberUids.present) {
      map['member_uids'] = Variable<String>(
        $CampaignsTable.$convertermemberUidsn.toSql(memberUids.value),
      );
    }
    if (entityIds.present) {
      map['entity_ids'] = Variable<String>(
        $CampaignsTable.$converterentityIds.toSql(entityIds.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CampaignsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('content: $content, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('memberUids: $memberUids, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _campaignIdMeta = const VerificationMeta(
    'campaignId',
  );
  @override
  late final GeneratedColumn<String> campaignId = GeneratedColumn<String>(
    'campaign_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campaigns (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($ChaptersTable.$convertercontentn);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> entityIds =
      GeneratedColumn<String>(
        'entity_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($ChaptersTable.$converterentityIds);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    campaignId,
    name,
    order,
    summary,
    content,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('campaign_id')) {
      context.handle(
        _campaignIdMeta,
        campaignId.isAcceptableOrUnknown(data['campaign_id']!, _campaignIdMeta),
      );
    } else if (isInserting) {
      context.missing(_campaignIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      campaignId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}campaign_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      content: $ChaptersTable.$convertercontentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        ),
      ),
      entityIds: $ChaptersTable.$converterentityIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_ids'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $convertercontent = quillConv;
  static JsonTypeConverter2<
    Map<String, dynamic>?,
    String?,
    Map<String, dynamic>?
  >
  $convertercontentn = JsonTypeConverter2.asNullable($convertercontent);
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterentityIds = const StringListConverter();
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String campaignId;
  final String name;
  final int order;
  final String? summary;
  final Map<String, dynamic>? content;
  final List<String> entityIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  const Chapter({
    required this.id,
    required this.campaignId,
    required this.name,
    required this.order,
    this.summary,
    this.content,
    required this.entityIds,
    this.createdAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['campaign_id'] = Variable<String>(campaignId);
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(
        $ChaptersTable.$convertercontentn.toSql(content),
      );
    }
    {
      map['entity_ids'] = Variable<String>(
        $ChaptersTable.$converterentityIds.toSql(entityIds),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      campaignId: Value(campaignId),
      name: Value(name),
      order: Value(order),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      entityIds: Value(entityIds),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      campaignId: serializer.fromJson<String>(json['campaignId']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      summary: serializer.fromJson<String?>(json['summary']),
      content: $ChaptersTable.$convertercontentn.fromJson(
        serializer.fromJson<Map<String, dynamic>?>(json['content']),
      ),
      entityIds: $ChaptersTable.$converterentityIds.fromJson(
        serializer.fromJson<List<dynamic>>(json['entityIds']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'campaignId': serializer.toJson<String>(campaignId),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'summary': serializer.toJson<String?>(summary),
      'content': serializer.toJson<Map<String, dynamic>?>(
        $ChaptersTable.$convertercontentn.toJson(content),
      ),
      'entityIds': serializer.toJson<List<dynamic>>(
        $ChaptersTable.$converterentityIds.toJson(entityIds),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  Chapter copyWith({
    String? id,
    String? campaignId,
    String? name,
    int? order,
    Value<String?> summary = const Value.absent(),
    Value<Map<String, dynamic>?> content = const Value.absent(),
    List<String>? entityIds,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => Chapter(
    id: id ?? this.id,
    campaignId: campaignId ?? this.campaignId,
    name: name ?? this.name,
    order: order ?? this.order,
    summary: summary.present ? summary.value : this.summary,
    content: content.present ? content.value : this.content,
    entityIds: entityIds ?? this.entityIds,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      campaignId: data.campaignId.present
          ? data.campaignId.value
          : this.campaignId,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      summary: data.summary.present ? data.summary.value : this.summary,
      content: data.content.present ? data.content.value : this.content,
      entityIds: data.entityIds.present ? data.entityIds.value : this.entityIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('campaignId: $campaignId, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    campaignId,
    name,
    order,
    summary,
    content,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.campaignId == this.campaignId &&
          other.name == this.name &&
          other.order == this.order &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.entityIds == this.entityIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> campaignId;
  final Value<String> name;
  final Value<int> order;
  final Value<String?> summary;
  final Value<Map<String, dynamic>?> content;
  final Value<List<String>> entityIds;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.campaignId = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.entityIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String campaignId,
    required String name,
    required int order,
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    required List<String> entityIds,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       campaignId = Value(campaignId),
       name = Value(name),
       order = Value(order),
       entityIds = Value(entityIds),
       rev = Value(rev);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? campaignId,
    Expression<String>? name,
    Expression<int>? order,
    Expression<String>? summary,
    Expression<String>? content,
    Expression<String>? entityIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (campaignId != null) 'campaign_id': campaignId,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (entityIds != null) 'entity_ids': entityIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? id,
    Value<String>? campaignId,
    Value<String>? name,
    Value<int>? order,
    Value<String?>? summary,
    Value<Map<String, dynamic>?>? content,
    Value<List<String>>? entityIds,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      name: name ?? this.name,
      order: order ?? this.order,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      entityIds: entityIds ?? this.entityIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (campaignId.present) {
      map['campaign_id'] = Variable<String>(campaignId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
        $ChaptersTable.$convertercontentn.toSql(content.value),
      );
    }
    if (entityIds.present) {
      map['entity_ids'] = Variable<String>(
        $ChaptersTable.$converterentityIds.toSql(entityIds.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('campaignId: $campaignId, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AdventuresTable extends Adventures
    with TableInfo<$AdventuresTable, Adventure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdventuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($AdventuresTable.$convertercontentn);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> entityIds =
      GeneratedColumn<String>(
        'entity_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($AdventuresTable.$converterentityIds);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    name,
    order,
    summary,
    content,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'adventures';
  @override
  VerificationContext validateIntegrity(
    Insertable<Adventure> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Adventure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Adventure(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      content: $AdventuresTable.$convertercontentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        ),
      ),
      entityIds: $AdventuresTable.$converterentityIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_ids'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $AdventuresTable createAlias(String alias) {
    return $AdventuresTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $convertercontent = quillConv;
  static JsonTypeConverter2<
    Map<String, dynamic>?,
    String?,
    Map<String, dynamic>?
  >
  $convertercontentn = JsonTypeConverter2.asNullable($convertercontent);
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterentityIds = const StringListConverter();
}

class Adventure extends DataClass implements Insertable<Adventure> {
  final String id;
  final String chapterId;
  final String name;
  final int order;
  final String? summary;
  final Map<String, dynamic>? content;
  final List<String> entityIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  const Adventure({
    required this.id,
    required this.chapterId,
    required this.name,
    required this.order,
    this.summary,
    this.content,
    required this.entityIds,
    this.createdAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(
        $AdventuresTable.$convertercontentn.toSql(content),
      );
    }
    {
      map['entity_ids'] = Variable<String>(
        $AdventuresTable.$converterentityIds.toSql(entityIds),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  AdventuresCompanion toCompanion(bool nullToAbsent) {
    return AdventuresCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      name: Value(name),
      order: Value(order),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      entityIds: Value(entityIds),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory Adventure.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Adventure(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      summary: serializer.fromJson<String?>(json['summary']),
      content: $AdventuresTable.$convertercontentn.fromJson(
        serializer.fromJson<Map<String, dynamic>?>(json['content']),
      ),
      entityIds: $AdventuresTable.$converterentityIds.fromJson(
        serializer.fromJson<List<dynamic>>(json['entityIds']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'summary': serializer.toJson<String?>(summary),
      'content': serializer.toJson<Map<String, dynamic>?>(
        $AdventuresTable.$convertercontentn.toJson(content),
      ),
      'entityIds': serializer.toJson<List<dynamic>>(
        $AdventuresTable.$converterentityIds.toJson(entityIds),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  Adventure copyWith({
    String? id,
    String? chapterId,
    String? name,
    int? order,
    Value<String?> summary = const Value.absent(),
    Value<Map<String, dynamic>?> content = const Value.absent(),
    List<String>? entityIds,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => Adventure(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    name: name ?? this.name,
    order: order ?? this.order,
    summary: summary.present ? summary.value : this.summary,
    content: content.present ? content.value : this.content,
    entityIds: entityIds ?? this.entityIds,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  Adventure copyWithCompanion(AdventuresCompanion data) {
    return Adventure(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      summary: data.summary.present ? data.summary.value : this.summary,
      content: data.content.present ? data.content.value : this.content,
      entityIds: data.entityIds.present ? data.entityIds.value : this.entityIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Adventure(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    chapterId,
    name,
    order,
    summary,
    content,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Adventure &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.name == this.name &&
          other.order == this.order &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.entityIds == this.entityIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class AdventuresCompanion extends UpdateCompanion<Adventure> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> name;
  final Value<int> order;
  final Value<String?> summary;
  final Value<Map<String, dynamic>?> content;
  final Value<List<String>> entityIds;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const AdventuresCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.entityIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdventuresCompanion.insert({
    required String id,
    required String chapterId,
    required String name,
    required int order,
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    required List<String> entityIds,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       chapterId = Value(chapterId),
       name = Value(name),
       order = Value(order),
       entityIds = Value(entityIds),
       rev = Value(rev);
  static Insertable<Adventure> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? name,
    Expression<int>? order,
    Expression<String>? summary,
    Expression<String>? content,
    Expression<String>? entityIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (entityIds != null) 'entity_ids': entityIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdventuresCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<String>? name,
    Value<int>? order,
    Value<String?>? summary,
    Value<Map<String, dynamic>?>? content,
    Value<List<String>>? entityIds,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return AdventuresCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      name: name ?? this.name,
      order: order ?? this.order,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      entityIds: entityIds ?? this.entityIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
        $AdventuresTable.$convertercontentn.toSql(content.value),
      );
    }
    if (entityIds.present) {
      map['entity_ids'] = Variable<String>(
        $AdventuresTable.$converterentityIds.toSql(entityIds.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdventuresCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScenesTable extends Scenes with TableInfo<$ScenesTable, Scene> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScenesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adventureIdMeta = const VerificationMeta(
    'adventureId',
  );
  @override
  late final GeneratedColumn<String> adventureId = GeneratedColumn<String>(
    'adventure_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES adventures (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($ScenesTable.$convertercontentn);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> entityIds =
      GeneratedColumn<String>(
        'entity_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($ScenesTable.$converterentityIds);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    adventureId,
    name,
    order,
    summary,
    content,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scenes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Scene> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('adventure_id')) {
      context.handle(
        _adventureIdMeta,
        adventureId.isAcceptableOrUnknown(
          data['adventure_id']!,
          _adventureIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adventureIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Scene map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Scene(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      adventureId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adventure_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      content: $ScenesTable.$convertercontentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        ),
      ),
      entityIds: $ScenesTable.$converterentityIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_ids'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $ScenesTable createAlias(String alias) {
    return $ScenesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $convertercontent = quillConv;
  static JsonTypeConverter2<
    Map<String, dynamic>?,
    String?,
    Map<String, dynamic>?
  >
  $convertercontentn = JsonTypeConverter2.asNullable($convertercontent);
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterentityIds = const StringListConverter();
}

class Scene extends DataClass implements Insertable<Scene> {
  final String id;
  final String adventureId;
  final String name;
  final int order;
  final String? summary;
  final Map<String, dynamic>? content;
  final List<String> entityIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  const Scene({
    required this.id,
    required this.adventureId,
    required this.name,
    required this.order,
    this.summary,
    this.content,
    required this.entityIds,
    this.createdAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['adventure_id'] = Variable<String>(adventureId);
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(
        $ScenesTable.$convertercontentn.toSql(content),
      );
    }
    {
      map['entity_ids'] = Variable<String>(
        $ScenesTable.$converterentityIds.toSql(entityIds),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  ScenesCompanion toCompanion(bool nullToAbsent) {
    return ScenesCompanion(
      id: Value(id),
      adventureId: Value(adventureId),
      name: Value(name),
      order: Value(order),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      entityIds: Value(entityIds),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory Scene.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Scene(
      id: serializer.fromJson<String>(json['id']),
      adventureId: serializer.fromJson<String>(json['adventureId']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
      summary: serializer.fromJson<String?>(json['summary']),
      content: $ScenesTable.$convertercontentn.fromJson(
        serializer.fromJson<Map<String, dynamic>?>(json['content']),
      ),
      entityIds: $ScenesTable.$converterentityIds.fromJson(
        serializer.fromJson<List<dynamic>>(json['entityIds']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'adventureId': serializer.toJson<String>(adventureId),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
      'summary': serializer.toJson<String?>(summary),
      'content': serializer.toJson<Map<String, dynamic>?>(
        $ScenesTable.$convertercontentn.toJson(content),
      ),
      'entityIds': serializer.toJson<List<dynamic>>(
        $ScenesTable.$converterentityIds.toJson(entityIds),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  Scene copyWith({
    String? id,
    String? adventureId,
    String? name,
    int? order,
    Value<String?> summary = const Value.absent(),
    Value<Map<String, dynamic>?> content = const Value.absent(),
    List<String>? entityIds,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => Scene(
    id: id ?? this.id,
    adventureId: adventureId ?? this.adventureId,
    name: name ?? this.name,
    order: order ?? this.order,
    summary: summary.present ? summary.value : this.summary,
    content: content.present ? content.value : this.content,
    entityIds: entityIds ?? this.entityIds,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  Scene copyWithCompanion(ScenesCompanion data) {
    return Scene(
      id: data.id.present ? data.id.value : this.id,
      adventureId: data.adventureId.present
          ? data.adventureId.value
          : this.adventureId,
      name: data.name.present ? data.name.value : this.name,
      order: data.order.present ? data.order.value : this.order,
      summary: data.summary.present ? data.summary.value : this.summary,
      content: data.content.present ? data.content.value : this.content,
      entityIds: data.entityIds.present ? data.entityIds.value : this.entityIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Scene(')
          ..write('id: $id, ')
          ..write('adventureId: $adventureId, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    adventureId,
    name,
    order,
    summary,
    content,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Scene &&
          other.id == this.id &&
          other.adventureId == this.adventureId &&
          other.name == this.name &&
          other.order == this.order &&
          other.summary == this.summary &&
          other.content == this.content &&
          other.entityIds == this.entityIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class ScenesCompanion extends UpdateCompanion<Scene> {
  final Value<String> id;
  final Value<String> adventureId;
  final Value<String> name;
  final Value<int> order;
  final Value<String?> summary;
  final Value<Map<String, dynamic>?> content;
  final Value<List<String>> entityIds;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const ScenesCompanion({
    this.id = const Value.absent(),
    this.adventureId = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    this.entityIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScenesCompanion.insert({
    required String id,
    required String adventureId,
    required String name,
    required int order,
    this.summary = const Value.absent(),
    this.content = const Value.absent(),
    required List<String> entityIds,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       adventureId = Value(adventureId),
       name = Value(name),
       order = Value(order),
       entityIds = Value(entityIds),
       rev = Value(rev);
  static Insertable<Scene> custom({
    Expression<String>? id,
    Expression<String>? adventureId,
    Expression<String>? name,
    Expression<int>? order,
    Expression<String>? summary,
    Expression<String>? content,
    Expression<String>? entityIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (adventureId != null) 'adventure_id': adventureId,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
      if (summary != null) 'summary': summary,
      if (content != null) 'content': content,
      if (entityIds != null) 'entity_ids': entityIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScenesCompanion copyWith({
    Value<String>? id,
    Value<String>? adventureId,
    Value<String>? name,
    Value<int>? order,
    Value<String?>? summary,
    Value<Map<String, dynamic>?>? content,
    Value<List<String>>? entityIds,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return ScenesCompanion(
      id: id ?? this.id,
      adventureId: adventureId ?? this.adventureId,
      name: name ?? this.name,
      order: order ?? this.order,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      entityIds: entityIds ?? this.entityIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (adventureId.present) {
      map['adventure_id'] = Variable<String>(adventureId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(
        $ScenesTable.$convertercontentn.toSql(content.value),
      );
    }
    if (entityIds.present) {
      map['entity_ids'] = Variable<String>(
        $ScenesTable.$converterentityIds.toSql(entityIds.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScenesCompanion(')
          ..write('id: $id, ')
          ..write('adventureId: $adventureId, ')
          ..write('name: $name, ')
          ..write('order: $order, ')
          ..write('summary: $summary, ')
          ..write('content: $content, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartiesTable extends Parties with TableInfo<$PartiesTable, Party> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _campaignIdMeta = const VerificationMeta(
    'campaignId',
  );
  @override
  late final GeneratedColumn<String> campaignId = GeneratedColumn<String>(
    'campaign_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campaigns (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
  memberEntityIds = GeneratedColumn<String>(
    'member_entity_ids',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<String>?>($PartiesTable.$convertermemberEntityIdsn);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    campaignId,
    name,
    summary,
    memberEntityIds,
    createdAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parties';
  @override
  VerificationContext validateIntegrity(
    Insertable<Party> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('campaign_id')) {
      context.handle(
        _campaignIdMeta,
        campaignId.isAcceptableOrUnknown(data['campaign_id']!, _campaignIdMeta),
      );
    } else if (isInserting) {
      context.missing(_campaignIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Party map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Party(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      campaignId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}campaign_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      memberEntityIds: $PartiesTable.$convertermemberEntityIdsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}member_entity_ids'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $PartiesTable createAlias(String alias) {
    return $PartiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertermemberEntityIds = const StringListConverter();
  static JsonTypeConverter2<List<String>?, String?, List<dynamic>?>
  $convertermemberEntityIdsn = JsonTypeConverter2.asNullable(
    $convertermemberEntityIds,
  );
}

class Party extends DataClass implements Insertable<Party> {
  final String id;
  final String campaignId;
  final String name;
  final String? summary;
  final List<String>? memberEntityIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  const Party({
    required this.id,
    required this.campaignId,
    required this.name,
    this.summary,
    this.memberEntityIds,
    this.createdAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['campaign_id'] = Variable<String>(campaignId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || memberEntityIds != null) {
      map['member_entity_ids'] = Variable<String>(
        $PartiesTable.$convertermemberEntityIdsn.toSql(memberEntityIds),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  PartiesCompanion toCompanion(bool nullToAbsent) {
    return PartiesCompanion(
      id: Value(id),
      campaignId: Value(campaignId),
      name: Value(name),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      memberEntityIds: memberEntityIds == null && nullToAbsent
          ? const Value.absent()
          : Value(memberEntityIds),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory Party.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Party(
      id: serializer.fromJson<String>(json['id']),
      campaignId: serializer.fromJson<String>(json['campaignId']),
      name: serializer.fromJson<String>(json['name']),
      summary: serializer.fromJson<String?>(json['summary']),
      memberEntityIds: $PartiesTable.$convertermemberEntityIdsn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['memberEntityIds']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'campaignId': serializer.toJson<String>(campaignId),
      'name': serializer.toJson<String>(name),
      'summary': serializer.toJson<String?>(summary),
      'memberEntityIds': serializer.toJson<List<dynamic>?>(
        $PartiesTable.$convertermemberEntityIdsn.toJson(memberEntityIds),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  Party copyWith({
    String? id,
    String? campaignId,
    String? name,
    Value<String?> summary = const Value.absent(),
    Value<List<String>?> memberEntityIds = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => Party(
    id: id ?? this.id,
    campaignId: campaignId ?? this.campaignId,
    name: name ?? this.name,
    summary: summary.present ? summary.value : this.summary,
    memberEntityIds: memberEntityIds.present
        ? memberEntityIds.value
        : this.memberEntityIds,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  Party copyWithCompanion(PartiesCompanion data) {
    return Party(
      id: data.id.present ? data.id.value : this.id,
      campaignId: data.campaignId.present
          ? data.campaignId.value
          : this.campaignId,
      name: data.name.present ? data.name.value : this.name,
      summary: data.summary.present ? data.summary.value : this.summary,
      memberEntityIds: data.memberEntityIds.present
          ? data.memberEntityIds.value
          : this.memberEntityIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Party(')
          ..write('id: $id, ')
          ..write('campaignId: $campaignId, ')
          ..write('name: $name, ')
          ..write('summary: $summary, ')
          ..write('memberEntityIds: $memberEntityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    campaignId,
    name,
    summary,
    memberEntityIds,
    createdAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Party &&
          other.id == this.id &&
          other.campaignId == this.campaignId &&
          other.name == this.name &&
          other.summary == this.summary &&
          other.memberEntityIds == this.memberEntityIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class PartiesCompanion extends UpdateCompanion<Party> {
  final Value<String> id;
  final Value<String> campaignId;
  final Value<String> name;
  final Value<String?> summary;
  final Value<List<String>?> memberEntityIds;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const PartiesCompanion({
    this.id = const Value.absent(),
    this.campaignId = const Value.absent(),
    this.name = const Value.absent(),
    this.summary = const Value.absent(),
    this.memberEntityIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartiesCompanion.insert({
    required String id,
    required String campaignId,
    required String name,
    this.summary = const Value.absent(),
    this.memberEntityIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       campaignId = Value(campaignId),
       name = Value(name),
       rev = Value(rev);
  static Insertable<Party> custom({
    Expression<String>? id,
    Expression<String>? campaignId,
    Expression<String>? name,
    Expression<String>? summary,
    Expression<String>? memberEntityIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (campaignId != null) 'campaign_id': campaignId,
      if (name != null) 'name': name,
      if (summary != null) 'summary': summary,
      if (memberEntityIds != null) 'member_entity_ids': memberEntityIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartiesCompanion copyWith({
    Value<String>? id,
    Value<String>? campaignId,
    Value<String>? name,
    Value<String?>? summary,
    Value<List<String>?>? memberEntityIds,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return PartiesCompanion(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      memberEntityIds: memberEntityIds ?? this.memberEntityIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (campaignId.present) {
      map['campaign_id'] = Variable<String>(campaignId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (memberEntityIds.present) {
      map['member_entity_ids'] = Variable<String>(
        $PartiesTable.$convertermemberEntityIdsn.toSql(memberEntityIds.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartiesCompanion(')
          ..write('id: $id, ')
          ..write('campaignId: $campaignId, ')
          ..write('name: $name, ')
          ..write('summary: $summary, ')
          ..write('memberEntityIds: $memberEntityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EncountersTable extends Encounters
    with TableInfo<$EncountersTable, Encounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EncountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originIdMeta = const VerificationMeta(
    'originId',
  );
  @override
  late final GeneratedColumn<String> originId = GeneratedColumn<String>(
    'origin_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _presetMeta = const VerificationMeta('preset');
  @override
  late final GeneratedColumn<bool> preset = GeneratedColumn<bool>(
    'preset',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("preset" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lootMeta = const VerificationMeta('loot');
  @override
  late final GeneratedColumn<String> loot = GeneratedColumn<String>(
    'loot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>?,
    String
  >
  combatants =
      GeneratedColumn<String>(
        'combatants',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<Map<String, dynamic>>?>(
        $EncountersTable.$convertercombatantsn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> entityIds =
      GeneratedColumn<String>(
        'entity_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($EncountersTable.$converterentityIds);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    originId,
    preset,
    notes,
    loot,
    combatants,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'encounters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Encounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('origin_id')) {
      context.handle(
        _originIdMeta,
        originId.isAcceptableOrUnknown(data['origin_id']!, _originIdMeta),
      );
    } else if (isInserting) {
      context.missing(_originIdMeta);
    }
    if (data.containsKey('preset')) {
      context.handle(
        _presetMeta,
        preset.isAcceptableOrUnknown(data['preset']!, _presetMeta),
      );
    } else if (isInserting) {
      context.missing(_presetMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('loot')) {
      context.handle(
        _lootMeta,
        loot.isAcceptableOrUnknown(data['loot']!, _lootMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Encounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Encounter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      originId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_id'],
      )!,
      preset: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}preset'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      loot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loot'],
      ),
      combatants: $EncountersTable.$convertercombatantsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}combatants'],
        ),
      ),
      entityIds: $EncountersTable.$converterentityIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_ids'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $EncountersTable createAlias(String alias) {
    return $EncountersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<Map<String, dynamic>>, String, List<dynamic>>
  $convertercombatants = const MapListConverter();
  static JsonTypeConverter2<
    List<Map<String, dynamic>>?,
    String?,
    List<dynamic>?
  >
  $convertercombatantsn = JsonTypeConverter2.asNullable($convertercombatants);
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterentityIds = const StringListConverter();
}

class Encounter extends DataClass implements Insertable<Encounter> {
  final String id;
  final String name;
  final String originId;
  final bool preset;
  final String? notes;
  final String? loot;
  final List<Map<String, dynamic>>? combatants;
  final List<String> entityIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  const Encounter({
    required this.id,
    required this.name,
    required this.originId,
    required this.preset,
    this.notes,
    this.loot,
    this.combatants,
    required this.entityIds,
    this.createdAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['origin_id'] = Variable<String>(originId);
    map['preset'] = Variable<bool>(preset);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || loot != null) {
      map['loot'] = Variable<String>(loot);
    }
    if (!nullToAbsent || combatants != null) {
      map['combatants'] = Variable<String>(
        $EncountersTable.$convertercombatantsn.toSql(combatants),
      );
    }
    {
      map['entity_ids'] = Variable<String>(
        $EncountersTable.$converterentityIds.toSql(entityIds),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  EncountersCompanion toCompanion(bool nullToAbsent) {
    return EncountersCompanion(
      id: Value(id),
      name: Value(name),
      originId: Value(originId),
      preset: Value(preset),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      loot: loot == null && nullToAbsent ? const Value.absent() : Value(loot),
      combatants: combatants == null && nullToAbsent
          ? const Value.absent()
          : Value(combatants),
      entityIds: Value(entityIds),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory Encounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Encounter(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      originId: serializer.fromJson<String>(json['originId']),
      preset: serializer.fromJson<bool>(json['preset']),
      notes: serializer.fromJson<String?>(json['notes']),
      loot: serializer.fromJson<String?>(json['loot']),
      combatants: $EncountersTable.$convertercombatantsn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['combatants']),
      ),
      entityIds: $EncountersTable.$converterentityIds.fromJson(
        serializer.fromJson<List<dynamic>>(json['entityIds']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'originId': serializer.toJson<String>(originId),
      'preset': serializer.toJson<bool>(preset),
      'notes': serializer.toJson<String?>(notes),
      'loot': serializer.toJson<String?>(loot),
      'combatants': serializer.toJson<List<dynamic>?>(
        $EncountersTable.$convertercombatantsn.toJson(combatants),
      ),
      'entityIds': serializer.toJson<List<dynamic>>(
        $EncountersTable.$converterentityIds.toJson(entityIds),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  Encounter copyWith({
    String? id,
    String? name,
    String? originId,
    bool? preset,
    Value<String?> notes = const Value.absent(),
    Value<String?> loot = const Value.absent(),
    Value<List<Map<String, dynamic>>?> combatants = const Value.absent(),
    List<String>? entityIds,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => Encounter(
    id: id ?? this.id,
    name: name ?? this.name,
    originId: originId ?? this.originId,
    preset: preset ?? this.preset,
    notes: notes.present ? notes.value : this.notes,
    loot: loot.present ? loot.value : this.loot,
    combatants: combatants.present ? combatants.value : this.combatants,
    entityIds: entityIds ?? this.entityIds,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  Encounter copyWithCompanion(EncountersCompanion data) {
    return Encounter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      originId: data.originId.present ? data.originId.value : this.originId,
      preset: data.preset.present ? data.preset.value : this.preset,
      notes: data.notes.present ? data.notes.value : this.notes,
      loot: data.loot.present ? data.loot.value : this.loot,
      combatants: data.combatants.present
          ? data.combatants.value
          : this.combatants,
      entityIds: data.entityIds.present ? data.entityIds.value : this.entityIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Encounter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('originId: $originId, ')
          ..write('preset: $preset, ')
          ..write('notes: $notes, ')
          ..write('loot: $loot, ')
          ..write('combatants: $combatants, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    originId,
    preset,
    notes,
    loot,
    combatants,
    entityIds,
    createdAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Encounter &&
          other.id == this.id &&
          other.name == this.name &&
          other.originId == this.originId &&
          other.preset == this.preset &&
          other.notes == this.notes &&
          other.loot == this.loot &&
          other.combatants == this.combatants &&
          other.entityIds == this.entityIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class EncountersCompanion extends UpdateCompanion<Encounter> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> originId;
  final Value<bool> preset;
  final Value<String?> notes;
  final Value<String?> loot;
  final Value<List<Map<String, dynamic>>?> combatants;
  final Value<List<String>> entityIds;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const EncountersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.originId = const Value.absent(),
    this.preset = const Value.absent(),
    this.notes = const Value.absent(),
    this.loot = const Value.absent(),
    this.combatants = const Value.absent(),
    this.entityIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EncountersCompanion.insert({
    required String id,
    required String name,
    required String originId,
    required bool preset,
    this.notes = const Value.absent(),
    this.loot = const Value.absent(),
    this.combatants = const Value.absent(),
    required List<String> entityIds,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       originId = Value(originId),
       preset = Value(preset),
       entityIds = Value(entityIds),
       rev = Value(rev);
  static Insertable<Encounter> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? originId,
    Expression<bool>? preset,
    Expression<String>? notes,
    Expression<String>? loot,
    Expression<String>? combatants,
    Expression<String>? entityIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (originId != null) 'origin_id': originId,
      if (preset != null) 'preset': preset,
      if (notes != null) 'notes': notes,
      if (loot != null) 'loot': loot,
      if (combatants != null) 'combatants': combatants,
      if (entityIds != null) 'entity_ids': entityIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EncountersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? originId,
    Value<bool>? preset,
    Value<String?>? notes,
    Value<String?>? loot,
    Value<List<Map<String, dynamic>>?>? combatants,
    Value<List<String>>? entityIds,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return EncountersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      originId: originId ?? this.originId,
      preset: preset ?? this.preset,
      notes: notes ?? this.notes,
      loot: loot ?? this.loot,
      combatants: combatants ?? this.combatants,
      entityIds: entityIds ?? this.entityIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (originId.present) {
      map['origin_id'] = Variable<String>(originId.value);
    }
    if (preset.present) {
      map['preset'] = Variable<bool>(preset.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (loot.present) {
      map['loot'] = Variable<String>(loot.value);
    }
    if (combatants.present) {
      map['combatants'] = Variable<String>(
        $EncountersTable.$convertercombatantsn.toSql(combatants.value),
      );
    }
    if (entityIds.present) {
      map['entity_ids'] = Variable<String>(
        $EncountersTable.$converterentityIds.toSql(entityIds.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EncountersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('originId: $originId, ')
          ..write('preset: $preset, ')
          ..write('notes: $notes, ')
          ..write('loot: $loot, ')
          ..write('combatants: $combatants, ')
          ..write('entityIds: $entityIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitiesTable extends Entities with TableInfo<$EntitiesTable, Entity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originIdMeta = const VerificationMeta(
    'originId',
  );
  @override
  late final GeneratedColumn<String> originId = GeneratedColumn<String>(
    'origin_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String> tags =
      GeneratedColumn<String>(
        'tags',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<String>?>($EntitiesTable.$convertertagsn);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  statblock = GeneratedColumn<String>(
    'statblock',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($EntitiesTable.$converterstatblock);
  static const VerificationMeta _placeTypeMeta = const VerificationMeta(
    'placeType',
  );
  @override
  late final GeneratedColumn<String> placeType = GeneratedColumn<String>(
    'place_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentPlaceIdMeta = const VerificationMeta(
    'parentPlaceId',
  );
  @override
  late final GeneratedColumn<String> parentPlaceId = GeneratedColumn<String>(
    'parent_place_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  coords = GeneratedColumn<String>(
    'coords',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, dynamic>>($EntitiesTable.$convertercoords);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($EntitiesTable.$convertercontentn);
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>?,
    String
  >
  images =
      GeneratedColumn<String>(
        'images',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<Map<String, dynamic>>?>(
        $EntitiesTable.$converterimagesn,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String> members =
      GeneratedColumn<String>(
        'members',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<String>?>($EntitiesTable.$convertermembersn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    name,
    originId,
    summary,
    tags,
    statblock,
    placeType,
    parentPlaceId,
    coords,
    content,
    images,
    createdAt,
    updatedAt,
    rev,
    deleted,
    members,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('origin_id')) {
      context.handle(
        _originIdMeta,
        originId.isAcceptableOrUnknown(data['origin_id']!, _originIdMeta),
      );
    } else if (isInserting) {
      context.missing(_originIdMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('place_type')) {
      context.handle(
        _placeTypeMeta,
        placeType.isAcceptableOrUnknown(data['place_type']!, _placeTypeMeta),
      );
    }
    if (data.containsKey('parent_place_id')) {
      context.handle(
        _parentPlaceIdMeta,
        parentPlaceId.isAcceptableOrUnknown(
          data['parent_place_id']!,
          _parentPlaceIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      originId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_id'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      tags: $EntitiesTable.$convertertagsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tags'],
        ),
      ),
      statblock: $EntitiesTable.$converterstatblock.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}statblock'],
        )!,
      ),
      placeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_type'],
      ),
      parentPlaceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_place_id'],
      ),
      coords: $EntitiesTable.$convertercoords.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}coords'],
        )!,
      ),
      content: $EntitiesTable.$convertercontentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        ),
      ),
      images: $EntitiesTable.$converterimagesn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}images'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      members: $EntitiesTable.$convertermembersn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}members'],
        ),
      ),
    );
  }

  @override
  $EntitiesTable createAlias(String alias) {
    return $EntitiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertertags = const StringListConverter();
  static JsonTypeConverter2<List<String>?, String?, List<dynamic>?>
  $convertertagsn = JsonTypeConverter2.asNullable($convertertags);
  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $converterstatblock = const MapJsonConverter();
  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $convertercoords = const MapJsonConverter();
  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $convertercontent = quillConv;
  static JsonTypeConverter2<
    Map<String, dynamic>?,
    String?,
    Map<String, dynamic>?
  >
  $convertercontentn = JsonTypeConverter2.asNullable($convertercontent);
  static JsonTypeConverter2<List<Map<String, dynamic>>, String, List<dynamic>>
  $converterimages = const MapListConverter();
  static JsonTypeConverter2<
    List<Map<String, dynamic>>?,
    String?,
    List<dynamic>?
  >
  $converterimagesn = JsonTypeConverter2.asNullable($converterimages);
  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertermembers = const StringListConverter();
  static JsonTypeConverter2<List<String>?, String?, List<dynamic>?>
  $convertermembersn = JsonTypeConverter2.asNullable($convertermembers);
}

class Entity extends DataClass implements Insertable<Entity> {
  final String id;
  final String kind;
  final String name;
  final String originId;
  final String? summary;
  final List<String>? tags;
  final Map<String, dynamic> statblock;
  final String? placeType;
  final String? parentPlaceId;
  final Map<String, dynamic> coords;
  final Map<String, dynamic>? content;
  final List<Map<String, dynamic>>? images;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  final bool deleted;
  final List<String>? members;
  const Entity({
    required this.id,
    required this.kind,
    required this.name,
    required this.originId,
    this.summary,
    this.tags,
    required this.statblock,
    this.placeType,
    this.parentPlaceId,
    required this.coords,
    this.content,
    this.images,
    this.createdAt,
    this.updatedAt,
    required this.rev,
    required this.deleted,
    this.members,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['name'] = Variable<String>(name);
    map['origin_id'] = Variable<String>(originId);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(
        $EntitiesTable.$convertertagsn.toSql(tags),
      );
    }
    {
      map['statblock'] = Variable<String>(
        $EntitiesTable.$converterstatblock.toSql(statblock),
      );
    }
    if (!nullToAbsent || placeType != null) {
      map['place_type'] = Variable<String>(placeType);
    }
    if (!nullToAbsent || parentPlaceId != null) {
      map['parent_place_id'] = Variable<String>(parentPlaceId);
    }
    {
      map['coords'] = Variable<String>(
        $EntitiesTable.$convertercoords.toSql(coords),
      );
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(
        $EntitiesTable.$convertercontentn.toSql(content),
      );
    }
    if (!nullToAbsent || images != null) {
      map['images'] = Variable<String>(
        $EntitiesTable.$converterimagesn.toSql(images),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || members != null) {
      map['members'] = Variable<String>(
        $EntitiesTable.$convertermembersn.toSql(members),
      );
    }
    return map;
  }

  EntitiesCompanion toCompanion(bool nullToAbsent) {
    return EntitiesCompanion(
      id: Value(id),
      kind: Value(kind),
      name: Value(name),
      originId: Value(originId),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      statblock: Value(statblock),
      placeType: placeType == null && nullToAbsent
          ? const Value.absent()
          : Value(placeType),
      parentPlaceId: parentPlaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentPlaceId),
      coords: Value(coords),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      images: images == null && nullToAbsent
          ? const Value.absent()
          : Value(images),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
      deleted: Value(deleted),
      members: members == null && nullToAbsent
          ? const Value.absent()
          : Value(members),
    );
  }

  factory Entity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entity(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      name: serializer.fromJson<String>(json['name']),
      originId: serializer.fromJson<String>(json['originId']),
      summary: serializer.fromJson<String?>(json['summary']),
      tags: $EntitiesTable.$convertertagsn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['tags']),
      ),
      statblock: $EntitiesTable.$converterstatblock.fromJson(
        serializer.fromJson<Map<String, dynamic>>(json['statblock']),
      ),
      placeType: serializer.fromJson<String?>(json['placeType']),
      parentPlaceId: serializer.fromJson<String?>(json['parentPlaceId']),
      coords: $EntitiesTable.$convertercoords.fromJson(
        serializer.fromJson<Map<String, dynamic>>(json['coords']),
      ),
      content: $EntitiesTable.$convertercontentn.fromJson(
        serializer.fromJson<Map<String, dynamic>?>(json['content']),
      ),
      images: $EntitiesTable.$converterimagesn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['images']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      members: $EntitiesTable.$convertermembersn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['members']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'name': serializer.toJson<String>(name),
      'originId': serializer.toJson<String>(originId),
      'summary': serializer.toJson<String?>(summary),
      'tags': serializer.toJson<List<dynamic>?>(
        $EntitiesTable.$convertertagsn.toJson(tags),
      ),
      'statblock': serializer.toJson<Map<String, dynamic>>(
        $EntitiesTable.$converterstatblock.toJson(statblock),
      ),
      'placeType': serializer.toJson<String?>(placeType),
      'parentPlaceId': serializer.toJson<String?>(parentPlaceId),
      'coords': serializer.toJson<Map<String, dynamic>>(
        $EntitiesTable.$convertercoords.toJson(coords),
      ),
      'content': serializer.toJson<Map<String, dynamic>?>(
        $EntitiesTable.$convertercontentn.toJson(content),
      ),
      'images': serializer.toJson<List<dynamic>?>(
        $EntitiesTable.$converterimagesn.toJson(images),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
      'deleted': serializer.toJson<bool>(deleted),
      'members': serializer.toJson<List<dynamic>?>(
        $EntitiesTable.$convertermembersn.toJson(members),
      ),
    };
  }

  Entity copyWith({
    String? id,
    String? kind,
    String? name,
    String? originId,
    Value<String?> summary = const Value.absent(),
    Value<List<String>?> tags = const Value.absent(),
    Map<String, dynamic>? statblock,
    Value<String?> placeType = const Value.absent(),
    Value<String?> parentPlaceId = const Value.absent(),
    Map<String, dynamic>? coords,
    Value<Map<String, dynamic>?> content = const Value.absent(),
    Value<List<Map<String, dynamic>>?> images = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
    bool? deleted,
    Value<List<String>?> members = const Value.absent(),
  }) => Entity(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    originId: originId ?? this.originId,
    summary: summary.present ? summary.value : this.summary,
    tags: tags.present ? tags.value : this.tags,
    statblock: statblock ?? this.statblock,
    placeType: placeType.present ? placeType.value : this.placeType,
    parentPlaceId: parentPlaceId.present
        ? parentPlaceId.value
        : this.parentPlaceId,
    coords: coords ?? this.coords,
    content: content.present ? content.value : this.content,
    images: images.present ? images.value : this.images,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
    deleted: deleted ?? this.deleted,
    members: members.present ? members.value : this.members,
  );
  Entity copyWithCompanion(EntitiesCompanion data) {
    return Entity(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      originId: data.originId.present ? data.originId.value : this.originId,
      summary: data.summary.present ? data.summary.value : this.summary,
      tags: data.tags.present ? data.tags.value : this.tags,
      statblock: data.statblock.present ? data.statblock.value : this.statblock,
      placeType: data.placeType.present ? data.placeType.value : this.placeType,
      parentPlaceId: data.parentPlaceId.present
          ? data.parentPlaceId.value
          : this.parentPlaceId,
      coords: data.coords.present ? data.coords.value : this.coords,
      content: data.content.present ? data.content.value : this.content,
      images: data.images.present ? data.images.value : this.images,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      members: data.members.present ? data.members.value : this.members,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entity(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('originId: $originId, ')
          ..write('summary: $summary, ')
          ..write('tags: $tags, ')
          ..write('statblock: $statblock, ')
          ..write('placeType: $placeType, ')
          ..write('parentPlaceId: $parentPlaceId, ')
          ..write('coords: $coords, ')
          ..write('content: $content, ')
          ..write('images: $images, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('deleted: $deleted, ')
          ..write('members: $members')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    name,
    originId,
    summary,
    tags,
    statblock,
    placeType,
    parentPlaceId,
    coords,
    content,
    images,
    createdAt,
    updatedAt,
    rev,
    deleted,
    members,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entity &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.originId == this.originId &&
          other.summary == this.summary &&
          other.tags == this.tags &&
          other.statblock == this.statblock &&
          other.placeType == this.placeType &&
          other.parentPlaceId == this.parentPlaceId &&
          other.coords == this.coords &&
          other.content == this.content &&
          other.images == this.images &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev &&
          other.deleted == this.deleted &&
          other.members == this.members);
}

class EntitiesCompanion extends UpdateCompanion<Entity> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String> name;
  final Value<String> originId;
  final Value<String?> summary;
  final Value<List<String>?> tags;
  final Value<Map<String, dynamic>> statblock;
  final Value<String?> placeType;
  final Value<String?> parentPlaceId;
  final Value<Map<String, dynamic>> coords;
  final Value<Map<String, dynamic>?> content;
  final Value<List<Map<String, dynamic>>?> images;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<bool> deleted;
  final Value<List<String>?> members;
  final Value<int> rowid;
  const EntitiesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.originId = const Value.absent(),
    this.summary = const Value.absent(),
    this.tags = const Value.absent(),
    this.statblock = const Value.absent(),
    this.placeType = const Value.absent(),
    this.parentPlaceId = const Value.absent(),
    this.coords = const Value.absent(),
    this.content = const Value.absent(),
    this.images = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.deleted = const Value.absent(),
    this.members = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitiesCompanion.insert({
    required String id,
    required String kind,
    required String name,
    required String originId,
    this.summary = const Value.absent(),
    this.tags = const Value.absent(),
    required Map<String, dynamic> statblock,
    this.placeType = const Value.absent(),
    this.parentPlaceId = const Value.absent(),
    required Map<String, dynamic> coords,
    this.content = const Value.absent(),
    this.images = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.deleted = const Value.absent(),
    this.members = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       name = Value(name),
       originId = Value(originId),
       statblock = Value(statblock),
       coords = Value(coords),
       rev = Value(rev);
  static Insertable<Entity> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? originId,
    Expression<String>? summary,
    Expression<String>? tags,
    Expression<String>? statblock,
    Expression<String>? placeType,
    Expression<String>? parentPlaceId,
    Expression<String>? coords,
    Expression<String>? content,
    Expression<String>? images,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<bool>? deleted,
    Expression<String>? members,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (originId != null) 'origin_id': originId,
      if (summary != null) 'summary': summary,
      if (tags != null) 'tags': tags,
      if (statblock != null) 'statblock': statblock,
      if (placeType != null) 'place_type': placeType,
      if (parentPlaceId != null) 'parent_place_id': parentPlaceId,
      if (coords != null) 'coords': coords,
      if (content != null) 'content': content,
      if (images != null) 'images': images,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (deleted != null) 'deleted': deleted,
      if (members != null) 'members': members,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<String>? name,
    Value<String>? originId,
    Value<String?>? summary,
    Value<List<String>?>? tags,
    Value<Map<String, dynamic>>? statblock,
    Value<String?>? placeType,
    Value<String?>? parentPlaceId,
    Value<Map<String, dynamic>>? coords,
    Value<Map<String, dynamic>?>? content,
    Value<List<Map<String, dynamic>>?>? images,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<bool>? deleted,
    Value<List<String>?>? members,
    Value<int>? rowid,
  }) {
    return EntitiesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      originId: originId ?? this.originId,
      summary: summary ?? this.summary,
      tags: tags ?? this.tags,
      statblock: statblock ?? this.statblock,
      placeType: placeType ?? this.placeType,
      parentPlaceId: parentPlaceId ?? this.parentPlaceId,
      coords: coords ?? this.coords,
      content: content ?? this.content,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      deleted: deleted ?? this.deleted,
      members: members ?? this.members,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (originId.present) {
      map['origin_id'] = Variable<String>(originId.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
        $EntitiesTable.$convertertagsn.toSql(tags.value),
      );
    }
    if (statblock.present) {
      map['statblock'] = Variable<String>(
        $EntitiesTable.$converterstatblock.toSql(statblock.value),
      );
    }
    if (placeType.present) {
      map['place_type'] = Variable<String>(placeType.value);
    }
    if (parentPlaceId.present) {
      map['parent_place_id'] = Variable<String>(parentPlaceId.value);
    }
    if (coords.present) {
      map['coords'] = Variable<String>(
        $EntitiesTable.$convertercoords.toSql(coords.value),
      );
    }
    if (content.present) {
      map['content'] = Variable<String>(
        $EntitiesTable.$convertercontentn.toSql(content.value),
      );
    }
    if (images.present) {
      map['images'] = Variable<String>(
        $EntitiesTable.$converterimagesn.toSql(images.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (members.present) {
      map['members'] = Variable<String>(
        $EntitiesTable.$convertermembersn.toSql(members.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('originId: $originId, ')
          ..write('summary: $summary, ')
          ..write('tags: $tags, ')
          ..write('statblock: $statblock, ')
          ..write('placeType: $placeType, ')
          ..write('parentPlaceId: $parentPlaceId, ')
          ..write('coords: $coords, ')
          ..write('content: $content, ')
          ..write('images: $images, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('deleted: $deleted, ')
          ..write('members: $members, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CombatantsTable extends Combatants
    with TableInfo<$CombatantsTable, Combatant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CombatantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encounterIdMeta = const VerificationMeta(
    'encounterId',
  );
  @override
  late final GeneratedColumn<String> encounterId = GeneratedColumn<String>(
    'encounter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES encounters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAllyMeta = const VerificationMeta('isAlly');
  @override
  late final GeneratedColumn<bool> isAlly = GeneratedColumn<bool>(
    'is_ally',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ally" IN (0, 1))',
    ),
  );
  static const VerificationMeta _currentHpMeta = const VerificationMeta(
    'currentHp',
  );
  @override
  late final GeneratedColumn<int> currentHp = GeneratedColumn<int>(
    'current_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxHpMeta = const VerificationMeta('maxHp');
  @override
  late final GeneratedColumn<int> maxHp = GeneratedColumn<int>(
    'max_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _armorClassMeta = const VerificationMeta(
    'armorClass',
  );
  @override
  late final GeneratedColumn<int> armorClass = GeneratedColumn<int>(
    'armor_class',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initiativeMeta = const VerificationMeta(
    'initiative',
  );
  @override
  late final GeneratedColumn<int> initiative = GeneratedColumn<int>(
    'initiative',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initiativeModifierMeta =
      const VerificationMeta('initiativeModifier');
  @override
  late final GeneratedColumn<int> initiativeModifier = GeneratedColumn<int>(
    'initiative_modifier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestiaryNameMeta = const VerificationMeta(
    'bestiaryName',
  );
  @override
  late final GeneratedColumn<String> bestiaryName = GeneratedColumn<String>(
    'bestiary_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _crMeta = const VerificationMeta('cr');
  @override
  late final GeneratedColumn<String> cr = GeneratedColumn<String>(
    'cr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> conditions =
      GeneratedColumn<String>(
        'conditions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($CombatantsTable.$converterconditions);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    encounterId,
    name,
    type,
    isAlly,
    currentHp,
    maxHp,
    armorClass,
    initiative,
    initiativeModifier,
    entityId,
    bestiaryName,
    cr,
    xp,
    conditions,
    notes,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'combatants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Combatant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('encounter_id')) {
      context.handle(
        _encounterIdMeta,
        encounterId.isAcceptableOrUnknown(
          data['encounter_id']!,
          _encounterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encounterIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_ally')) {
      context.handle(
        _isAllyMeta,
        isAlly.isAcceptableOrUnknown(data['is_ally']!, _isAllyMeta),
      );
    } else if (isInserting) {
      context.missing(_isAllyMeta);
    }
    if (data.containsKey('current_hp')) {
      context.handle(
        _currentHpMeta,
        currentHp.isAcceptableOrUnknown(data['current_hp']!, _currentHpMeta),
      );
    } else if (isInserting) {
      context.missing(_currentHpMeta);
    }
    if (data.containsKey('max_hp')) {
      context.handle(
        _maxHpMeta,
        maxHp.isAcceptableOrUnknown(data['max_hp']!, _maxHpMeta),
      );
    } else if (isInserting) {
      context.missing(_maxHpMeta);
    }
    if (data.containsKey('armor_class')) {
      context.handle(
        _armorClassMeta,
        armorClass.isAcceptableOrUnknown(data['armor_class']!, _armorClassMeta),
      );
    } else if (isInserting) {
      context.missing(_armorClassMeta);
    }
    if (data.containsKey('initiative')) {
      context.handle(
        _initiativeMeta,
        initiative.isAcceptableOrUnknown(data['initiative']!, _initiativeMeta),
      );
    }
    if (data.containsKey('initiative_modifier')) {
      context.handle(
        _initiativeModifierMeta,
        initiativeModifier.isAcceptableOrUnknown(
          data['initiative_modifier']!,
          _initiativeModifierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_initiativeModifierMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('bestiary_name')) {
      context.handle(
        _bestiaryNameMeta,
        bestiaryName.isAcceptableOrUnknown(
          data['bestiary_name']!,
          _bestiaryNameMeta,
        ),
      );
    }
    if (data.containsKey('cr')) {
      context.handle(_crMeta, cr.isAcceptableOrUnknown(data['cr']!, _crMeta));
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    } else if (isInserting) {
      context.missing(_xpMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Combatant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Combatant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      encounterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encounter_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isAlly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ally'],
      )!,
      currentHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_hp'],
      )!,
      maxHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_hp'],
      )!,
      armorClass: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}armor_class'],
      )!,
      initiative: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initiative'],
      ),
      initiativeModifier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initiative_modifier'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      bestiaryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bestiary_name'],
      ),
      cr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cr'],
      ),
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      conditions: $CombatantsTable.$converterconditions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}conditions'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $CombatantsTable createAlias(String alias) {
    return $CombatantsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $converterconditions = const StringListConverter();
}

class Combatant extends DataClass implements Insertable<Combatant> {
  final String id;
  final String encounterId;
  final String name;
  final String type;
  final bool isAlly;
  final int currentHp;
  final int maxHp;
  final int armorClass;
  final int? initiative;
  final int initiativeModifier;
  final String? entityId;
  final String? bestiaryName;
  final String? cr;
  final int xp;
  final List<String> conditions;
  final String? notes;
  final int order;
  const Combatant({
    required this.id,
    required this.encounterId,
    required this.name,
    required this.type,
    required this.isAlly,
    required this.currentHp,
    required this.maxHp,
    required this.armorClass,
    this.initiative,
    required this.initiativeModifier,
    this.entityId,
    this.bestiaryName,
    this.cr,
    required this.xp,
    required this.conditions,
    this.notes,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['encounter_id'] = Variable<String>(encounterId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['is_ally'] = Variable<bool>(isAlly);
    map['current_hp'] = Variable<int>(currentHp);
    map['max_hp'] = Variable<int>(maxHp);
    map['armor_class'] = Variable<int>(armorClass);
    if (!nullToAbsent || initiative != null) {
      map['initiative'] = Variable<int>(initiative);
    }
    map['initiative_modifier'] = Variable<int>(initiativeModifier);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    if (!nullToAbsent || bestiaryName != null) {
      map['bestiary_name'] = Variable<String>(bestiaryName);
    }
    if (!nullToAbsent || cr != null) {
      map['cr'] = Variable<String>(cr);
    }
    map['xp'] = Variable<int>(xp);
    {
      map['conditions'] = Variable<String>(
        $CombatantsTable.$converterconditions.toSql(conditions),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['order'] = Variable<int>(order);
    return map;
  }

  CombatantsCompanion toCompanion(bool nullToAbsent) {
    return CombatantsCompanion(
      id: Value(id),
      encounterId: Value(encounterId),
      name: Value(name),
      type: Value(type),
      isAlly: Value(isAlly),
      currentHp: Value(currentHp),
      maxHp: Value(maxHp),
      armorClass: Value(armorClass),
      initiative: initiative == null && nullToAbsent
          ? const Value.absent()
          : Value(initiative),
      initiativeModifier: Value(initiativeModifier),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      bestiaryName: bestiaryName == null && nullToAbsent
          ? const Value.absent()
          : Value(bestiaryName),
      cr: cr == null && nullToAbsent ? const Value.absent() : Value(cr),
      xp: Value(xp),
      conditions: Value(conditions),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      order: Value(order),
    );
  }

  factory Combatant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Combatant(
      id: serializer.fromJson<String>(json['id']),
      encounterId: serializer.fromJson<String>(json['encounterId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      isAlly: serializer.fromJson<bool>(json['isAlly']),
      currentHp: serializer.fromJson<int>(json['currentHp']),
      maxHp: serializer.fromJson<int>(json['maxHp']),
      armorClass: serializer.fromJson<int>(json['armorClass']),
      initiative: serializer.fromJson<int?>(json['initiative']),
      initiativeModifier: serializer.fromJson<int>(json['initiativeModifier']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      bestiaryName: serializer.fromJson<String?>(json['bestiaryName']),
      cr: serializer.fromJson<String?>(json['cr']),
      xp: serializer.fromJson<int>(json['xp']),
      conditions: $CombatantsTable.$converterconditions.fromJson(
        serializer.fromJson<List<dynamic>>(json['conditions']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'encounterId': serializer.toJson<String>(encounterId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'isAlly': serializer.toJson<bool>(isAlly),
      'currentHp': serializer.toJson<int>(currentHp),
      'maxHp': serializer.toJson<int>(maxHp),
      'armorClass': serializer.toJson<int>(armorClass),
      'initiative': serializer.toJson<int?>(initiative),
      'initiativeModifier': serializer.toJson<int>(initiativeModifier),
      'entityId': serializer.toJson<String?>(entityId),
      'bestiaryName': serializer.toJson<String?>(bestiaryName),
      'cr': serializer.toJson<String?>(cr),
      'xp': serializer.toJson<int>(xp),
      'conditions': serializer.toJson<List<dynamic>>(
        $CombatantsTable.$converterconditions.toJson(conditions),
      ),
      'notes': serializer.toJson<String?>(notes),
      'order': serializer.toJson<int>(order),
    };
  }

  Combatant copyWith({
    String? id,
    String? encounterId,
    String? name,
    String? type,
    bool? isAlly,
    int? currentHp,
    int? maxHp,
    int? armorClass,
    Value<int?> initiative = const Value.absent(),
    int? initiativeModifier,
    Value<String?> entityId = const Value.absent(),
    Value<String?> bestiaryName = const Value.absent(),
    Value<String?> cr = const Value.absent(),
    int? xp,
    List<String>? conditions,
    Value<String?> notes = const Value.absent(),
    int? order,
  }) => Combatant(
    id: id ?? this.id,
    encounterId: encounterId ?? this.encounterId,
    name: name ?? this.name,
    type: type ?? this.type,
    isAlly: isAlly ?? this.isAlly,
    currentHp: currentHp ?? this.currentHp,
    maxHp: maxHp ?? this.maxHp,
    armorClass: armorClass ?? this.armorClass,
    initiative: initiative.present ? initiative.value : this.initiative,
    initiativeModifier: initiativeModifier ?? this.initiativeModifier,
    entityId: entityId.present ? entityId.value : this.entityId,
    bestiaryName: bestiaryName.present ? bestiaryName.value : this.bestiaryName,
    cr: cr.present ? cr.value : this.cr,
    xp: xp ?? this.xp,
    conditions: conditions ?? this.conditions,
    notes: notes.present ? notes.value : this.notes,
    order: order ?? this.order,
  );
  Combatant copyWithCompanion(CombatantsCompanion data) {
    return Combatant(
      id: data.id.present ? data.id.value : this.id,
      encounterId: data.encounterId.present
          ? data.encounterId.value
          : this.encounterId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      isAlly: data.isAlly.present ? data.isAlly.value : this.isAlly,
      currentHp: data.currentHp.present ? data.currentHp.value : this.currentHp,
      maxHp: data.maxHp.present ? data.maxHp.value : this.maxHp,
      armorClass: data.armorClass.present
          ? data.armorClass.value
          : this.armorClass,
      initiative: data.initiative.present
          ? data.initiative.value
          : this.initiative,
      initiativeModifier: data.initiativeModifier.present
          ? data.initiativeModifier.value
          : this.initiativeModifier,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      bestiaryName: data.bestiaryName.present
          ? data.bestiaryName.value
          : this.bestiaryName,
      cr: data.cr.present ? data.cr.value : this.cr,
      xp: data.xp.present ? data.xp.value : this.xp,
      conditions: data.conditions.present
          ? data.conditions.value
          : this.conditions,
      notes: data.notes.present ? data.notes.value : this.notes,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Combatant(')
          ..write('id: $id, ')
          ..write('encounterId: $encounterId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('isAlly: $isAlly, ')
          ..write('currentHp: $currentHp, ')
          ..write('maxHp: $maxHp, ')
          ..write('armorClass: $armorClass, ')
          ..write('initiative: $initiative, ')
          ..write('initiativeModifier: $initiativeModifier, ')
          ..write('entityId: $entityId, ')
          ..write('bestiaryName: $bestiaryName, ')
          ..write('cr: $cr, ')
          ..write('xp: $xp, ')
          ..write('conditions: $conditions, ')
          ..write('notes: $notes, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    encounterId,
    name,
    type,
    isAlly,
    currentHp,
    maxHp,
    armorClass,
    initiative,
    initiativeModifier,
    entityId,
    bestiaryName,
    cr,
    xp,
    conditions,
    notes,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Combatant &&
          other.id == this.id &&
          other.encounterId == this.encounterId &&
          other.name == this.name &&
          other.type == this.type &&
          other.isAlly == this.isAlly &&
          other.currentHp == this.currentHp &&
          other.maxHp == this.maxHp &&
          other.armorClass == this.armorClass &&
          other.initiative == this.initiative &&
          other.initiativeModifier == this.initiativeModifier &&
          other.entityId == this.entityId &&
          other.bestiaryName == this.bestiaryName &&
          other.cr == this.cr &&
          other.xp == this.xp &&
          other.conditions == this.conditions &&
          other.notes == this.notes &&
          other.order == this.order);
}

class CombatantsCompanion extends UpdateCompanion<Combatant> {
  final Value<String> id;
  final Value<String> encounterId;
  final Value<String> name;
  final Value<String> type;
  final Value<bool> isAlly;
  final Value<int> currentHp;
  final Value<int> maxHp;
  final Value<int> armorClass;
  final Value<int?> initiative;
  final Value<int> initiativeModifier;
  final Value<String?> entityId;
  final Value<String?> bestiaryName;
  final Value<String?> cr;
  final Value<int> xp;
  final Value<List<String>> conditions;
  final Value<String?> notes;
  final Value<int> order;
  final Value<int> rowid;
  const CombatantsCompanion({
    this.id = const Value.absent(),
    this.encounterId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.isAlly = const Value.absent(),
    this.currentHp = const Value.absent(),
    this.maxHp = const Value.absent(),
    this.armorClass = const Value.absent(),
    this.initiative = const Value.absent(),
    this.initiativeModifier = const Value.absent(),
    this.entityId = const Value.absent(),
    this.bestiaryName = const Value.absent(),
    this.cr = const Value.absent(),
    this.xp = const Value.absent(),
    this.conditions = const Value.absent(),
    this.notes = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CombatantsCompanion.insert({
    required String id,
    required String encounterId,
    required String name,
    required String type,
    required bool isAlly,
    required int currentHp,
    required int maxHp,
    required int armorClass,
    this.initiative = const Value.absent(),
    required int initiativeModifier,
    this.entityId = const Value.absent(),
    this.bestiaryName = const Value.absent(),
    this.cr = const Value.absent(),
    required int xp,
    required List<String> conditions,
    this.notes = const Value.absent(),
    required int order,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       encounterId = Value(encounterId),
       name = Value(name),
       type = Value(type),
       isAlly = Value(isAlly),
       currentHp = Value(currentHp),
       maxHp = Value(maxHp),
       armorClass = Value(armorClass),
       initiativeModifier = Value(initiativeModifier),
       xp = Value(xp),
       conditions = Value(conditions),
       order = Value(order);
  static Insertable<Combatant> custom({
    Expression<String>? id,
    Expression<String>? encounterId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<bool>? isAlly,
    Expression<int>? currentHp,
    Expression<int>? maxHp,
    Expression<int>? armorClass,
    Expression<int>? initiative,
    Expression<int>? initiativeModifier,
    Expression<String>? entityId,
    Expression<String>? bestiaryName,
    Expression<String>? cr,
    Expression<int>? xp,
    Expression<String>? conditions,
    Expression<String>? notes,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (encounterId != null) 'encounter_id': encounterId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (isAlly != null) 'is_ally': isAlly,
      if (currentHp != null) 'current_hp': currentHp,
      if (maxHp != null) 'max_hp': maxHp,
      if (armorClass != null) 'armor_class': armorClass,
      if (initiative != null) 'initiative': initiative,
      if (initiativeModifier != null) 'initiative_modifier': initiativeModifier,
      if (entityId != null) 'entity_id': entityId,
      if (bestiaryName != null) 'bestiary_name': bestiaryName,
      if (cr != null) 'cr': cr,
      if (xp != null) 'xp': xp,
      if (conditions != null) 'conditions': conditions,
      if (notes != null) 'notes': notes,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CombatantsCompanion copyWith({
    Value<String>? id,
    Value<String>? encounterId,
    Value<String>? name,
    Value<String>? type,
    Value<bool>? isAlly,
    Value<int>? currentHp,
    Value<int>? maxHp,
    Value<int>? armorClass,
    Value<int?>? initiative,
    Value<int>? initiativeModifier,
    Value<String?>? entityId,
    Value<String?>? bestiaryName,
    Value<String?>? cr,
    Value<int>? xp,
    Value<List<String>>? conditions,
    Value<String?>? notes,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return CombatantsCompanion(
      id: id ?? this.id,
      encounterId: encounterId ?? this.encounterId,
      name: name ?? this.name,
      type: type ?? this.type,
      isAlly: isAlly ?? this.isAlly,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      armorClass: armorClass ?? this.armorClass,
      initiative: initiative ?? this.initiative,
      initiativeModifier: initiativeModifier ?? this.initiativeModifier,
      entityId: entityId ?? this.entityId,
      bestiaryName: bestiaryName ?? this.bestiaryName,
      cr: cr ?? this.cr,
      xp: xp ?? this.xp,
      conditions: conditions ?? this.conditions,
      notes: notes ?? this.notes,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (encounterId.present) {
      map['encounter_id'] = Variable<String>(encounterId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isAlly.present) {
      map['is_ally'] = Variable<bool>(isAlly.value);
    }
    if (currentHp.present) {
      map['current_hp'] = Variable<int>(currentHp.value);
    }
    if (maxHp.present) {
      map['max_hp'] = Variable<int>(maxHp.value);
    }
    if (armorClass.present) {
      map['armor_class'] = Variable<int>(armorClass.value);
    }
    if (initiative.present) {
      map['initiative'] = Variable<int>(initiative.value);
    }
    if (initiativeModifier.present) {
      map['initiative_modifier'] = Variable<int>(initiativeModifier.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (bestiaryName.present) {
      map['bestiary_name'] = Variable<String>(bestiaryName.value);
    }
    if (cr.present) {
      map['cr'] = Variable<String>(cr.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(
        $CombatantsTable.$converterconditions.toSql(conditions.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CombatantsCompanion(')
          ..write('id: $id, ')
          ..write('encounterId: $encounterId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('isAlly: $isAlly, ')
          ..write('currentHp: $currentHp, ')
          ..write('maxHp: $maxHp, ')
          ..write('armorClass: $armorClass, ')
          ..write('initiative: $initiative, ')
          ..write('initiativeModifier: $initiativeModifier, ')
          ..write('entityId: $entityId, ')
          ..write('bestiaryName: $bestiaryName, ')
          ..write('cr: $cr, ')
          ..write('xp: $xp, ')
          ..write('conditions: $conditions, ')
          ..write('notes: $notes, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaAssetsTable extends MediaAssets
    with TableInfo<$MediaAssetsTable, MediaAsset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaAssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeMeta = const VerificationMeta('mime');
  @override
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String> captions =
      GeneratedColumn<String>(
        'captions',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<String>?>($MediaAssetsTable.$convertercaptionsn);
  static const VerificationMeta _altMeta = const VerificationMeta('alt');
  @override
  late final GeneratedColumn<String> alt = GeneratedColumn<String>(
    'alt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>?,
    String
  >
  variants =
      GeneratedColumn<String>(
        'variants',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<Map<String, dynamic>>?>(
        $MediaAssetsTable.$convertervariantsn,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    filename,
    size,
    mime,
    captions,
    alt,
    variants,
    createdAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaAsset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('mime')) {
      context.handle(
        _mimeMeta,
        mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeMeta);
    }
    if (data.containsKey('alt')) {
      context.handle(
        _altMeta,
        alt.isAcceptableOrUnknown(data['alt']!, _altMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaAsset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaAsset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      )!,
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      )!,
      captions: $MediaAssetsTable.$convertercaptionsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}captions'],
        ),
      ),
      alt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alt'],
      ),
      variants: $MediaAssetsTable.$convertervariantsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}variants'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $MediaAssetsTable createAlias(String alias) {
    return $MediaAssetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, List<dynamic>>
  $convertercaptions = const StringListConverter();
  static JsonTypeConverter2<List<String>?, String?, List<dynamic>?>
  $convertercaptionsn = JsonTypeConverter2.asNullable($convertercaptions);
  static JsonTypeConverter2<List<Map<String, dynamic>>, String, List<dynamic>>
  $convertervariants = const MapListConverter();
  static JsonTypeConverter2<
    List<Map<String, dynamic>>?,
    String?,
    List<dynamic>?
  >
  $convertervariantsn = JsonTypeConverter2.asNullable($convertervariants);
}

class MediaAsset extends DataClass implements Insertable<MediaAsset> {
  final String id;
  final String filename;
  final int size;
  final String mime;
  final List<String>? captions;
  final String? alt;
  final List<Map<String, dynamic>>? variants;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
  const MediaAsset({
    required this.id,
    required this.filename,
    required this.size,
    required this.mime,
    this.captions,
    this.alt,
    this.variants,
    this.createdAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['filename'] = Variable<String>(filename);
    map['size'] = Variable<int>(size);
    map['mime'] = Variable<String>(mime);
    if (!nullToAbsent || captions != null) {
      map['captions'] = Variable<String>(
        $MediaAssetsTable.$convertercaptionsn.toSql(captions),
      );
    }
    if (!nullToAbsent || alt != null) {
      map['alt'] = Variable<String>(alt);
    }
    if (!nullToAbsent || variants != null) {
      map['variants'] = Variable<String>(
        $MediaAssetsTable.$convertervariantsn.toSql(variants),
      );
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  MediaAssetsCompanion toCompanion(bool nullToAbsent) {
    return MediaAssetsCompanion(
      id: Value(id),
      filename: Value(filename),
      size: Value(size),
      mime: Value(mime),
      captions: captions == null && nullToAbsent
          ? const Value.absent()
          : Value(captions),
      alt: alt == null && nullToAbsent ? const Value.absent() : Value(alt),
      variants: variants == null && nullToAbsent
          ? const Value.absent()
          : Value(variants),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory MediaAsset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaAsset(
      id: serializer.fromJson<String>(json['id']),
      filename: serializer.fromJson<String>(json['filename']),
      size: serializer.fromJson<int>(json['size']),
      mime: serializer.fromJson<String>(json['mime']),
      captions: $MediaAssetsTable.$convertercaptionsn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['captions']),
      ),
      alt: serializer.fromJson<String?>(json['alt']),
      variants: $MediaAssetsTable.$convertervariantsn.fromJson(
        serializer.fromJson<List<dynamic>?>(json['variants']),
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'filename': serializer.toJson<String>(filename),
      'size': serializer.toJson<int>(size),
      'mime': serializer.toJson<String>(mime),
      'captions': serializer.toJson<List<dynamic>?>(
        $MediaAssetsTable.$convertercaptionsn.toJson(captions),
      ),
      'alt': serializer.toJson<String?>(alt),
      'variants': serializer.toJson<List<dynamic>?>(
        $MediaAssetsTable.$convertervariantsn.toJson(variants),
      ),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  MediaAsset copyWith({
    String? id,
    String? filename,
    int? size,
    String? mime,
    Value<List<String>?> captions = const Value.absent(),
    Value<String?> alt = const Value.absent(),
    Value<List<Map<String, dynamic>>?> variants = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => MediaAsset(
    id: id ?? this.id,
    filename: filename ?? this.filename,
    size: size ?? this.size,
    mime: mime ?? this.mime,
    captions: captions.present ? captions.value : this.captions,
    alt: alt.present ? alt.value : this.alt,
    variants: variants.present ? variants.value : this.variants,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  MediaAsset copyWithCompanion(MediaAssetsCompanion data) {
    return MediaAsset(
      id: data.id.present ? data.id.value : this.id,
      filename: data.filename.present ? data.filename.value : this.filename,
      size: data.size.present ? data.size.value : this.size,
      mime: data.mime.present ? data.mime.value : this.mime,
      captions: data.captions.present ? data.captions.value : this.captions,
      alt: data.alt.present ? data.alt.value : this.alt,
      variants: data.variants.present ? data.variants.value : this.variants,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaAsset(')
          ..write('id: $id, ')
          ..write('filename: $filename, ')
          ..write('size: $size, ')
          ..write('mime: $mime, ')
          ..write('captions: $captions, ')
          ..write('alt: $alt, ')
          ..write('variants: $variants, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    filename,
    size,
    mime,
    captions,
    alt,
    variants,
    createdAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaAsset &&
          other.id == this.id &&
          other.filename == this.filename &&
          other.size == this.size &&
          other.mime == this.mime &&
          other.captions == this.captions &&
          other.alt == this.alt &&
          other.variants == this.variants &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class MediaAssetsCompanion extends UpdateCompanion<MediaAsset> {
  final Value<String> id;
  final Value<String> filename;
  final Value<int> size;
  final Value<String> mime;
  final Value<List<String>?> captions;
  final Value<String?> alt;
  final Value<List<Map<String, dynamic>>?> variants;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const MediaAssetsCompanion({
    this.id = const Value.absent(),
    this.filename = const Value.absent(),
    this.size = const Value.absent(),
    this.mime = const Value.absent(),
    this.captions = const Value.absent(),
    this.alt = const Value.absent(),
    this.variants = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaAssetsCompanion.insert({
    required String id,
    required String filename,
    required int size,
    required String mime,
    this.captions = const Value.absent(),
    this.alt = const Value.absent(),
    this.variants = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       filename = Value(filename),
       size = Value(size),
       mime = Value(mime),
       rev = Value(rev);
  static Insertable<MediaAsset> custom({
    Expression<String>? id,
    Expression<String>? filename,
    Expression<int>? size,
    Expression<String>? mime,
    Expression<String>? captions,
    Expression<String>? alt,
    Expression<String>? variants,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (filename != null) 'filename': filename,
      if (size != null) 'size': size,
      if (mime != null) 'mime': mime,
      if (captions != null) 'captions': captions,
      if (alt != null) 'alt': alt,
      if (variants != null) 'variants': variants,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaAssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? filename,
    Value<int>? size,
    Value<String>? mime,
    Value<List<String>?>? captions,
    Value<String?>? alt,
    Value<List<Map<String, dynamic>>?>? variants,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return MediaAssetsCompanion(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      size: size ?? this.size,
      mime: mime ?? this.mime,
      captions: captions ?? this.captions,
      alt: alt ?? this.alt,
      variants: variants ?? this.variants,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (captions.present) {
      map['captions'] = Variable<String>(
        $MediaAssetsTable.$convertercaptionsn.toSql(captions.value),
      );
    }
    if (alt.present) {
      map['alt'] = Variable<String>(alt.value);
    }
    if (variants.present) {
      map['variants'] = Variable<String>(
        $MediaAssetsTable.$convertervariantsn.toSql(variants.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaAssetsCompanion(')
          ..write('id: $id, ')
          ..write('filename: $filename, ')
          ..write('size: $size, ')
          ..write('mime: $mime, ')
          ..write('captions: $captions, ')
          ..write('alt: $alt, ')
          ..write('variants: $variants, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  info = GeneratedColumn<String>(
    'info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($SessionsTable.$converterinfon);
  static const VerificationMeta _datetimeMeta = const VerificationMeta(
    'datetime',
  );
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
    'datetime',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  log = GeneratedColumn<String>(
    'log',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($SessionsTable.$converterlogn);
  static const VerificationMeta _shareTokenMeta = const VerificationMeta(
    'shareToken',
  );
  @override
  late final GeneratedColumn<String> shareToken = GeneratedColumn<String>(
    'share_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shareEnabledMeta = const VerificationMeta(
    'shareEnabled',
  );
  @override
  late final GeneratedColumn<bool> shareEnabled = GeneratedColumn<bool>(
    'share_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("share_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _shareExpiresAtMeta = const VerificationMeta(
    'shareExpiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> shareExpiresAt =
      GeneratedColumn<DateTime>(
        'share_expires_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    info,
    datetime,
    log,
    shareToken,
    shareEnabled,
    shareExpiresAt,
    updatedAt,
    rev,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('datetime')) {
      context.handle(
        _datetimeMeta,
        datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta),
      );
    }
    if (data.containsKey('share_token')) {
      context.handle(
        _shareTokenMeta,
        shareToken.isAcceptableOrUnknown(data['share_token']!, _shareTokenMeta),
      );
    }
    if (data.containsKey('share_enabled')) {
      context.handle(
        _shareEnabledMeta,
        shareEnabled.isAcceptableOrUnknown(
          data['share_enabled']!,
          _shareEnabledMeta,
        ),
      );
    }
    if (data.containsKey('share_expires_at')) {
      context.handle(
        _shareExpiresAtMeta,
        shareExpiresAt.isAcceptableOrUnknown(
          data['share_expires_at']!,
          _shareExpiresAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    } else if (isInserting) {
      context.missing(_revMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      info: $SessionsTable.$converterinfon.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}info'],
        ),
      ),
      datetime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}datetime'],
      ),
      log: $SessionsTable.$converterlogn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}log'],
        ),
      ),
      shareToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_token'],
      ),
      shareEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}share_enabled'],
      )!,
      shareExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}share_expires_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $converterinfo = quillConv;
  static JsonTypeConverter2<
    Map<String, dynamic>?,
    String?,
    Map<String, dynamic>?
  >
  $converterinfon = JsonTypeConverter2.asNullable($converterinfo);
  static JsonTypeConverter2<Map<String, dynamic>, String, Map<String, dynamic>>
  $converterlog = quillConv;
  static JsonTypeConverter2<
    Map<String, dynamic>?,
    String?,
    Map<String, dynamic>?
  >
  $converterlogn = JsonTypeConverter2.asNullable($converterlog);
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final DateTime? createdAt;
  final Map<String, dynamic>? info;
  final DateTime? datetime;
  final Map<String, dynamic>? log;
  final String? shareToken;
  final bool shareEnabled;
  final DateTime? shareExpiresAt;
  final DateTime? updatedAt;
  final int rev;
  const Session({
    required this.id,
    this.createdAt,
    this.info,
    this.datetime,
    this.log,
    this.shareToken,
    required this.shareEnabled,
    this.shareExpiresAt,
    this.updatedAt,
    required this.rev,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(
        $SessionsTable.$converterinfon.toSql(info),
      );
    }
    if (!nullToAbsent || datetime != null) {
      map['datetime'] = Variable<DateTime>(datetime);
    }
    if (!nullToAbsent || log != null) {
      map['log'] = Variable<String>($SessionsTable.$converterlogn.toSql(log));
    }
    if (!nullToAbsent || shareToken != null) {
      map['share_token'] = Variable<String>(shareToken);
    }
    map['share_enabled'] = Variable<bool>(shareEnabled);
    if (!nullToAbsent || shareExpiresAt != null) {
      map['share_expires_at'] = Variable<DateTime>(shareExpiresAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['rev'] = Variable<int>(rev);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      info: info == null && nullToAbsent ? const Value.absent() : Value(info),
      datetime: datetime == null && nullToAbsent
          ? const Value.absent()
          : Value(datetime),
      log: log == null && nullToAbsent ? const Value.absent() : Value(log),
      shareToken: shareToken == null && nullToAbsent
          ? const Value.absent()
          : Value(shareToken),
      shareEnabled: Value(shareEnabled),
      shareExpiresAt: shareExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(shareExpiresAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      rev: Value(rev),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      info: $SessionsTable.$converterinfon.fromJson(
        serializer.fromJson<Map<String, dynamic>?>(json['info']),
      ),
      datetime: serializer.fromJson<DateTime?>(json['datetime']),
      log: $SessionsTable.$converterlogn.fromJson(
        serializer.fromJson<Map<String, dynamic>?>(json['log']),
      ),
      shareToken: serializer.fromJson<String?>(json['shareToken']),
      shareEnabled: serializer.fromJson<bool>(json['shareEnabled']),
      shareExpiresAt: serializer.fromJson<DateTime?>(json['shareExpiresAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      rev: serializer.fromJson<int>(json['rev']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'info': serializer.toJson<Map<String, dynamic>?>(
        $SessionsTable.$converterinfon.toJson(info),
      ),
      'datetime': serializer.toJson<DateTime?>(datetime),
      'log': serializer.toJson<Map<String, dynamic>?>(
        $SessionsTable.$converterlogn.toJson(log),
      ),
      'shareToken': serializer.toJson<String?>(shareToken),
      'shareEnabled': serializer.toJson<bool>(shareEnabled),
      'shareExpiresAt': serializer.toJson<DateTime?>(shareExpiresAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'rev': serializer.toJson<int>(rev),
    };
  }

  Session copyWith({
    String? id,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<Map<String, dynamic>?> info = const Value.absent(),
    Value<DateTime?> datetime = const Value.absent(),
    Value<Map<String, dynamic>?> log = const Value.absent(),
    Value<String?> shareToken = const Value.absent(),
    bool? shareEnabled,
    Value<DateTime?> shareExpiresAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    int? rev,
  }) => Session(
    id: id ?? this.id,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    info: info.present ? info.value : this.info,
    datetime: datetime.present ? datetime.value : this.datetime,
    log: log.present ? log.value : this.log,
    shareToken: shareToken.present ? shareToken.value : this.shareToken,
    shareEnabled: shareEnabled ?? this.shareEnabled,
    shareExpiresAt: shareExpiresAt.present
        ? shareExpiresAt.value
        : this.shareExpiresAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    rev: rev ?? this.rev,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      info: data.info.present ? data.info.value : this.info,
      datetime: data.datetime.present ? data.datetime.value : this.datetime,
      log: data.log.present ? data.log.value : this.log,
      shareToken: data.shareToken.present
          ? data.shareToken.value
          : this.shareToken,
      shareEnabled: data.shareEnabled.present
          ? data.shareEnabled.value
          : this.shareEnabled,
      shareExpiresAt: data.shareExpiresAt.present
          ? data.shareExpiresAt.value
          : this.shareExpiresAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      rev: data.rev.present ? data.rev.value : this.rev,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('info: $info, ')
          ..write('datetime: $datetime, ')
          ..write('log: $log, ')
          ..write('shareToken: $shareToken, ')
          ..write('shareEnabled: $shareEnabled, ')
          ..write('shareExpiresAt: $shareExpiresAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    info,
    datetime,
    log,
    shareToken,
    shareEnabled,
    shareExpiresAt,
    updatedAt,
    rev,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.info == this.info &&
          other.datetime == this.datetime &&
          other.log == this.log &&
          other.shareToken == this.shareToken &&
          other.shareEnabled == this.shareEnabled &&
          other.shareExpiresAt == this.shareExpiresAt &&
          other.updatedAt == this.updatedAt &&
          other.rev == this.rev);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<DateTime?> createdAt;
  final Value<Map<String, dynamic>?> info;
  final Value<DateTime?> datetime;
  final Value<Map<String, dynamic>?> log;
  final Value<String?> shareToken;
  final Value<bool> shareEnabled;
  final Value<DateTime?> shareExpiresAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rev;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.info = const Value.absent(),
    this.datetime = const Value.absent(),
    this.log = const Value.absent(),
    this.shareToken = const Value.absent(),
    this.shareEnabled = const Value.absent(),
    this.shareExpiresAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rev = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.info = const Value.absent(),
    this.datetime = const Value.absent(),
    this.log = const Value.absent(),
    this.shareToken = const Value.absent(),
    this.shareEnabled = const Value.absent(),
    this.shareExpiresAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int rev,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rev = Value(rev);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? info,
    Expression<DateTime>? datetime,
    Expression<String>? log,
    Expression<String>? shareToken,
    Expression<bool>? shareEnabled,
    Expression<DateTime>? shareExpiresAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rev,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (info != null) 'info': info,
      if (datetime != null) 'datetime': datetime,
      if (log != null) 'log': log,
      if (shareToken != null) 'share_token': shareToken,
      if (shareEnabled != null) 'share_enabled': shareEnabled,
      if (shareExpiresAt != null) 'share_expires_at': shareExpiresAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rev != null) 'rev': rev,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime?>? createdAt,
    Value<Map<String, dynamic>?>? info,
    Value<DateTime?>? datetime,
    Value<Map<String, dynamic>?>? log,
    Value<String?>? shareToken,
    Value<bool>? shareEnabled,
    Value<DateTime?>? shareExpiresAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rev,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      info: info ?? this.info,
      datetime: datetime ?? this.datetime,
      log: log ?? this.log,
      shareToken: shareToken ?? this.shareToken,
      shareEnabled: shareEnabled ?? this.shareEnabled,
      shareExpiresAt: shareExpiresAt ?? this.shareExpiresAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(
        $SessionsTable.$converterinfon.toSql(info.value),
      );
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (log.present) {
      map['log'] = Variable<String>(
        $SessionsTable.$converterlogn.toSql(log.value),
      );
    }
    if (shareToken.present) {
      map['share_token'] = Variable<String>(shareToken.value);
    }
    if (shareEnabled.present) {
      map['share_enabled'] = Variable<bool>(shareEnabled.value);
    }
    if (shareExpiresAt.present) {
      map['share_expires_at'] = Variable<DateTime>(shareExpiresAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('info: $info, ')
          ..write('datetime: $datetime, ')
          ..write('log: $log, ')
          ..write('shareToken: $shareToken, ')
          ..write('shareEnabled: $shareEnabled, ')
          ..write('shareExpiresAt: $shareExpiresAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rev: $rev, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumn<String> table = GeneratedColumn<String>(
    'table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    table,
    rowId,
    op,
    changedAt,
    payload,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('table')) {
      context.handle(
        _tableMeta,
        table.isAcceptableOrUnknown(data['table']!, _tableMeta),
      );
    } else if (isInserting) {
      context.missing(_tableMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      table: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final String id;
  final String table;
  final String rowId;
  final String op;
  final DateTime changedAt;
  final String? payload;
  const OutboxEntry({
    required this.id,
    required this.table,
    required this.rowId,
    required this.op,
    required this.changedAt,
    this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['table'] = Variable<String>(table);
    map['row_id'] = Variable<String>(rowId);
    map['op'] = Variable<String>(op);
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      table: Value(table),
      rowId: Value(rowId),
      op: Value(op),
      changedAt: Value(changedAt),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<String>(json['id']),
      table: serializer.fromJson<String>(json['table']),
      rowId: serializer.fromJson<String>(json['rowId']),
      op: serializer.fromJson<String>(json['op']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      payload: serializer.fromJson<String?>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'table': serializer.toJson<String>(table),
      'rowId': serializer.toJson<String>(rowId),
      'op': serializer.toJson<String>(op),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'payload': serializer.toJson<String?>(payload),
    };
  }

  OutboxEntry copyWith({
    String? id,
    String? table,
    String? rowId,
    String? op,
    DateTime? changedAt,
    Value<String?> payload = const Value.absent(),
  }) => OutboxEntry(
    id: id ?? this.id,
    table: table ?? this.table,
    rowId: rowId ?? this.rowId,
    op: op ?? this.op,
    changedAt: changedAt ?? this.changedAt,
    payload: payload.present ? payload.value : this.payload,
  );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      table: data.table.present ? data.table.value : this.table,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      op: data.op.present ? data.op.value : this.op,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('changedAt: $changedAt, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, table, rowId, op, changedAt, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.table == this.table &&
          other.rowId == this.rowId &&
          other.op == this.op &&
          other.changedAt == this.changedAt &&
          other.payload == this.payload);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<String> id;
  final Value<String> table;
  final Value<String> rowId;
  final Value<String> op;
  final Value<DateTime> changedAt;
  final Value<String?> payload;
  final Value<int> rowid;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.table = const Value.absent(),
    this.rowId = const Value.absent(),
    this.op = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    required String id,
    required String table,
    required String rowId,
    required String op,
    required DateTime changedAt,
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       table = Value(table),
       rowId = Value(rowId),
       op = Value(op),
       changedAt = Value(changedAt);
  static Insertable<OutboxEntry> custom({
    Expression<String>? id,
    Expression<String>? table,
    Expression<String>? rowId,
    Expression<String>? op,
    Expression<DateTime>? changedAt,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (table != null) 'table': table,
      if (rowId != null) 'row_id': rowId,
      if (op != null) 'op': op,
      if (changedAt != null) 'changed_at': changedAt,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? table,
    Value<String>? rowId,
    Value<String>? op,
    Value<DateTime>? changedAt,
    Value<String?>? payload,
    Value<int>? rowid,
  }) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      table: table ?? this.table,
      rowId: rowId ?? this.rowId,
      op: op ?? this.op,
      changedAt: changedAt ?? this.changedAt,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (table.present) {
      map['table'] = Variable<String>(table.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('rowId: $rowId, ')
          ..write('op: $op, ')
          ..write('changedAt: $changedAt, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $CampaignsTable campaigns = $CampaignsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $AdventuresTable adventures = $AdventuresTable(this);
  late final $ScenesTable scenes = $ScenesTable(this);
  late final $PartiesTable parties = $PartiesTable(this);
  late final $EncountersTable encounters = $EncountersTable(this);
  late final $EntitiesTable entities = $EntitiesTable(this);
  late final $CombatantsTable combatants = $CombatantsTable(this);
  late final $MediaAssetsTable mediaAssets = $MediaAssetsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final CampaignDao campaignDao = CampaignDao(this as AppDb);
  late final ChapterDao chapterDao = ChapterDao(this as AppDb);
  late final AdventureDao adventureDao = AdventureDao(this as AppDb);
  late final SceneDao sceneDao = SceneDao(this as AppDb);
  late final PartyDao partyDao = PartyDao(this as AppDb);
  late final EncounterDao encounterDao = EncounterDao(this as AppDb);
  late final EntityDao entityDao = EntityDao(this as AppDb);
  late final CombatantDao combatantDao = CombatantDao(this as AppDb);
  late final MediaAssetDao mediaAssetDao = MediaAssetDao(this as AppDb);
  late final SessionDao sessionDao = SessionDao(this as AppDb);
  late final OutboxDao outboxDao = OutboxDao(this as AppDb);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    campaigns,
    chapters,
    adventures,
    scenes,
    parties,
    encounters,
    entities,
    combatants,
    mediaAssets,
    sessions,
    outboxEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'campaigns',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chapters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chapters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('adventures', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'adventures',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scenes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'campaigns',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('parties', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'encounters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('combatants', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CampaignsTableCreateCompanionBuilder =
    CampaignsCompanion Function({
      required String id,
      required String name,
      required String description,
      Value<Map<String, dynamic>?> content,
      Value<String?> ownerUid,
      Value<List<String>?> memberUids,
      required List<String> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$CampaignsTableUpdateCompanionBuilder =
    CampaignsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<Map<String, dynamic>?> content,
      Value<String?> ownerUid,
      Value<List<String>?> memberUids,
      Value<List<String>> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

final class $$CampaignsTableReferences
    extends BaseReferences<_$AppDb, $CampaignsTable, Campaign> {
  $$CampaignsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: $_aliasNameGenerator(db.campaigns.id, db.chapters.campaignId),
  );

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.campaignId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartiesTable, List<Party>> _partiesRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.parties,
    aliasName: $_aliasNameGenerator(db.campaigns.id, db.parties.campaignId),
  );

  $$PartiesTableProcessedTableManager get partiesRefs {
    final manager = $$PartiesTableTableManager(
      $_db,
      $_db.parties,
    ).filter((f) => f.campaignId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_partiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CampaignsTableFilterComposer
    extends Composer<_$AppDb, $CampaignsTable> {
  $$CampaignsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get memberUids => $composableBuilder(
    column: $table.memberUids,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($$ChaptersTableFilterComposer f) f,
  ) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.campaignId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partiesRefs(
    Expression<bool> Function($$PartiesTableFilterComposer f) f,
  ) {
    final $$PartiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.campaignId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableFilterComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CampaignsTableOrderingComposer
    extends Composer<_$AppDb, $CampaignsTable> {
  $$CampaignsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberUids => $composableBuilder(
    column: $table.memberUids,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CampaignsTableAnnotationComposer
    extends Composer<_$AppDb, $CampaignsTable> {
  $$CampaignsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get memberUids =>
      $composableBuilder(
        column: $table.memberUids,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get entityIds =>
      $composableBuilder(column: $table.entityIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.campaignId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partiesRefs<T extends Object>(
    Expression<T> Function($$PartiesTableAnnotationComposer a) f,
  ) {
    final $$PartiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parties,
      getReferencedColumn: (t) => t.campaignId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartiesTableAnnotationComposer(
            $db: $db,
            $table: $db.parties,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CampaignsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $CampaignsTable,
          Campaign,
          $$CampaignsTableFilterComposer,
          $$CampaignsTableOrderingComposer,
          $$CampaignsTableAnnotationComposer,
          $$CampaignsTableCreateCompanionBuilder,
          $$CampaignsTableUpdateCompanionBuilder,
          (Campaign, $$CampaignsTableReferences),
          Campaign,
          PrefetchHooks Function({bool chaptersRefs, bool partiesRefs})
        > {
  $$CampaignsTableTableManager(_$AppDb db, $CampaignsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CampaignsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CampaignsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CampaignsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                Value<String?> ownerUid = const Value.absent(),
                Value<List<String>?> memberUids = const Value.absent(),
                Value<List<String>> entityIds = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CampaignsCompanion(
                id: id,
                name: name,
                description: description,
                content: content,
                ownerUid: ownerUid,
                memberUids: memberUids,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String description,
                Value<Map<String, dynamic>?> content = const Value.absent(),
                Value<String?> ownerUid = const Value.absent(),
                Value<List<String>?> memberUids = const Value.absent(),
                required List<String> entityIds,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => CampaignsCompanion.insert(
                id: id,
                name: name,
                description: description,
                content: content,
                ownerUid: ownerUid,
                memberUids: memberUids,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CampaignsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chaptersRefs = false, partiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chaptersRefs) db.chapters,
                if (partiesRefs) db.parties,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chaptersRefs)
                    await $_getPrefetchedData<
                      Campaign,
                      $CampaignsTable,
                      Chapter
                    >(
                      currentTable: table,
                      referencedTable: $$CampaignsTableReferences
                          ._chaptersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CampaignsTableReferences(
                            db,
                            table,
                            p0,
                          ).chaptersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.campaignId == item.id),
                      typedResults: items,
                    ),
                  if (partiesRefs)
                    await $_getPrefetchedData<Campaign, $CampaignsTable, Party>(
                      currentTable: table,
                      referencedTable: $$CampaignsTableReferences
                          ._partiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CampaignsTableReferences(db, table, p0).partiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.campaignId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CampaignsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $CampaignsTable,
      Campaign,
      $$CampaignsTableFilterComposer,
      $$CampaignsTableOrderingComposer,
      $$CampaignsTableAnnotationComposer,
      $$CampaignsTableCreateCompanionBuilder,
      $$CampaignsTableUpdateCompanionBuilder,
      (Campaign, $$CampaignsTableReferences),
      Campaign,
      PrefetchHooks Function({bool chaptersRefs, bool partiesRefs})
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      required String id,
      required String campaignId,
      required String name,
      required int order,
      Value<String?> summary,
      Value<Map<String, dynamic>?> content,
      required List<String> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<String> id,
      Value<String> campaignId,
      Value<String> name,
      Value<int> order,
      Value<String?> summary,
      Value<Map<String, dynamic>?> content,
      Value<List<String>> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDb, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CampaignsTable _campaignIdTable(_$AppDb db) =>
      db.campaigns.createAlias(
        $_aliasNameGenerator(db.chapters.campaignId, db.campaigns.id),
      );

  $$CampaignsTableProcessedTableManager get campaignId {
    final $_column = $_itemColumn<String>('campaign_id')!;

    final manager = $$CampaignsTableTableManager(
      $_db,
      $_db.campaigns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campaignIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AdventuresTable, List<Adventure>>
  _adventuresRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.adventures,
    aliasName: $_aliasNameGenerator(db.chapters.id, db.adventures.chapterId),
  );

  $$AdventuresTableProcessedTableManager get adventuresRefs {
    final manager = $$AdventuresTableTableManager(
      $_db,
      $_db.adventures,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_adventuresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChaptersTableFilterComposer extends Composer<_$AppDb, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  $$CampaignsTableFilterComposer get campaignId {
    final $$CampaignsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campaignId,
      referencedTable: $db.campaigns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampaignsTableFilterComposer(
            $db: $db,
            $table: $db.campaigns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> adventuresRefs(
    Expression<bool> Function($$AdventuresTableFilterComposer f) f,
  ) {
    final $$AdventuresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adventures,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdventuresTableFilterComposer(
            $db: $db,
            $table: $db.adventures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDb, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampaignsTableOrderingComposer get campaignId {
    final $$CampaignsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campaignId,
      referencedTable: $db.campaigns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampaignsTableOrderingComposer(
            $db: $db,
            $table: $db.campaigns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDb, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get entityIds =>
      $composableBuilder(column: $table.entityIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  $$CampaignsTableAnnotationComposer get campaignId {
    final $$CampaignsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campaignId,
      referencedTable: $db.campaigns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampaignsTableAnnotationComposer(
            $db: $db,
            $table: $db.campaigns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> adventuresRefs<T extends Object>(
    Expression<T> Function($$AdventuresTableAnnotationComposer a) f,
  ) {
    final $$AdventuresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.adventures,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdventuresTableAnnotationComposer(
            $db: $db,
            $table: $db.adventures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, $$ChaptersTableReferences),
          Chapter,
          PrefetchHooks Function({bool campaignId, bool adventuresRefs})
        > {
  $$ChaptersTableTableManager(_$AppDb db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> campaignId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                Value<List<String>> entityIds = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                campaignId: campaignId,
                name: name,
                order: order,
                summary: summary,
                content: content,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String campaignId,
                required String name,
                required int order,
                Value<String?> summary = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                required List<String> entityIds,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                campaignId: campaignId,
                name: name,
                order: order,
                summary: summary,
                content: content,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({campaignId = false, adventuresRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (adventuresRefs) db.adventures],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (campaignId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.campaignId,
                                    referencedTable: $$ChaptersTableReferences
                                        ._campaignIdTable(db),
                                    referencedColumn: $$ChaptersTableReferences
                                        ._campaignIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (adventuresRefs)
                        await $_getPrefetchedData<
                          Chapter,
                          $ChaptersTable,
                          Adventure
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableReferences
                              ._adventuresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableReferences(
                                db,
                                table,
                                p0,
                              ).adventuresRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, $$ChaptersTableReferences),
      Chapter,
      PrefetchHooks Function({bool campaignId, bool adventuresRefs})
    >;
typedef $$AdventuresTableCreateCompanionBuilder =
    AdventuresCompanion Function({
      required String id,
      required String chapterId,
      required String name,
      required int order,
      Value<String?> summary,
      Value<Map<String, dynamic>?> content,
      required List<String> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$AdventuresTableUpdateCompanionBuilder =
    AdventuresCompanion Function({
      Value<String> id,
      Value<String> chapterId,
      Value<String> name,
      Value<int> order,
      Value<String?> summary,
      Value<Map<String, dynamic>?> content,
      Value<List<String>> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

final class $$AdventuresTableReferences
    extends BaseReferences<_$AppDb, $AdventuresTable, Adventure> {
  $$AdventuresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChaptersTable _chapterIdTable(_$AppDb db) => db.chapters.createAlias(
    $_aliasNameGenerator(db.adventures.chapterId, db.chapters.id),
  );

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ScenesTable, List<Scene>> _scenesRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.scenes,
    aliasName: $_aliasNameGenerator(db.adventures.id, db.scenes.adventureId),
  );

  $$ScenesTableProcessedTableManager get scenesRefs {
    final manager = $$ScenesTableTableManager(
      $_db,
      $_db.scenes,
    ).filter((f) => f.adventureId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scenesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AdventuresTableFilterComposer
    extends Composer<_$AppDb, $AdventuresTable> {
  $$AdventuresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> scenesRefs(
    Expression<bool> Function($$ScenesTableFilterComposer f) f,
  ) {
    final $$ScenesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scenes,
      getReferencedColumn: (t) => t.adventureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenesTableFilterComposer(
            $db: $db,
            $table: $db.scenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AdventuresTableOrderingComposer
    extends Composer<_$AppDb, $AdventuresTable> {
  $$AdventuresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AdventuresTableAnnotationComposer
    extends Composer<_$AppDb, $AdventuresTable> {
  $$AdventuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get entityIds =>
      $composableBuilder(column: $table.entityIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> scenesRefs<T extends Object>(
    Expression<T> Function($$ScenesTableAnnotationComposer a) f,
  ) {
    final $$ScenesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scenes,
      getReferencedColumn: (t) => t.adventureId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScenesTableAnnotationComposer(
            $db: $db,
            $table: $db.scenes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AdventuresTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $AdventuresTable,
          Adventure,
          $$AdventuresTableFilterComposer,
          $$AdventuresTableOrderingComposer,
          $$AdventuresTableAnnotationComposer,
          $$AdventuresTableCreateCompanionBuilder,
          $$AdventuresTableUpdateCompanionBuilder,
          (Adventure, $$AdventuresTableReferences),
          Adventure,
          PrefetchHooks Function({bool chapterId, bool scenesRefs})
        > {
  $$AdventuresTableTableManager(_$AppDb db, $AdventuresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdventuresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdventuresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdventuresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                Value<List<String>> entityIds = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdventuresCompanion(
                id: id,
                chapterId: chapterId,
                name: name,
                order: order,
                summary: summary,
                content: content,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                required String name,
                required int order,
                Value<String?> summary = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                required List<String> entityIds,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => AdventuresCompanion.insert(
                id: id,
                chapterId: chapterId,
                name: name,
                order: order,
                summary: summary,
                content: content,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AdventuresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chapterId = false, scenesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (scenesRefs) db.scenes],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable: $$AdventuresTableReferences
                                    ._chapterIdTable(db),
                                referencedColumn: $$AdventuresTableReferences
                                    ._chapterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (scenesRefs)
                    await $_getPrefetchedData<
                      Adventure,
                      $AdventuresTable,
                      Scene
                    >(
                      currentTable: table,
                      referencedTable: $$AdventuresTableReferences
                          ._scenesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AdventuresTableReferences(db, table, p0).scenesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.adventureId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AdventuresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $AdventuresTable,
      Adventure,
      $$AdventuresTableFilterComposer,
      $$AdventuresTableOrderingComposer,
      $$AdventuresTableAnnotationComposer,
      $$AdventuresTableCreateCompanionBuilder,
      $$AdventuresTableUpdateCompanionBuilder,
      (Adventure, $$AdventuresTableReferences),
      Adventure,
      PrefetchHooks Function({bool chapterId, bool scenesRefs})
    >;
typedef $$ScenesTableCreateCompanionBuilder =
    ScenesCompanion Function({
      required String id,
      required String adventureId,
      required String name,
      required int order,
      Value<String?> summary,
      Value<Map<String, dynamic>?> content,
      required List<String> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$ScenesTableUpdateCompanionBuilder =
    ScenesCompanion Function({
      Value<String> id,
      Value<String> adventureId,
      Value<String> name,
      Value<int> order,
      Value<String?> summary,
      Value<Map<String, dynamic>?> content,
      Value<List<String>> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

final class $$ScenesTableReferences
    extends BaseReferences<_$AppDb, $ScenesTable, Scene> {
  $$ScenesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AdventuresTable _adventureIdTable(_$AppDb db) =>
      db.adventures.createAlias(
        $_aliasNameGenerator(db.scenes.adventureId, db.adventures.id),
      );

  $$AdventuresTableProcessedTableManager get adventureId {
    final $_column = $_itemColumn<String>('adventure_id')!;

    final manager = $$AdventuresTableTableManager(
      $_db,
      $_db.adventures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_adventureIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScenesTableFilterComposer extends Composer<_$AppDb, $ScenesTable> {
  $$ScenesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  $$AdventuresTableFilterComposer get adventureId {
    final $$AdventuresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.adventureId,
      referencedTable: $db.adventures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdventuresTableFilterComposer(
            $db: $db,
            $table: $db.adventures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScenesTableOrderingComposer extends Composer<_$AppDb, $ScenesTable> {
  $$ScenesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  $$AdventuresTableOrderingComposer get adventureId {
    final $$AdventuresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.adventureId,
      referencedTable: $db.adventures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdventuresTableOrderingComposer(
            $db: $db,
            $table: $db.adventures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScenesTableAnnotationComposer extends Composer<_$AppDb, $ScenesTable> {
  $$ScenesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get entityIds =>
      $composableBuilder(column: $table.entityIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  $$AdventuresTableAnnotationComposer get adventureId {
    final $$AdventuresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.adventureId,
      referencedTable: $db.adventures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AdventuresTableAnnotationComposer(
            $db: $db,
            $table: $db.adventures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScenesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ScenesTable,
          Scene,
          $$ScenesTableFilterComposer,
          $$ScenesTableOrderingComposer,
          $$ScenesTableAnnotationComposer,
          $$ScenesTableCreateCompanionBuilder,
          $$ScenesTableUpdateCompanionBuilder,
          (Scene, $$ScenesTableReferences),
          Scene,
          PrefetchHooks Function({bool adventureId})
        > {
  $$ScenesTableTableManager(_$AppDb db, $ScenesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScenesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScenesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScenesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> adventureId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                Value<List<String>> entityIds = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScenesCompanion(
                id: id,
                adventureId: adventureId,
                name: name,
                order: order,
                summary: summary,
                content: content,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String adventureId,
                required String name,
                required int order,
                Value<String?> summary = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                required List<String> entityIds,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => ScenesCompanion.insert(
                id: id,
                adventureId: adventureId,
                name: name,
                order: order,
                summary: summary,
                content: content,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ScenesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({adventureId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (adventureId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.adventureId,
                                referencedTable: $$ScenesTableReferences
                                    ._adventureIdTable(db),
                                referencedColumn: $$ScenesTableReferences
                                    ._adventureIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScenesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ScenesTable,
      Scene,
      $$ScenesTableFilterComposer,
      $$ScenesTableOrderingComposer,
      $$ScenesTableAnnotationComposer,
      $$ScenesTableCreateCompanionBuilder,
      $$ScenesTableUpdateCompanionBuilder,
      (Scene, $$ScenesTableReferences),
      Scene,
      PrefetchHooks Function({bool adventureId})
    >;
typedef $$PartiesTableCreateCompanionBuilder =
    PartiesCompanion Function({
      required String id,
      required String campaignId,
      required String name,
      Value<String?> summary,
      Value<List<String>?> memberEntityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$PartiesTableUpdateCompanionBuilder =
    PartiesCompanion Function({
      Value<String> id,
      Value<String> campaignId,
      Value<String> name,
      Value<String?> summary,
      Value<List<String>?> memberEntityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

final class $$PartiesTableReferences
    extends BaseReferences<_$AppDb, $PartiesTable, Party> {
  $$PartiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CampaignsTable _campaignIdTable(_$AppDb db) =>
      db.campaigns.createAlias(
        $_aliasNameGenerator(db.parties.campaignId, db.campaigns.id),
      );

  $$CampaignsTableProcessedTableManager get campaignId {
    final $_column = $_itemColumn<String>('campaign_id')!;

    final manager = $$CampaignsTableTableManager(
      $_db,
      $_db.campaigns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campaignIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PartiesTableFilterComposer extends Composer<_$AppDb, $PartiesTable> {
  $$PartiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get memberEntityIds => $composableBuilder(
    column: $table.memberEntityIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  $$CampaignsTableFilterComposer get campaignId {
    final $$CampaignsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campaignId,
      referencedTable: $db.campaigns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampaignsTableFilterComposer(
            $db: $db,
            $table: $db.campaigns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartiesTableOrderingComposer extends Composer<_$AppDb, $PartiesTable> {
  $$PartiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberEntityIds => $composableBuilder(
    column: $table.memberEntityIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampaignsTableOrderingComposer get campaignId {
    final $$CampaignsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campaignId,
      referencedTable: $db.campaigns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampaignsTableOrderingComposer(
            $db: $db,
            $table: $db.campaigns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartiesTableAnnotationComposer
    extends Composer<_$AppDb, $PartiesTable> {
  $$PartiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get memberEntityIds =>
      $composableBuilder(
        column: $table.memberEntityIds,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  $$CampaignsTableAnnotationComposer get campaignId {
    final $$CampaignsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campaignId,
      referencedTable: $db.campaigns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampaignsTableAnnotationComposer(
            $db: $db,
            $table: $db.campaigns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartiesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $PartiesTable,
          Party,
          $$PartiesTableFilterComposer,
          $$PartiesTableOrderingComposer,
          $$PartiesTableAnnotationComposer,
          $$PartiesTableCreateCompanionBuilder,
          $$PartiesTableUpdateCompanionBuilder,
          (Party, $$PartiesTableReferences),
          Party,
          PrefetchHooks Function({bool campaignId})
        > {
  $$PartiesTableTableManager(_$AppDb db, $PartiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> campaignId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<List<String>?> memberEntityIds = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartiesCompanion(
                id: id,
                campaignId: campaignId,
                name: name,
                summary: summary,
                memberEntityIds: memberEntityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String campaignId,
                required String name,
                Value<String?> summary = const Value.absent(),
                Value<List<String>?> memberEntityIds = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => PartiesCompanion.insert(
                id: id,
                campaignId: campaignId,
                name: name,
                summary: summary,
                memberEntityIds: memberEntityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({campaignId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (campaignId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.campaignId,
                                referencedTable: $$PartiesTableReferences
                                    ._campaignIdTable(db),
                                referencedColumn: $$PartiesTableReferences
                                    ._campaignIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PartiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $PartiesTable,
      Party,
      $$PartiesTableFilterComposer,
      $$PartiesTableOrderingComposer,
      $$PartiesTableAnnotationComposer,
      $$PartiesTableCreateCompanionBuilder,
      $$PartiesTableUpdateCompanionBuilder,
      (Party, $$PartiesTableReferences),
      Party,
      PrefetchHooks Function({bool campaignId})
    >;
typedef $$EncountersTableCreateCompanionBuilder =
    EncountersCompanion Function({
      required String id,
      required String name,
      required String originId,
      required bool preset,
      Value<String?> notes,
      Value<String?> loot,
      Value<List<Map<String, dynamic>>?> combatants,
      required List<String> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$EncountersTableUpdateCompanionBuilder =
    EncountersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> originId,
      Value<bool> preset,
      Value<String?> notes,
      Value<String?> loot,
      Value<List<Map<String, dynamic>>?> combatants,
      Value<List<String>> entityIds,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

final class $$EncountersTableReferences
    extends BaseReferences<_$AppDb, $EncountersTable, Encounter> {
  $$EncountersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CombatantsTable, List<Combatant>>
  _combatantsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.combatants,
    aliasName: $_aliasNameGenerator(
      db.encounters.id,
      db.combatants.encounterId,
    ),
  );

  $$CombatantsTableProcessedTableManager get combatantsRefs {
    final manager = $$CombatantsTableTableManager(
      $_db,
      $_db.combatants,
    ).filter((f) => f.encounterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_combatantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EncountersTableFilterComposer
    extends Composer<_$AppDb, $EncountersTable> {
  $$EncountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originId => $composableBuilder(
    column: $table.originId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get preset => $composableBuilder(
    column: $table.preset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loot => $composableBuilder(
    column: $table.loot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>?,
    List<Map<String, dynamic>>,
    String
  >
  get combatants => $composableBuilder(
    column: $table.combatants,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> combatantsRefs(
    Expression<bool> Function($$CombatantsTableFilterComposer f) f,
  ) {
    final $$CombatantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.combatants,
      getReferencedColumn: (t) => t.encounterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombatantsTableFilterComposer(
            $db: $db,
            $table: $db.combatants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EncountersTableOrderingComposer
    extends Composer<_$AppDb, $EncountersTable> {
  $$EncountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originId => $composableBuilder(
    column: $table.originId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get preset => $composableBuilder(
    column: $table.preset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loot => $composableBuilder(
    column: $table.loot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get combatants => $composableBuilder(
    column: $table.combatants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityIds => $composableBuilder(
    column: $table.entityIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EncountersTableAnnotationComposer
    extends Composer<_$AppDb, $EncountersTable> {
  $$EncountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get originId =>
      $composableBuilder(column: $table.originId, builder: (column) => column);

  GeneratedColumn<bool> get preset =>
      $composableBuilder(column: $table.preset, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get loot =>
      $composableBuilder(column: $table.loot, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>?, String>
  get combatants => $composableBuilder(
    column: $table.combatants,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get entityIds =>
      $composableBuilder(column: $table.entityIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  Expression<T> combatantsRefs<T extends Object>(
    Expression<T> Function($$CombatantsTableAnnotationComposer a) f,
  ) {
    final $$CombatantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.combatants,
      getReferencedColumn: (t) => t.encounterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CombatantsTableAnnotationComposer(
            $db: $db,
            $table: $db.combatants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EncountersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $EncountersTable,
          Encounter,
          $$EncountersTableFilterComposer,
          $$EncountersTableOrderingComposer,
          $$EncountersTableAnnotationComposer,
          $$EncountersTableCreateCompanionBuilder,
          $$EncountersTableUpdateCompanionBuilder,
          (Encounter, $$EncountersTableReferences),
          Encounter,
          PrefetchHooks Function({bool combatantsRefs})
        > {
  $$EncountersTableTableManager(_$AppDb db, $EncountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EncountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EncountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EncountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> originId = const Value.absent(),
                Value<bool> preset = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> loot = const Value.absent(),
                Value<List<Map<String, dynamic>>?> combatants =
                    const Value.absent(),
                Value<List<String>> entityIds = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EncountersCompanion(
                id: id,
                name: name,
                originId: originId,
                preset: preset,
                notes: notes,
                loot: loot,
                combatants: combatants,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String originId,
                required bool preset,
                Value<String?> notes = const Value.absent(),
                Value<String?> loot = const Value.absent(),
                Value<List<Map<String, dynamic>>?> combatants =
                    const Value.absent(),
                required List<String> entityIds,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => EncountersCompanion.insert(
                id: id,
                name: name,
                originId: originId,
                preset: preset,
                notes: notes,
                loot: loot,
                combatants: combatants,
                entityIds: entityIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EncountersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({combatantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (combatantsRefs) db.combatants],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (combatantsRefs)
                    await $_getPrefetchedData<
                      Encounter,
                      $EncountersTable,
                      Combatant
                    >(
                      currentTable: table,
                      referencedTable: $$EncountersTableReferences
                          ._combatantsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EncountersTableReferences(
                            db,
                            table,
                            p0,
                          ).combatantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.encounterId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EncountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $EncountersTable,
      Encounter,
      $$EncountersTableFilterComposer,
      $$EncountersTableOrderingComposer,
      $$EncountersTableAnnotationComposer,
      $$EncountersTableCreateCompanionBuilder,
      $$EncountersTableUpdateCompanionBuilder,
      (Encounter, $$EncountersTableReferences),
      Encounter,
      PrefetchHooks Function({bool combatantsRefs})
    >;
typedef $$EntitiesTableCreateCompanionBuilder =
    EntitiesCompanion Function({
      required String id,
      required String kind,
      required String name,
      required String originId,
      Value<String?> summary,
      Value<List<String>?> tags,
      required Map<String, dynamic> statblock,
      Value<String?> placeType,
      Value<String?> parentPlaceId,
      required Map<String, dynamic> coords,
      Value<Map<String, dynamic>?> content,
      Value<List<Map<String, dynamic>>?> images,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<bool> deleted,
      Value<List<String>?> members,
      Value<int> rowid,
    });
typedef $$EntitiesTableUpdateCompanionBuilder =
    EntitiesCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<String> name,
      Value<String> originId,
      Value<String?> summary,
      Value<List<String>?> tags,
      Value<Map<String, dynamic>> statblock,
      Value<String?> placeType,
      Value<String?> parentPlaceId,
      Value<Map<String, dynamic>> coords,
      Value<Map<String, dynamic>?> content,
      Value<List<Map<String, dynamic>>?> images,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<bool> deleted,
      Value<List<String>?> members,
      Value<int> rowid,
    });

class $$EntitiesTableFilterComposer extends Composer<_$AppDb, $EntitiesTable> {
  $$EntitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originId => $composableBuilder(
    column: $table.originId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get statblock => $composableBuilder(
    column: $table.statblock,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get placeType => $composableBuilder(
    column: $table.placeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentPlaceId => $composableBuilder(
    column: $table.parentPlaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>,
    Map<String, dynamic>,
    String
  >
  get coords => $composableBuilder(
    column: $table.coords,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>?,
    List<Map<String, dynamic>>,
    String
  >
  get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get members => $composableBuilder(
    column: $table.members,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$EntitiesTableOrderingComposer
    extends Composer<_$AppDb, $EntitiesTable> {
  $$EntitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originId => $composableBuilder(
    column: $table.originId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statblock => $composableBuilder(
    column: $table.statblock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeType => $composableBuilder(
    column: $table.placeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentPlaceId => $composableBuilder(
    column: $table.parentPlaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coords => $composableBuilder(
    column: $table.coords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get members => $composableBuilder(
    column: $table.members,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitiesTableAnnotationComposer
    extends Composer<_$AppDb, $EntitiesTable> {
  $$EntitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get originId =>
      $composableBuilder(column: $table.originId, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
  get statblock =>
      $composableBuilder(column: $table.statblock, builder: (column) => column);

  GeneratedColumn<String> get placeType =>
      $composableBuilder(column: $table.placeType, builder: (column) => column);

  GeneratedColumn<String> get parentPlaceId => $composableBuilder(
    column: $table.parentPlaceId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get coords =>
      $composableBuilder(column: $table.coords, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>?, String>
  get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get members =>
      $composableBuilder(column: $table.members, builder: (column) => column);
}

class $$EntitiesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $EntitiesTable,
          Entity,
          $$EntitiesTableFilterComposer,
          $$EntitiesTableOrderingComposer,
          $$EntitiesTableAnnotationComposer,
          $$EntitiesTableCreateCompanionBuilder,
          $$EntitiesTableUpdateCompanionBuilder,
          (Entity, BaseReferences<_$AppDb, $EntitiesTable, Entity>),
          Entity,
          PrefetchHooks Function()
        > {
  $$EntitiesTableTableManager(_$AppDb db, $EntitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> originId = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<List<String>?> tags = const Value.absent(),
                Value<Map<String, dynamic>> statblock = const Value.absent(),
                Value<String?> placeType = const Value.absent(),
                Value<String?> parentPlaceId = const Value.absent(),
                Value<Map<String, dynamic>> coords = const Value.absent(),
                Value<Map<String, dynamic>?> content = const Value.absent(),
                Value<List<Map<String, dynamic>>?> images =
                    const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<List<String>?> members = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitiesCompanion(
                id: id,
                kind: kind,
                name: name,
                originId: originId,
                summary: summary,
                tags: tags,
                statblock: statblock,
                placeType: placeType,
                parentPlaceId: parentPlaceId,
                coords: coords,
                content: content,
                images: images,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                deleted: deleted,
                members: members,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String kind,
                required String name,
                required String originId,
                Value<String?> summary = const Value.absent(),
                Value<List<String>?> tags = const Value.absent(),
                required Map<String, dynamic> statblock,
                Value<String?> placeType = const Value.absent(),
                Value<String?> parentPlaceId = const Value.absent(),
                required Map<String, dynamic> coords,
                Value<Map<String, dynamic>?> content = const Value.absent(),
                Value<List<Map<String, dynamic>>?> images =
                    const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<bool> deleted = const Value.absent(),
                Value<List<String>?> members = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitiesCompanion.insert(
                id: id,
                kind: kind,
                name: name,
                originId: originId,
                summary: summary,
                tags: tags,
                statblock: statblock,
                placeType: placeType,
                parentPlaceId: parentPlaceId,
                coords: coords,
                content: content,
                images: images,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                deleted: deleted,
                members: members,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $EntitiesTable,
      Entity,
      $$EntitiesTableFilterComposer,
      $$EntitiesTableOrderingComposer,
      $$EntitiesTableAnnotationComposer,
      $$EntitiesTableCreateCompanionBuilder,
      $$EntitiesTableUpdateCompanionBuilder,
      (Entity, BaseReferences<_$AppDb, $EntitiesTable, Entity>),
      Entity,
      PrefetchHooks Function()
    >;
typedef $$CombatantsTableCreateCompanionBuilder =
    CombatantsCompanion Function({
      required String id,
      required String encounterId,
      required String name,
      required String type,
      required bool isAlly,
      required int currentHp,
      required int maxHp,
      required int armorClass,
      Value<int?> initiative,
      required int initiativeModifier,
      Value<String?> entityId,
      Value<String?> bestiaryName,
      Value<String?> cr,
      required int xp,
      required List<String> conditions,
      Value<String?> notes,
      required int order,
      Value<int> rowid,
    });
typedef $$CombatantsTableUpdateCompanionBuilder =
    CombatantsCompanion Function({
      Value<String> id,
      Value<String> encounterId,
      Value<String> name,
      Value<String> type,
      Value<bool> isAlly,
      Value<int> currentHp,
      Value<int> maxHp,
      Value<int> armorClass,
      Value<int?> initiative,
      Value<int> initiativeModifier,
      Value<String?> entityId,
      Value<String?> bestiaryName,
      Value<String?> cr,
      Value<int> xp,
      Value<List<String>> conditions,
      Value<String?> notes,
      Value<int> order,
      Value<int> rowid,
    });

final class $$CombatantsTableReferences
    extends BaseReferences<_$AppDb, $CombatantsTable, Combatant> {
  $$CombatantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EncountersTable _encounterIdTable(_$AppDb db) =>
      db.encounters.createAlias(
        $_aliasNameGenerator(db.combatants.encounterId, db.encounters.id),
      );

  $$EncountersTableProcessedTableManager get encounterId {
    final $_column = $_itemColumn<String>('encounter_id')!;

    final manager = $$EncountersTableTableManager(
      $_db,
      $_db.encounters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_encounterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CombatantsTableFilterComposer
    extends Composer<_$AppDb, $CombatantsTable> {
  $$CombatantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAlly => $composableBuilder(
    column: $table.isAlly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initiative => $composableBuilder(
    column: $table.initiative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initiativeModifier => $composableBuilder(
    column: $table.initiativeModifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bestiaryName => $composableBuilder(
    column: $table.bestiaryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cr => $composableBuilder(
    column: $table.cr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  $$EncountersTableFilterComposer get encounterId {
    final $$EncountersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.encounterId,
      referencedTable: $db.encounters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EncountersTableFilterComposer(
            $db: $db,
            $table: $db.encounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CombatantsTableOrderingComposer
    extends Composer<_$AppDb, $CombatantsTable> {
  $$CombatantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAlly => $composableBuilder(
    column: $table.isAlly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initiative => $composableBuilder(
    column: $table.initiative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initiativeModifier => $composableBuilder(
    column: $table.initiativeModifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bestiaryName => $composableBuilder(
    column: $table.bestiaryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cr => $composableBuilder(
    column: $table.cr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  $$EncountersTableOrderingComposer get encounterId {
    final $$EncountersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.encounterId,
      referencedTable: $db.encounters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EncountersTableOrderingComposer(
            $db: $db,
            $table: $db.encounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CombatantsTableAnnotationComposer
    extends Composer<_$AppDb, $CombatantsTable> {
  $$CombatantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isAlly =>
      $composableBuilder(column: $table.isAlly, builder: (column) => column);

  GeneratedColumn<int> get currentHp =>
      $composableBuilder(column: $table.currentHp, builder: (column) => column);

  GeneratedColumn<int> get maxHp =>
      $composableBuilder(column: $table.maxHp, builder: (column) => column);

  GeneratedColumn<int> get armorClass => $composableBuilder(
    column: $table.armorClass,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initiative => $composableBuilder(
    column: $table.initiative,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initiativeModifier => $composableBuilder(
    column: $table.initiativeModifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get bestiaryName => $composableBuilder(
    column: $table.bestiaryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cr =>
      $composableBuilder(column: $table.cr, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get conditions =>
      $composableBuilder(
        column: $table.conditions,
        builder: (column) => column,
      );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  $$EncountersTableAnnotationComposer get encounterId {
    final $$EncountersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.encounterId,
      referencedTable: $db.encounters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EncountersTableAnnotationComposer(
            $db: $db,
            $table: $db.encounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CombatantsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $CombatantsTable,
          Combatant,
          $$CombatantsTableFilterComposer,
          $$CombatantsTableOrderingComposer,
          $$CombatantsTableAnnotationComposer,
          $$CombatantsTableCreateCompanionBuilder,
          $$CombatantsTableUpdateCompanionBuilder,
          (Combatant, $$CombatantsTableReferences),
          Combatant,
          PrefetchHooks Function({bool encounterId})
        > {
  $$CombatantsTableTableManager(_$AppDb db, $CombatantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CombatantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CombatantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CombatantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> encounterId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isAlly = const Value.absent(),
                Value<int> currentHp = const Value.absent(),
                Value<int> maxHp = const Value.absent(),
                Value<int> armorClass = const Value.absent(),
                Value<int?> initiative = const Value.absent(),
                Value<int> initiativeModifier = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String?> bestiaryName = const Value.absent(),
                Value<String?> cr = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<List<String>> conditions = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CombatantsCompanion(
                id: id,
                encounterId: encounterId,
                name: name,
                type: type,
                isAlly: isAlly,
                currentHp: currentHp,
                maxHp: maxHp,
                armorClass: armorClass,
                initiative: initiative,
                initiativeModifier: initiativeModifier,
                entityId: entityId,
                bestiaryName: bestiaryName,
                cr: cr,
                xp: xp,
                conditions: conditions,
                notes: notes,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String encounterId,
                required String name,
                required String type,
                required bool isAlly,
                required int currentHp,
                required int maxHp,
                required int armorClass,
                Value<int?> initiative = const Value.absent(),
                required int initiativeModifier,
                Value<String?> entityId = const Value.absent(),
                Value<String?> bestiaryName = const Value.absent(),
                Value<String?> cr = const Value.absent(),
                required int xp,
                required List<String> conditions,
                Value<String?> notes = const Value.absent(),
                required int order,
                Value<int> rowid = const Value.absent(),
              }) => CombatantsCompanion.insert(
                id: id,
                encounterId: encounterId,
                name: name,
                type: type,
                isAlly: isAlly,
                currentHp: currentHp,
                maxHp: maxHp,
                armorClass: armorClass,
                initiative: initiative,
                initiativeModifier: initiativeModifier,
                entityId: entityId,
                bestiaryName: bestiaryName,
                cr: cr,
                xp: xp,
                conditions: conditions,
                notes: notes,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CombatantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({encounterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (encounterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.encounterId,
                                referencedTable: $$CombatantsTableReferences
                                    ._encounterIdTable(db),
                                referencedColumn: $$CombatantsTableReferences
                                    ._encounterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CombatantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $CombatantsTable,
      Combatant,
      $$CombatantsTableFilterComposer,
      $$CombatantsTableOrderingComposer,
      $$CombatantsTableAnnotationComposer,
      $$CombatantsTableCreateCompanionBuilder,
      $$CombatantsTableUpdateCompanionBuilder,
      (Combatant, $$CombatantsTableReferences),
      Combatant,
      PrefetchHooks Function({bool encounterId})
    >;
typedef $$MediaAssetsTableCreateCompanionBuilder =
    MediaAssetsCompanion Function({
      required String id,
      required String filename,
      required int size,
      required String mime,
      Value<List<String>?> captions,
      Value<String?> alt,
      Value<List<Map<String, dynamic>>?> variants,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$MediaAssetsTableUpdateCompanionBuilder =
    MediaAssetsCompanion Function({
      Value<String> id,
      Value<String> filename,
      Value<int> size,
      Value<String> mime,
      Value<List<String>?> captions,
      Value<String?> alt,
      Value<List<Map<String, dynamic>>?> variants,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

class $$MediaAssetsTableFilterComposer
    extends Composer<_$AppDb, $MediaAssetsTable> {
  $$MediaAssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
  get captions => $composableBuilder(
    column: $table.captions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get alt => $composableBuilder(
    column: $table.alt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>?,
    List<Map<String, dynamic>>,
    String
  >
  get variants => $composableBuilder(
    column: $table.variants,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaAssetsTableOrderingComposer
    extends Composer<_$AppDb, $MediaAssetsTable> {
  $$MediaAssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get captions => $composableBuilder(
    column: $table.captions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alt => $composableBuilder(
    column: $table.alt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variants => $composableBuilder(
    column: $table.variants,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaAssetsTableAnnotationComposer
    extends Composer<_$AppDb, $MediaAssetsTable> {
  $$MediaAssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<String> get mime =>
      $composableBuilder(column: $table.mime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get captions =>
      $composableBuilder(column: $table.captions, builder: (column) => column);

  GeneratedColumn<String> get alt =>
      $composableBuilder(column: $table.alt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>?, String>
  get variants =>
      $composableBuilder(column: $table.variants, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);
}

class $$MediaAssetsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MediaAssetsTable,
          MediaAsset,
          $$MediaAssetsTableFilterComposer,
          $$MediaAssetsTableOrderingComposer,
          $$MediaAssetsTableAnnotationComposer,
          $$MediaAssetsTableCreateCompanionBuilder,
          $$MediaAssetsTableUpdateCompanionBuilder,
          (MediaAsset, BaseReferences<_$AppDb, $MediaAssetsTable, MediaAsset>),
          MediaAsset,
          PrefetchHooks Function()
        > {
  $$MediaAssetsTableTableManager(_$AppDb db, $MediaAssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaAssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaAssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaAssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<int> size = const Value.absent(),
                Value<String> mime = const Value.absent(),
                Value<List<String>?> captions = const Value.absent(),
                Value<String?> alt = const Value.absent(),
                Value<List<Map<String, dynamic>>?> variants =
                    const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion(
                id: id,
                filename: filename,
                size: size,
                mime: mime,
                captions: captions,
                alt: alt,
                variants: variants,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String filename,
                required int size,
                required String mime,
                Value<List<String>?> captions = const Value.absent(),
                Value<String?> alt = const Value.absent(),
                Value<List<Map<String, dynamic>>?> variants =
                    const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => MediaAssetsCompanion.insert(
                id: id,
                filename: filename,
                size: size,
                mime: mime,
                captions: captions,
                alt: alt,
                variants: variants,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaAssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MediaAssetsTable,
      MediaAsset,
      $$MediaAssetsTableFilterComposer,
      $$MediaAssetsTableOrderingComposer,
      $$MediaAssetsTableAnnotationComposer,
      $$MediaAssetsTableCreateCompanionBuilder,
      $$MediaAssetsTableUpdateCompanionBuilder,
      (MediaAsset, BaseReferences<_$AppDb, $MediaAssetsTable, MediaAsset>),
      MediaAsset,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      Value<DateTime?> createdAt,
      Value<Map<String, dynamic>?> info,
      Value<DateTime?> datetime,
      Value<Map<String, dynamic>?> log,
      Value<String?> shareToken,
      Value<bool> shareEnabled,
      Value<DateTime?> shareExpiresAt,
      Value<DateTime?> updatedAt,
      required int rev,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<DateTime?> createdAt,
      Value<Map<String, dynamic>?> info,
      Value<DateTime?> datetime,
      Value<Map<String, dynamic>?> log,
      Value<String?> shareToken,
      Value<bool> shareEnabled,
      Value<DateTime?> shareExpiresAt,
      Value<DateTime?> updatedAt,
      Value<int> rev,
      Value<int> rowid,
    });

class $$SessionsTableFilterComposer extends Composer<_$AppDb, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get info => $composableBuilder(
    column: $table.info,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get datetime => $composableBuilder(
    column: $table.datetime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get log => $composableBuilder(
    column: $table.log,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get shareToken => $composableBuilder(
    column: $table.shareToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get shareEnabled => $composableBuilder(
    column: $table.shareEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get shareExpiresAt => $composableBuilder(
    column: $table.shareExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDb, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get info => $composableBuilder(
    column: $table.info,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datetime => $composableBuilder(
    column: $table.datetime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get log => $composableBuilder(
    column: $table.log,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareToken => $composableBuilder(
    column: $table.shareToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get shareEnabled => $composableBuilder(
    column: $table.shareEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get shareExpiresAt => $composableBuilder(
    column: $table.shareExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDb, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get info =>
      $composableBuilder(column: $table.info, builder: (column) => column);

  GeneratedColumn<DateTime> get datetime =>
      $composableBuilder(column: $table.datetime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String> get log =>
      $composableBuilder(column: $table.log, builder: (column) => column);

  GeneratedColumn<String> get shareToken => $composableBuilder(
    column: $table.shareToken,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get shareEnabled => $composableBuilder(
    column: $table.shareEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get shareExpiresAt => $composableBuilder(
    column: $table.shareExpiresAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDb, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDb db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<Map<String, dynamic>?> info = const Value.absent(),
                Value<DateTime?> datetime = const Value.absent(),
                Value<Map<String, dynamic>?> log = const Value.absent(),
                Value<String?> shareToken = const Value.absent(),
                Value<bool> shareEnabled = const Value.absent(),
                Value<DateTime?> shareExpiresAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                createdAt: createdAt,
                info: info,
                datetime: datetime,
                log: log,
                shareToken: shareToken,
                shareEnabled: shareEnabled,
                shareExpiresAt: shareExpiresAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<Map<String, dynamic>?> info = const Value.absent(),
                Value<DateTime?> datetime = const Value.absent(),
                Value<Map<String, dynamic>?> log = const Value.absent(),
                Value<String?> shareToken = const Value.absent(),
                Value<bool> shareEnabled = const Value.absent(),
                Value<DateTime?> shareExpiresAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required int rev,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                info: info,
                datetime: datetime,
                log: log,
                shareToken: shareToken,
                shareEnabled: shareEnabled,
                shareExpiresAt: shareExpiresAt,
                updatedAt: updatedAt,
                rev: rev,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDb, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$OutboxEntriesTableCreateCompanionBuilder =
    OutboxEntriesCompanion Function({
      required String id,
      required String table,
      required String rowId,
      required String op,
      required DateTime changedAt,
      Value<String?> payload,
      Value<int> rowid,
    });
typedef $$OutboxEntriesTableUpdateCompanionBuilder =
    OutboxEntriesCompanion Function({
      Value<String> id,
      Value<String> table,
      Value<String> rowId,
      Value<String> op,
      Value<DateTime> changedAt,
      Value<String?> payload,
      Value<int> rowid,
    });

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$AppDb, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$AppDb, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$AppDb, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get table =>
      $composableBuilder(column: $table.table, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $OutboxEntriesTable,
          OutboxEntry,
          $$OutboxEntriesTableFilterComposer,
          $$OutboxEntriesTableOrderingComposer,
          $$OutboxEntriesTableAnnotationComposer,
          $$OutboxEntriesTableCreateCompanionBuilder,
          $$OutboxEntriesTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDb, $OutboxEntriesTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$OutboxEntriesTableTableManager(_$AppDb db, $OutboxEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> table = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion(
                id: id,
                table: table,
                rowId: rowId,
                op: op,
                changedAt: changedAt,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String table,
                required String rowId,
                required String op,
                required DateTime changedAt,
                Value<String?> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutboxEntriesCompanion.insert(
                id: id,
                table: table,
                rowId: rowId,
                op: op,
                changedAt: changedAt,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutboxEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $OutboxEntriesTable,
      OutboxEntry,
      $$OutboxEntriesTableFilterComposer,
      $$OutboxEntriesTableOrderingComposer,
      $$OutboxEntriesTableAnnotationComposer,
      $$OutboxEntriesTableCreateCompanionBuilder,
      $$OutboxEntriesTableUpdateCompanionBuilder,
      (OutboxEntry, BaseReferences<_$AppDb, $OutboxEntriesTable, OutboxEntry>),
      OutboxEntry,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$CampaignsTableTableManager get campaigns =>
      $$CampaignsTableTableManager(_db, _db.campaigns);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$AdventuresTableTableManager get adventures =>
      $$AdventuresTableTableManager(_db, _db.adventures);
  $$ScenesTableTableManager get scenes =>
      $$ScenesTableTableManager(_db, _db.scenes);
  $$PartiesTableTableManager get parties =>
      $$PartiesTableTableManager(_db, _db.parties);
  $$EncountersTableTableManager get encounters =>
      $$EncountersTableTableManager(_db, _db.encounters);
  $$EntitiesTableTableManager get entities =>
      $$EntitiesTableTableManager(_db, _db.entities);
  $$CombatantsTableTableManager get combatants =>
      $$CombatantsTableTableManager(_db, _db.combatants);
  $$MediaAssetsTableTableManager get mediaAssets =>
      $$MediaAssetsTableTableManager(_db, _db.mediaAssets);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
}
