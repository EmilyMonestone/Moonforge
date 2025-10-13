// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i26;
import 'package:flutter/material.dart' as _i27;
import 'package:moonforge/core/widgets/layout_wrapper.dart' as _i16;
import 'package:moonforge/features/adventure/views/adventure_edit_screen.dart'
    as _i1;
import 'package:moonforge/features/adventure/views/adventure_screen.dart'
    as _i2;
import 'package:moonforge/features/auth/views/login_screen.dart' as _i13;
import 'package:moonforge/features/auth/views/register_screen.dart' as _i19;
import 'package:moonforge/features/campaign/views/campaign_edit_screen.dart'
    as _i3;
import 'package:moonforge/features/campaign/views/campaign_screen.dart' as _i4;
import 'package:moonforge/features/chapter/views/chapter_edit_screen.dart'
    as _i5;
import 'package:moonforge/features/chapter/views/chapter_screen.dart' as _i6;
import 'package:moonforge/features/encounters/views/encounter_edit_screen.dart'
    as _i7;
import 'package:moonforge/features/encounters/views/encounter_screen.dart'
    as _i8;
import 'package:moonforge/features/entities/views/entity_edit_screen.dart'
    as _i9;
import 'package:moonforge/features/entities/views/entity_screen.dart' as _i10;
import 'package:moonforge/features/home/views/home_screen.dart' as _i11;
import 'package:moonforge/features/home/views/unknown_path_screen.dart' as _i25;
import 'package:moonforge/features/parties/views/member_edit_screen.dart'
    as _i14;
import 'package:moonforge/features/parties/views/member_screen.dart' as _i15;
import 'package:moonforge/features/parties/views/party_edit_screen.dart'
    as _i17;
import 'package:moonforge/features/parties/views/party_screen.dart' as _i18;
import 'package:moonforge/features/scene/views/scene_edit_screen.dart' as _i20;
import 'package:moonforge/features/scene/views/scene_screen.dart' as _i21;
import 'package:moonforge/features/session/views/session_edit_screen.dart'
    as _i22;
import 'package:moonforge/features/session/views/session_screen.dart' as _i23;
import 'package:moonforge/features/settings/views/settings_screen.dart' as _i24;
import 'package:moonforge/layout/layout_shell.dart' as _i12;

/// generated route for
/// [_i1.AdventureEditScreen]
class AdventureEditRoute extends _i26.PageRouteInfo<AdventureEditRouteArgs> {
  AdventureEditRoute({
    _i27.Key? key,
    required String campaignId,
    required String chapterId,
    required String adventureId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         AdventureEditRoute.name,
         args: AdventureEditRouteArgs(
           key: key,
           campaignId: campaignId,
           chapterId: chapterId,
           adventureId: adventureId,
         ),
         rawPathParams: {
           'campaignId': campaignId,
           'chapterId': chapterId,
           'adventureId': adventureId,
         },
         initialChildren: children,
       );

  static const String name = 'AdventureEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdventureEditRouteArgs>(
        orElse: () => AdventureEditRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          chapterId: pathParams.getString('chapterId'),
          adventureId: pathParams.getString('adventureId'),
        ),
      );
      return _i1.AdventureEditScreen(
        key: args.key,
        campaignId: args.campaignId,
        chapterId: args.chapterId,
        adventureId: args.adventureId,
      );
    },
  );
}

