# Firebase Data Schema (Firestore + Storage)

Last updated: 2025-10-14

This document describes the canonical data layout for Moonforge in Firebase. It covers Firestore collections/documents,
recommended indexes, security considerations, and Cloud Storage paths. It aligns with the current codebase, which uses a
`campaigns` root collection with `Campaign` documents containing at least `id`, `name`, and `description`.

Notes:

- All timestamps are server timestamps (`FieldValue.serverTimestamp`). Store `createdAt` when the document is first
  created, and update `updatedAt` on any mutation.
- For offline-first and conflict resolution, increment a monotonic `rev` integer on each write.
- Prefer tombstones for deletes in collaborative contexts: set `{ deleted: true, deletedAt }` and optionally purge
  later.
- Document IDs are short, URL-safe strings (client-generated or Firestore push IDs). Use lowercase and hyphens where
  human-chosen.

## Root Collections and Subcollections

Root: `/campaigns/{cid}`

A Campaign is the top-level workspace for all content. Minimal fields (as currently in code):

```jsonc
// /campaigns/{cid}
{
  "id": "auto_doc_id",        // stored as document ID; some code paths denormalize into data for convenience
  "name": "The Wild Beyond",
  "description": "Main campaign",
  "content": {                  // rich text document model (portable JSON)
    "type": "doc",
    "nodes": [/* ... */]
  },
  // recommended additions (used by rules/UI, optional for now):
  "ownerUid": "uid_123",       // who can administer the campaign
  "memberUids": ["uid_123"],   // read/write collaborators
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 1
}
```

Subresources live under each campaign as separate subcollections for sync performance and access rules.

### 1) Story Hierarchy

Path: `/campaigns/{cid}/chapters/{chapId}`

```jsonc
{
  "name": "Chapter 1: Into the Woods",
  "order": 0,                   // for manual ordering within the campaign
  "summary": "Optional short synopsis",
  "content": {                  // rich text document model (portable JSON)
    "type": "doc",
    "nodes": [/* ... */]
  },
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 3
}
```

Path: `/campaigns/{cid}/chapters/{chapId}/adventures/{advId}`

```jsonc
{
  "name": "Adventure A",
  "order": 0,
  "summary": "Optional",
  "content": {                  // rich text document model (portable JSON)
    "type": "doc",
    "nodes": [/* ... */]
  },
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 2
}
```

Path: `/campaigns/{cid}/chapters/{chapId}/adventures/{advId}/scenes/{sceneId}`

```jsonc
{
  "title": "The Glade",
  "content": {                  // rich text document model (portable JSON)
    "type": "doc",
    "nodes": [/* ... */]
  },
  "mentions": [                 // inline backlinks to entities/places/etc
    { "kind": "entity", "id": "eid_123" },
    { "kind": "scene", "id": "scene_456" }
  ],
  "mediaRefs": [               // embedded images/media from media subcollection
    { "assetId": "asset_abc", "variant": "cover" }
  ],
  "updatedAt": "<timestamp>",
  "createdAt": "<timestamp>",
  "rev": 7
}
```

Notes:

- Scenes are the granular unit edited frequently; keep them small and use references for media and mentions.
- Use `order` on chapters/adventures to reorder; scenes typically sorted by `updatedAt desc` in editor views.

### 2) Entities

Path: `/campaigns/{cid}/entities/{eid}`

```jsonc
{
  "kind": "npc",              // enum: npc | monster | group | place | item | handout | journal
  "name": "Eliara the Ranger",
  "summary": "Concise bio / description (plain or markdown)",
  "tags": ["ally", "ranger"],

  // Optional union-specific fields:
  "statblock": {                // for monsters (SRD 2024) or NPCs with combat stats
    "source": "srd|custom",    // indicates provenance
    "srdRef": "MM:Ancient-Dragon", // optional SRD id/key when source = srd
    "data": {/* snapshot of relevant combat fields */}
  },
  "placeType": "city",         // for places: world|continent|region|city|village|place|other
  "parentPlaceId": "eid_parent", // for hierarchical geography
  "coords": { "lat": 52.52, "lng": 13.405 }, // optional map pin

  // Optional content for handouts/journals/items
  "content": { /* rich text document, similar to scene.content */ },
  "images": [ { "assetId": "asset_123", "kind": "portrait" } ],

  // System fields
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 5,
  "deleted": false
}
```