class AdventureEditRouteArgs {
  const AdventureEditRouteArgs({
    this.key,
    required this.campaignId,
    required this.chapterId,
    required this.adventureId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String chapterId;

  final String adventureId;

  @override
  String toString() {
    return 'AdventureEditRouteArgs{key: $key, campaignId: $campaignId, chapterId: $chapterId, adventureId: $adventureId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdventureEditRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        chapterId == other.chapterId &&
        adventureId == other.adventureId;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      campaignId.hashCode ^
      chapterId.hashCode ^
      adventureId.hashCode;
}

/// generated route for
/// [_i2.AdventureScreen]
class AdventureRoute extends _i26.PageRouteInfo<AdventureRouteArgs> {
  AdventureRoute({
    _i27.Key? key,
    required String campaignId,
    required String chapterId,
    required String adventureId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         AdventureRoute.name,
         args: AdventureRouteArgs(
           key: key,
           campaignId: campaignId,
           chapterId: chapterId,
           adventureId: adventureId,
         ),
         rawPathParams: {
           'campaignId': campaignId,
           'chapterId': chapterId,
           'adventureId': adventureId,
         },
         initialChildren: children,
       );

  static const String name = 'AdventureRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<AdventureRouteArgs>(
        orElse: () => AdventureRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          chapterId: pathParams.getString('chapterId'),
          adventureId: pathParams.getString('adventureId'),
        ),
      );
      return _i2.AdventureScreen(
        key: args.key,
        campaignId: args.campaignId,
        chapterId: args.chapterId,
        adventureId: args.adventureId,
      );
    },
  );
}

class AdventureRouteArgs {
  const AdventureRouteArgs({
    this.key,
    required this.campaignId,
    required this.chapterId,
    required this.adventureId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String chapterId;

  final String adventureId;

  @override
  String toString() {
    return 'AdventureRouteArgs{key: $key, campaignId: $campaignId, chapterId: $chapterId, adventureId: $adventureId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AdventureRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        chapterId == other.chapterId &&
        adventureId == other.adventureId;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      campaignId.hashCode ^
      chapterId.hashCode ^
      adventureId.hashCode;
}

/// generated route for
/// [_i3.CampaignEditScreen]
class CampaignEditRoute extends _i26.PageRouteInfo<CampaignEditRouteArgs> {
  CampaignEditRoute({
    _i27.Key? key,
    required String campaignId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         CampaignEditRoute.name,
         args: CampaignEditRouteArgs(key: key, campaignId: campaignId),
         rawPathParams: {'campaignId': campaignId},
         initialChildren: children,
       );

  static const String name = 'CampaignEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CampaignEditRouteArgs>(
        orElse: () => CampaignEditRouteArgs(
          campaignId: pathParams.getString('campaignId'),
        ),
      );
      return _i3.CampaignEditScreen(key: args.key, campaignId: args.campaignId);
    },
  );
}

class CampaignEditRouteArgs {
  const CampaignEditRouteArgs({this.key, required this.campaignId});

  final _i27.Key? key;

  final String campaignId;

  @override
  String toString() {
    return 'CampaignEditRouteArgs{key: $key, campaignId: $campaignId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CampaignEditRouteArgs) return false;
    return key == other.key && campaignId == other.campaignId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode;
}

/// generated route for
/// [_i4.CampaignScreen]
class CampaignRoute extends _i26.PageRouteInfo<CampaignRouteArgs> {
  CampaignRoute({
    _i27.Key? key,
    required String campaignId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         CampaignRoute.name,
         args: CampaignRouteArgs(key: key, campaignId: campaignId),
         rawPathParams: {'campaignId': campaignId},
         initialChildren: children,
       );

  static const String name = 'CampaignRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CampaignRouteArgs>(
        orElse: () =>
            CampaignRouteArgs(campaignId: pathParams.getString('campaignId')),
      );
      return _i4.CampaignScreen(key: args.key, campaignId: args.campaignId);
    },
  );
}

class CampaignRouteArgs {
  const CampaignRouteArgs({this.key, required this.campaignId});

  final _i27.Key? key;

  final String campaignId;

  @override
  String toString() {
    return 'CampaignRouteArgs{key: $key, campaignId: $campaignId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CampaignRouteArgs) return false;
    return key == other.key && campaignId == other.campaignId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode;
}

/// generated route for
/// [_i5.ChapterEditScreen]
class ChapterEditRoute extends _i26.PageRouteInfo<ChapterEditRouteArgs> {
  ChapterEditRoute({
    _i27.Key? key,
    required String campaignId,
    required String chapterId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         ChapterEditRoute.name,
         args: ChapterEditRouteArgs(
           key: key,
           campaignId: campaignId,
           chapterId: chapterId,
         ),
         rawPathParams: {'campaignId': campaignId, 'chapterId': chapterId},
         initialChildren: children,
       );

  static const String name = 'ChapterEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChapterEditRouteArgs>(
        orElse: () => ChapterEditRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          chapterId: pathParams.getString('chapterId'),
        ),
      );
      return _i5.ChapterEditScreen(
        key: args.key,
        campaignId: args.campaignId,
        chapterId: args.chapterId,
      );
    },
  );
}

class ChapterEditRouteArgs {
  const ChapterEditRouteArgs({
    this.key,
    required this.campaignId,
    required this.chapterId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String chapterId;

  @override
  String toString() {
    return 'ChapterEditRouteArgs{key: $key, campaignId: $campaignId, chapterId: $chapterId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChapterEditRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        chapterId == other.chapterId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode ^ chapterId.hashCode;
}

/// generated route for
/// [_i6.ChapterScreen]
class ChapterRoute extends _i26.PageRouteInfo<ChapterRouteArgs> {
  ChapterRoute({
    _i27.Key? key,
    required String campaignId,
    required String chapterId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         ChapterRoute.name,
         args: ChapterRouteArgs(
           key: key,
           campaignId: campaignId,
           chapterId: chapterId,
         ),
         rawPathParams: {'campaignId': campaignId, 'chapterId': chapterId},
         initialChildren: children,
       );

  static const String name = 'ChapterRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChapterRouteArgs>(
        orElse: () => ChapterRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          chapterId: pathParams.getString('chapterId'),
        ),
      );
      return _i6.ChapterScreen(
        key: args.key,
        campaignId: args.campaignId,
        chapterId: args.chapterId,
      );
    },
  );
}

class ChapterRouteArgs {
  const ChapterRouteArgs({
    this.key,
    required this.campaignId,
    required this.chapterId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String chapterId;

  @override
  String toString() {
    return 'ChapterRouteArgs{key: $key, campaignId: $campaignId, chapterId: $chapterId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChapterRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        chapterId == other.chapterId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode ^ chapterId.hashCode;
}

/// generated route for
/// [_i7.EncounterEditScreen]
class EncounterEditRoute extends _i26.PageRouteInfo<EncounterEditRouteArgs> {
  EncounterEditRoute({
    _i27.Key? key,
    required String campaignId,
    required String encoutnerId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         EncounterEditRoute.name,
         args: EncounterEditRouteArgs(
           key: key,
           campaignId: campaignId,
           encoutnerId: encoutnerId,
         ),
         rawPathParams: {'campaignId': campaignId, 'encoutnerId': encoutnerId},
         initialChildren: children,
       );

  static const String name = 'EncounterEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EncounterEditRouteArgs>(
        orElse: () => EncounterEditRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          encoutnerId: pathParams.getString('encoutnerId'),
        ),
      );
      return _i7.EncounterEditScreen(
        key: args.key,
        campaignId: args.campaignId,
        encoutnerId: args.encoutnerId,
      );
    },
  );
}

class EncounterEditRouteArgs {
  const EncounterEditRouteArgs({
    this.key,
    required this.campaignId,
    required this.encoutnerId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String encoutnerId;

  @override
  String toString() {
    return 'EncounterEditRouteArgs{key: $key, campaignId: $campaignId, encoutnerId: $encoutnerId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EncounterEditRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        encoutnerId == other.encoutnerId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode ^ encoutnerId.hashCode;
}

/// generated route for
/// [_i8.EncounterScreen]
class EncounterRoute extends _i26.PageRouteInfo<EncounterRouteArgs> {
  EncounterRoute({
    _i27.Key? key,
    required String campaignId,
    required String encoutnerId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         EncounterRoute.name,
         args: EncounterRouteArgs(
           key: key,
           campaignId: campaignId,
           encoutnerId: encoutnerId,
         ),
         rawPathParams: {'campaignId': campaignId, 'encoutnerId': encoutnerId},
         initialChildren: children,
       );

  static const String name = 'EncounterRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EncounterRouteArgs>(
        orElse: () => EncounterRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          encoutnerId: pathParams.getString('encoutnerId'),
        ),
      );
      return _i8.EncounterScreen(
        key: args.key,
        campaignId: args.campaignId,
        encoutnerId: args.encoutnerId,
      );
    },
  );
}