Notes:

- The entity document acts as a flexible container; only `kind`, `name` are required.
- For groups/parties, you may add `members: ["eid_1", "eid_2"]`.
- For items, prefer a `props` object for modular attributes (rarity, attunement, etc.).

### 3) Encounters

Path: `/campaigns/{cid}/encounters/{encId}`

```jsonc
{
  "name": "Forest Ambush",
  "preset": true,               // whether this is a saved preset template
  "notes": "Bandits strike from the trees",
  "loot": "50 gp, shortbow",
  "combatants": [
    {
      "id": "c1",            // stable within encounter; referenced by order/turns
      "source": {              // how this combatant was created
        "type": "entity",     // entity | statblock | adHoc
        "entityId": "eid_bandit",
        "snapshot": {/* statblock subset at time of preset creation */}
      },
      "hp": { "current": 11, "max": 11 },
      "ac": 12,
      "conditions": ["poisoned"],
      "note": "Leader",
      "initiative": 15
    }
  ],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 2
}
```

Notes:

- Presets are templates; when starting a session, the initiative tracker copies a preset into the session state (see
  Sessions below).

### 4) Sessions (ephemeral runtime state)

Path: `/campaigns/{cid}/sessions/{sid}`

```jsonc
{
  "status": "active",          // inactive | active | paused | ended
  "round": 3,
  "turnIndex": 1,               // index into order[]
  "order": ["c1", "c2", "c3"], // list of combatant ids in turn order
  "visibleSceneId": "scene_abc", // DM-selected scene visible to players
  "updatesRev": 42,             // incremented on any player-visible change
  "dmUid": "uid_123",          // controlling DM
  "createdAt": "<timestamp>"
}
```

Notes:

- Session documents are treated as ephemeral and may be pruned.
- Only minimal, player-relevant state should live here; full encounter state can be derived or embedded depending on UX
  needs.

### 5) Media

Path: `/campaigns/{cid}/media/{assetId}`

```jsonc
{
  "filename": "glade.jpg",
  "size": 482193,               // bytes
  "mime": "image/jpeg",
  "captions": ["Nighttime glade"],
  "alt": "A moonlit glade",
  "variants": [
    { "kind": "original", "path": "campaigns/cid/media/assetId/original.jpg", "width": 3840, "height": 2160, "bytes": 482193 },
    { "kind": "thumb",    "path": "campaigns/cid/media/assetId/thumb.jpg",    "width": 320,  "height": 180,  "bytes": 12345 }
  ],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 1
}
```

Storage path convention (Cloud Storage):

- `campaigns/{cid}/media/{assetId}/original.ext`
- `campaigns/{cid}/media/{assetId}/{variant}.ext` (e.g., thumb, medium, webp, avif)

### 6) Short Join Codes (Player View)

Path: `/joins/{code}` (standalone collection, not under a campaign)

```jsonc
{
  "cid": "campaign_id",
  "sid": "session_id",
  "createdAt": "<timestamp>",
  "ttl": "<timestamp>"        // when this code expires; used by TTL + Functions cleanup
}
```

Notes:

- Codes are created and managed by a Cloud Function. The function also ensures TTL expiry (via Firestore TTL policy or
  scheduled cleanup) and minimizes write amplification.
- Clients should exchange a code for a scoped player session token, not read `/joins` directly in untrusted contexts.

## Query Patterns and Recommended Indexes

Common queries:

- List campaigns for a user: `collection('campaigns').where('memberUids', arrayContains: uid).orderBy('name')` →
  composite index on `memberUids` + `name`.
- Chapters: order by `order` within a campaign.
- Adventures: order by `order` within chapter.
- Scenes: order by `updatedAt desc` within an adventure.
- Entities: filter by `kind` and `tags` with sorts by `name` or `updatedAt`.

Suggested composite indexes (pseudo-spec; create via Firebase Console or `firestore.indexes.json`):

- Collection group: `entities`
    - Fields: `kind ASC`, `name ASC`
    - Fields: `kind ASC`, `updatedAt DESC`
    - Fields: `tags ARRAY_CONTAINS`, `updatedAt DESC`
- Collection group: `chapters` → `order ASC`
- Collection group: `adventures` → `order ASC`
- Collection group: `scenes` → `updatedAt DESC`

## Security Considerations (high-level)

Principles:

- Only campaign owners/members can read/write full campaign data.
- Player View is read-only and scoped to the active session and DM-selected scene/media. Avoid granting players broad
  read access to campaign data.
- Joins are mediated by a trusted backend (Cloud Function). Clients should never write `/joins` directly.

Recommended rule shape (conceptual):

- `/campaigns/{cid}`: allow read/write to `request.auth.uid in resource.data.memberUids` (owners subset administer
  members). Deny otherwise.
- `/campaigns/{cid}/sessions/{sid}`: allow read to players scoped to `{cid, sid}` (derived from a Function-issued custom
  claim or a temporary mapping like `/campaigns/{cid}/sessionPlayers/{uid}` containing `{ sid, expiresAt }`). Writes
  restricted to DM.
- `/campaigns/{cid}/chapters|adventures|scenes|entities|encounters|media`: inherit from campaign-level membership.
- `/joins/{code}`: no direct client access; only Functions service account may read/write.

If using custom claims for Player View:

- Function validates the code, sets a short-lived claim `{ role: 'player', cid, sid, exp }`. Rules check these claims
  for read access to the selected scene and minimal session fields.

If using a mapping doc instead of claims:

- Function writes `/campaigns/{cid}/sessionPlayers/{uid}` with `{ sid, ttl }`. Rules allow read of specific
  session/scene docs where `resource.id == sid` and the mapping exists and is not expired.

## Data Validation Guidelines

- `rev`: integer, increment per successful write; use it to detect lost updates.
- `createdAt` is immutable after set; `updatedAt` always reflects last mutation.
- `kind` enum for entities must be one of: `npc | monster | group | place | item | handout | journal`.
- `placeType` enum must be one of: `world | continent | region | city | village | place | other`.
- `tags`: small array of lowercase slugs; deduplicate.
- `mentions`: each item `{ kind: string, id: string }` where kind is a known collection key.
- Avoid storing large blobs in Firestore; use Storage and reference with `mediaRefs`.

## Cloud Functions (suggested responsibilities)

- Join codes: create, validate, expire; mediate player session access (custom claims or mapping docs). Enforce TTL on
  `/joins/{code}`.
- Media processing: generate variants, write metadata into `/media/{assetId}.variants`.
- Optional: on campaign creation, bootstrap default chapter/adventure structure.

## Example End-to-End Document Paths

- Campaign: `/campaigns/c123`
- Chapter: `/campaigns/c123/chapters/chap-1`
- Adventure: `/campaigns/c123/chapters/chap-1/adventures/adv-1`
- Scene: `/campaigns/c123/chapters/chap-1/adventures/adv-1/scenes/scene-42`
- Entity (place): `/campaigns/c123/entities/e-paris`
- Encounter: `/campaigns/c123/encounters/enc-forest-ambush`
- Session: `/campaigns/c123/sessions/s-2025-10-14`
- Media: `/campaigns/c123/media/asset-xyz`
- Join: `/joins/ABCD12`

## Alignment with Current Code

- The Flutter app currently defines a `Campaign` model with fields `{ id, name, description }` and uses the `campaigns`
  collection directly (see `lib/core/models/campaign.dart`, `lib/core/models/schema.dart`, and
  `lib/core/providers/campaign_providers.dart`).
- This schema adds recommended fields (`ownerUid`, `memberUids`, timestamps, `rev`) that you can adopt incrementally
  without breaking existing reads. Writes should start populating them for new documents.

## Migration Tips

- Backfill `createdAt`, `updatedAt`, and `rev` lazily on write if missing.
- When introducing membership, default `memberUids` to `[ownerUid]` and retrofit existing campaigns with the creator as
  owner.
- Use small, targeted composite indexes; inspect Firestore error logs for suggested index definitions as features roll
  out.