class EncounterRouteArgs {
  const EncounterRouteArgs({
    this.key,
    required this.campaignId,
    required this.encoutnerId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String encoutnerId;

  @override
  String toString() {
    return 'EncounterRouteArgs{key: $key, campaignId: $campaignId, encoutnerId: $encoutnerId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EncounterRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        encoutnerId == other.encoutnerId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode ^ encoutnerId.hashCode;
}

/// generated route for
/// [_i9.EntityEditScreen]
class EntityEditRoute extends _i26.PageRouteInfo<EntityEditRouteArgs> {
  EntityEditRoute({
    _i27.Key? key,
    required String campaignId,
    required String entityId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         EntityEditRoute.name,
         args: EntityEditRouteArgs(
           key: key,
           campaignId: campaignId,
           entityId: entityId,
         ),
         rawPathParams: {'campaignId': campaignId, 'entityId': entityId},
         initialChildren: children,
       );

  static const String name = 'EntityEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EntityEditRouteArgs>(
        orElse: () => EntityEditRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          entityId: pathParams.getString('entityId'),
        ),
      );
      return _i9.EntityEditScreen(
        key: args.key,
        campaignId: args.campaignId,
        entityId: args.entityId,
      );
    },
  );
}

class EntityEditRouteArgs {
  const EntityEditRouteArgs({
    this.key,
    required this.campaignId,
    required this.entityId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String entityId;

  @override
  String toString() {
    return 'EntityEditRouteArgs{key: $key, campaignId: $campaignId, entityId: $entityId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EntityEditRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        entityId == other.entityId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode ^ entityId.hashCode;
}

/// generated route for
/// [_i10.EntityScreen]
class EntityRoute extends _i26.PageRouteInfo<EntityRouteArgs> {
  EntityRoute({
    _i27.Key? key,
    required String campaignId,
    required String entityId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         EntityRoute.name,
         args: EntityRouteArgs(
           key: key,
           campaignId: campaignId,
           entityId: entityId,
         ),
         rawPathParams: {'campaignId': campaignId, 'entityId': entityId},
         initialChildren: children,
       );

  static const String name = 'EntityRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EntityRouteArgs>(
        orElse: () => EntityRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          entityId: pathParams.getString('entityId'),
        ),
      );
      return _i10.EntityScreen(
        key: args.key,
        campaignId: args.campaignId,
        entityId: args.entityId,
      );
    },
  );
}

class EntityRouteArgs {
  const EntityRouteArgs({
    this.key,
    required this.campaignId,
    required this.entityId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String entityId;

  @override
  String toString() {
    return 'EntityRouteArgs{key: $key, campaignId: $campaignId, entityId: $entityId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EntityRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        entityId == other.entityId;
  }

  @override
  int get hashCode => key.hashCode ^ campaignId.hashCode ^ entityId.hashCode;
}

/// generated route for
/// [_i11.HomeScreen]
class HomeRoute extends _i26.PageRouteInfo<void> {
  const HomeRoute({List<_i26.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomeScreen();
    },
  );
}

/// generated route for
/// [_i12.LayoutShell]
class LayoutShell extends _i26.PageRouteInfo<void> {
  const LayoutShell({List<_i26.PageRouteInfo>? children})
    : super(LayoutShell.name, initialChildren: children);

  static const String name = 'LayoutShell';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i12.LayoutShell();
    },
  );
}

/// generated route for
/// [_i13.LoginScreen]
class LoginRoute extends _i26.PageRouteInfo<void> {
  const LoginRoute({List<_i26.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i13.LoginScreen();
    },
  );
}

/// generated route for
/// [_i14.MemberEditScreen]
class MemberEditRoute extends _i26.PageRouteInfo<MemberEditRouteArgs> {
  MemberEditRoute({
    _i27.Key? key,
    required String partyId,
    required String memberId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         MemberEditRoute.name,
         args: MemberEditRouteArgs(
           key: key,
           partyId: partyId,
           memberId: memberId,
         ),
         rawPathParams: {'partyId': partyId, 'memberId': memberId},
         initialChildren: children,
       );

  static const String name = 'MemberEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MemberEditRouteArgs>(
        orElse: () => MemberEditRouteArgs(
          partyId: pathParams.getString('partyId'),
          memberId: pathParams.getString('memberId'),
        ),
      );
      return _i14.MemberEditScreen(
        key: args.key,
        partyId: args.partyId,
        memberId: args.memberId,
      );
    },
  );
}

class MemberEditRouteArgs {
  const MemberEditRouteArgs({
    this.key,
    required this.partyId,
    required this.memberId,
  });

  final _i27.Key? key;

  final String partyId;

  final String memberId;

  @override
  String toString() {
    return 'MemberEditRouteArgs{key: $key, partyId: $partyId, memberId: $memberId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemberEditRouteArgs) return false;
    return key == other.key &&
        partyId == other.partyId &&
        memberId == other.memberId;
  }

  @override
  int get hashCode => key.hashCode ^ partyId.hashCode ^ memberId.hashCode;
}

/// generated route for
/// [_i15.MemberScreen]
class MemberRoute extends _i26.PageRouteInfo<MemberRouteArgs> {
  MemberRoute({
    _i27.Key? key,
    required String partyId,
    required String memberId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         MemberRoute.name,
         args: MemberRouteArgs(key: key, partyId: partyId, memberId: memberId),
         rawPathParams: {'partyId': partyId, 'memberId': memberId},
         initialChildren: children,
       );

  static const String name = 'MemberRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<MemberRouteArgs>(
        orElse: () => MemberRouteArgs(
          partyId: pathParams.getString('partyId'),
          memberId: pathParams.getString('memberId'),
        ),
      );
      return _i15.MemberScreen(
        key: args.key,
        partyId: args.partyId,
        memberId: args.memberId,
      );
    },
  );
}

class MemberRouteArgs {
  const MemberRouteArgs({
    this.key,
    required this.partyId,
    required this.memberId,
  });

  final _i27.Key? key;

  final String partyId;

  final String memberId;

  @override
  String toString() {
    return 'MemberRouteArgs{key: $key, partyId: $partyId, memberId: $memberId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MemberRouteArgs) return false;
    return key == other.key &&
        partyId == other.partyId &&
        memberId == other.memberId;
  }

  @override
  int get hashCode => key.hashCode ^ partyId.hashCode ^ memberId.hashCode;
}

/// generated route for
/// [_i16.MyStateful]
class MyStateful extends _i26.PageRouteInfo<void> {
  const MyStateful({List<_i26.PageRouteInfo>? children})
    : super(MyStateful.name, initialChildren: children);

  static const String name = 'MyStateful';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i16.MyStateful();
    },
  );
}

/// generated route for
/// [_i17.PartyEditScreen]
class PartyEditRoute extends _i26.PageRouteInfo<PartyEditRouteArgs> {
  PartyEditRoute({
    _i27.Key? key,
    required String partyId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         PartyEditRoute.name,
         args: PartyEditRouteArgs(key: key, partyId: partyId),
         rawPathParams: {'partyId': partyId},
         initialChildren: children,
       );

  static const String name = 'PartyEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PartyEditRouteArgs>(
        orElse: () =>
            PartyEditRouteArgs(partyId: pathParams.getString('partyId')),
      );
      return _i17.PartyEditScreen(key: args.key, partyId: args.partyId);
    },
  );
}

class PartyEditRouteArgs {
  const PartyEditRouteArgs({this.key, required this.partyId});

  final _i27.Key? key;

  final String partyId;

  @override
  String toString() {
    return 'PartyEditRouteArgs{key: $key, partyId: $partyId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PartyEditRouteArgs) return false;
    return key == other.key && partyId == other.partyId;
  }

  @override
  int get hashCode => key.hashCode ^ partyId.hashCode;
}

/// generated route for
/// [_i18.PartyScreen]
class PartyRoute extends _i26.PageRouteInfo<PartyRouteArgs> {
  PartyRoute({
    _i27.Key? key,
    required String partyId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         PartyRoute.name,
         args: PartyRouteArgs(key: key, partyId: partyId),
         rawPathParams: {'partyId': partyId},
         initialChildren: children,
       );

  static const String name = 'PartyRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PartyRouteArgs>(
        orElse: () => PartyRouteArgs(partyId: pathParams.getString('partyId')),
      );
      return _i18.PartyScreen(key: args.key, partyId: args.partyId);
    },
  );
}

class PartyRouteArgs {
  const PartyRouteArgs({this.key, required this.partyId});

  final _i27.Key? key;

  final String partyId;

  @override
  String toString() {
    return 'PartyRouteArgs{key: $key, partyId: $partyId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PartyRouteArgs) return false;
    return key == other.key && partyId == other.partyId;
  }

  @override
  int get hashCode => key.hashCode ^ partyId.hashCode;
}

/// generated route for
/// [_i19.RegisterScreen]
class RegisterRoute extends _i26.PageRouteInfo<void> {
  const RegisterRoute({List<_i26.PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i19.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i20.SceneEditScreen]
class SceneEditRoute extends _i26.PageRouteInfo<SceneEditRouteArgs> {
  SceneEditRoute({
    _i27.Key? key,
    required String campaignId,
    required String chapterId,
    required String adventureId,
    required String sceneId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         SceneEditRoute.name,
         args: SceneEditRouteArgs(
           key: key,
           campaignId: campaignId,
           chapterId: chapterId,
           adventureId: adventureId,
           sceneId: sceneId,
         ),
         rawPathParams: {
           'campaignId': campaignId,
           'chapterId': chapterId,
           'adventureId': adventureId,
           'sceneId': sceneId,
         },
         initialChildren: children,
       );

  static const String name = 'SceneEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SceneEditRouteArgs>(
        orElse: () => SceneEditRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          chapterId: pathParams.getString('chapterId'),
          adventureId: pathParams.getString('adventureId'),
          sceneId: pathParams.getString('sceneId'),
        ),
      );
      return _i20.SceneEditScreen(
        key: args.key,
        campaignId: args.campaignId,
        chapterId: args.chapterId,
        adventureId: args.adventureId,
        sceneId: args.sceneId,
      );
    },
  );
}

class SceneEditRouteArgs {
  const SceneEditRouteArgs({
    this.key,
    required this.campaignId,
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String chapterId;

  final String adventureId;

  final String sceneId;

  @override
  String toString() {
    return 'SceneEditRouteArgs{key: $key, campaignId: $campaignId, chapterId: $chapterId, adventureId: $adventureId, sceneId: $sceneId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SceneEditRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        chapterId == other.chapterId &&
        adventureId == other.adventureId &&
        sceneId == other.sceneId;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      campaignId.hashCode ^
      chapterId.hashCode ^
      adventureId.hashCode ^
      sceneId.hashCode;
}

/// generated route for
/// [_i21.SceneScreen]
class SceneRoute extends _i26.PageRouteInfo<SceneRouteArgs> {
  SceneRoute({
    _i27.Key? key,
    required String campaignId,
    required String chapterId,
    required String adventureId,
    required String sceneId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         SceneRoute.name,
         args: SceneRouteArgs(
           key: key,
           campaignId: campaignId,
           chapterId: chapterId,
           adventureId: adventureId,
           sceneId: sceneId,
         ),
         rawPathParams: {
           'campaignId': campaignId,
           'chapterId': chapterId,
           'adventureId': adventureId,
           'sceneId': sceneId,
         },
         initialChildren: children,
       );

  static const String name = 'SceneRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SceneRouteArgs>(
        orElse: () => SceneRouteArgs(
          campaignId: pathParams.getString('campaignId'),
          chapterId: pathParams.getString('chapterId'),
          adventureId: pathParams.getString('adventureId'),
          sceneId: pathParams.getString('sceneId'),
        ),
      );
      return _i21.SceneScreen(
        key: args.key,
        campaignId: args.campaignId,
        chapterId: args.chapterId,
        adventureId: args.adventureId,
        sceneId: args.sceneId,
      );
    },
  );
}

class SceneRouteArgs {
  const SceneRouteArgs({
    this.key,
    required this.campaignId,
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final _i27.Key? key;

  final String campaignId;

  final String chapterId;

  final String adventureId;

  final String sceneId;

  @override
  String toString() {
    return 'SceneRouteArgs{key: $key, campaignId: $campaignId, chapterId: $chapterId, adventureId: $adventureId, sceneId: $sceneId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SceneRouteArgs) return false;
    return key == other.key &&
        campaignId == other.campaignId &&
        chapterId == other.chapterId &&
        adventureId == other.adventureId &&
        sceneId == other.sceneId;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      campaignId.hashCode ^
      chapterId.hashCode ^
      adventureId.hashCode ^
      sceneId.hashCode;
}

/// generated route for
/// [_i22.SessionEditScreen]
class SessionEditRoute extends _i26.PageRouteInfo<SessionEditRouteArgs> {
  SessionEditRoute({
    _i27.Key? key,
    required String partyId,
    required String sessionId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         SessionEditRoute.name,
         args: SessionEditRouteArgs(
           key: key,
           partyId: partyId,
           sessionId: sessionId,
         ),
         rawPathParams: {'partyId': partyId, 'sessionId': sessionId},
         initialChildren: children,
       );

  static const String name = 'SessionEditRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SessionEditRouteArgs>(
        orElse: () => SessionEditRouteArgs(
          partyId: pathParams.getString('partyId'),
          sessionId: pathParams.getString('sessionId'),
        ),
      );
      return _i22.SessionEditScreen(
        key: args.key,
        partyId: args.partyId,
        sessionId: args.sessionId,
      );
    },
  );
}

class SessionEditRouteArgs {
  const SessionEditRouteArgs({
    this.key,
    required this.partyId,
    required this.sessionId,
  });

  final _i27.Key? key;

  final String partyId;

  final String sessionId;

  @override
  String toString() {
    return 'SessionEditRouteArgs{key: $key, partyId: $partyId, sessionId: $sessionId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SessionEditRouteArgs) return false;
    return key == other.key &&
        partyId == other.partyId &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode => key.hashCode ^ partyId.hashCode ^ sessionId.hashCode;
}

/// generated route for
/// [_i23.SessionScreen]
class SessionRoute extends _i26.PageRouteInfo<SessionRouteArgs> {
  SessionRoute({
    _i27.Key? key,
    required String partyId,
    required String sessionId,
    List<_i26.PageRouteInfo>? children,
  }) : super(
         SessionRoute.name,
         args: SessionRouteArgs(
           key: key,
           partyId: partyId,
           sessionId: sessionId,
         ),
         rawPathParams: {'partyId': partyId, 'sessionId': sessionId},
         initialChildren: children,
       );

  static const String name = 'SessionRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SessionRouteArgs>(
        orElse: () => SessionRouteArgs(
          partyId: pathParams.getString('partyId'),
          sessionId: pathParams.getString('sessionId'),
        ),
      );
      return _i23.SessionScreen(
        key: args.key,
        partyId: args.partyId,
        sessionId: args.sessionId,
      );
    },
  );
}

class SessionRouteArgs {
  const SessionRouteArgs({
    this.key,
    required this.partyId,
    required this.sessionId,
  });

  final _i27.Key? key;

  final String partyId;

  final String sessionId;

  @override
  String toString() {
    return 'SessionRouteArgs{key: $key, partyId: $partyId, sessionId: $sessionId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SessionRouteArgs) return false;
    return key == other.key &&
        partyId == other.partyId &&
        sessionId == other.sessionId;
  }

  @override
  int get hashCode => key.hashCode ^ partyId.hashCode ^ sessionId.hashCode;
}

/// generated route for
/// [_i24.SettingsScreen]
class SettingsRoute extends _i26.PageRouteInfo<void> {
  const SettingsRoute({List<_i26.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i24.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i25.UnknownPathScreen]
class UnknownPathRoute extends _i26.PageRouteInfo<void> {
  const UnknownPathRoute({List<_i26.PageRouteInfo>? children})
    : super(UnknownPathRoute.name, initialChildren: children);

  static const String name = 'UnknownPathRoute';

  static _i26.PageInfo page = _i26.PageInfo(
    name,
    builder: (data) {
      return const _i25.UnknownPathScreen();
    },
  );
}
