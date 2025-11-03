# Firebase Data Schema (Firestore + Storage)

Last updated: 2025-11-03

This document describes the canonical data layout for Moonforge in Firebase as implemented by the local-first sync layer
(Drift + Firestore). It covers Firestore collections/documents, recommended indexes, security considerations, and Cloud
Storage paths. The current app uses flat, top-level Firestore collections with foreign keys (e.g., campaignId, chapterId,
adventureId, originId) rather than nested subcollections.

Notes:

- All timestamps are server timestamps (`FieldValue.serverTimestamp`) on write where appropriate. Store `createdAt` when the
  document is first created, and update `updatedAt` on any mutation.
- For offline-first and conflict resolution, increment a monotonic `rev` integer on each write.
- Prefer tombstones for deletes in collaborative contexts: set `{ deleted: true, deletedAt }` and optionally purge later.
  The outbox sync performs a soft delete like this across collections.
- Document IDs are short, URL-safe strings (client-generated or Firestore push IDs). Use lowercase and hyphens where
  human-chosen.

## Collections and Document Shapes (flat model)

Top-level collections used by the app:

- `/campaigns/{cid}`
- `/chapters/{chapId}` (FK: `campaignId`)
- `/adventures/{advId}` (FK: `chapterId`)
- `/scenes/{sceneId}` (FK: `adventureId`)
- `/entities/{eid}` (FK-like: `originId` referencing a campaign/chapter/adventure/scene)
- `/encounters/{encId}` (FK-like: `originId` referencing a campaign/chapter/adventure/scene)
- `/parties/{partyId}` (FK: `campaignId`)
- `/players/{playerId}` (FK: `campaignId`)
- `/mediaAssets/{assetId}`
- `/sessions/{sid}`

A Campaign is the top-level workspace. Minimal fields (as implemented):

```jsonc
// /campaigns/{cid}
{
  "name": "The Wild Beyond",
  "description": "Main campaign",
  "content": {                  // rich text (Quill delta JSON stored as Map)
    "ops": [ { "insert": "...\n" } ]
  },
  "ownerUid": "uid_123",       // who can administer the campaign
  "memberUids": ["uid_123"],   // read/write collaborators
  "entityIds": ["eid_1", "eid_2"], // optional associations used by UI
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 1,
  // soft-delete fields may appear when deleted
  "deleted": false,
  "deletedAt": "<timestamp>"
}
```

### 1) Story Hierarchy (flat with foreign keys)

Path: `/chapters/{chapId}` (chapter belongs to a campaign via `campaignId`)

```jsonc
{
  "campaignId": "c123",
  "name": "Chapter 1: Into the Woods",
  "order": 0,
  "summary": "Optional short synopsis",
  "content": { "ops": [ { "insert": "...\n" } ] },
  "entityIds": ["eid_1", "eid_2"],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 3,
  "deleted": false
}
```

Path: `/adventures/{advId}` (adventure belongs to a chapter via `chapterId`)

```jsonc
{
  "chapterId": "chap-1",
  "name": "Adventure A",
  "order": 0,
  "summary": "Optional",
  "content": { "ops": [ { "insert": "...\n" } ] },
  "entityIds": ["eid_1"],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 2,
  "deleted": false
}
```

Path: `/scenes/{sceneId}` (scene belongs to an adventure via `adventureId`)

```jsonc
{
  "adventureId": "adv-1",
  "name": "The Glade",
  "order": 0,
  "summary": "Optional",
  "content": { "ops": [ { "insert": "...\n" } ] },
  "entityIds": ["eid_123"],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 7,
  "deleted": false
}
```

### 2) Entities (flat)

Path: `/entities/{eid}`

```jsonc
{
  "kind": "npc",              // npc | monster | group | place | item | handout | journal
  "name": "Eliara the Ranger",
  "originId": "c123",        // owning context: campaignId OR a chapter/adventure/scene id
  "summary": "Concise bio / description",
  "tags": ["ally", "ranger"],
  "statblock": { "data": { /* custom */ } },
  "placeType": "city",
  "parentPlaceId": "eid_parent",
  "coords": { "lat": 52.52, "lng": 13.405 },
  "content": { "ops": [ { "insert": "...\n" } ] },
  "images": [ { "assetId": "asset_123", "kind": "portrait" } ],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 5,
  "deleted": false,
  "members": ["eid_1", "eid_2"]
}
```

### 3) Encounters (flat)

Path: `/encounters/{encId}`

```jsonc
{
  "name": "Forest Ambush",
  "originId": "c123",
  "preset": true,
  "notes": "Bandits strike from the trees",
  "loot": "50 gp, shortbow",
  "combatants": [ { /* flexible maps */ } ],
  "entityIds": ["eid_bandit"],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 2,
  "deleted": false
}
```

### 4) Sessions (flat)

Path: `/sessions/{sid}`

```jsonc
{
  "createdAt": "<timestamp>",
  "info": { "ops": [ { "insert": "...\n" } ] },   // DM-only notes
  "datetime": "<timestamp>",
  "log": { "ops": [ { "insert": "...\n" } ] },    // shared with players
  "shareToken": "abcdef",
  "shareEnabled": false,
  "shareExpiresAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 1,
  "deleted": false
}
```

### 5) Media Assets (flat)

Path: `/mediaAssets/{assetId}`

```jsonc
{ /* unchanged from previous section */ }
```

### 6) Parties (flat)

Path: `/parties/{partyId}`

```jsonc
{
  "campaignId": "c123",
  "name": "The Fellowship",
  "summary": "Primary adventuring group",
  "memberPlayerIds": ["p_frodo", "p_sam"],
  // Legacy: memberEntityIds may exist in older data; prefer memberPlayerIds going forward
  "memberEntityIds": [],
  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 1,
  "deleted": false
}
```

### 7) Players (flat)

Players represent actual player characters (PCs) with common D&D character sheet fields.

Path: `/players/{playerId}`

```jsonc
{
  "campaignId": "c123",
  "playerUid": "auth_uid_optional",  // owning user account (optional)
  "name": "Frodo",
  "className": "Fighter",            // character class
  "subclass": null,
  "level": 1,
  "race": "Halfling",
  "background": "Folk Hero",
  "alignment": "NG",

  // Ability scores
  "str": 10, "dex": 14, "con": 12, "int": 10, "wis": 12, "cha": 14,

  // Core stats
  "hpMax": 11, "hpCurrent": 11, "hpTemp": 0,
  "ac": 12, "proficiencyBonus": 2, "speed": 25,

  // Proficiencies & gear
  "savingThrowProficiencies": ["dex", "con"],
  "skillProficiencies": ["perception", "stealth"],
  "languages": ["common", "halfling"],
  "equipment": ["shortsword", "leather armor", "rations"],
  "features": [ { "name": "Lucky", "text": "Reroll 1s." } ],
  "spells": [ ],

  // Rich text fields
  "notes": { "ops": [ { "insert": "Personal notes...\n" } ] },
  "bio": { "ops": [ { "insert": "Backstory...\n" } ] },

  "createdAt": "<timestamp>",
  "updatedAt": "<timestamp>",
  "rev": 1,
  "deleted": false
}
```

### 8) Short Join Codes (Player View) — planned

Path: `/joins/{code}` (standalone collection, not under a campaign)

```jsonc
{ /* unchanged from previous section */ }
```

## Query Patterns and Recommended Indexes

Common queries (flat collections):

- Players by campaign: `collection('players').where('campaignId','==',cid).orderBy('name')` → index on `campaignId` + `name`.
- Parties by campaign: `collection('parties').where('campaignId','==',cid)`.
- The rest unchanged (chapters/adventures/scenes/entities/encounters/sessions/mediaAssets).

Suggested composite indexes (additional):

- Collection: `players` → fields: `campaignId ASC`, `name ASC`

## Security Considerations (high-level)

- Parties should list players by ID in `memberPlayerIds`. Entities remain for NPCs, items, places, etc.
- Player docs are writable by their owning DM or player; model rules to allow the player owning `playerUid` to update
  their character while restricting others.

## Data Validation Guidelines

- `rev`: integer, increment per successful write; use it to detect lost updates.
- `createdAt` is immutable after set; `updatedAt` always reflects last mutation.
- `kind` enum for entities must be one of: `npc | monster | group | place | item | handout | journal`.
- `placeType` enum must be one of: `world | continent | region | city | village | place | other`.
- `tags`: small array of lowercase slugs; deduplicate.
- Avoid storing large blobs in Firestore; use Storage and reference with media asset IDs (`images[].assetId`).
- Soft delete: any collection document may include `deleted` and `deletedAt` markers when removed.

## Cloud Functions (suggested responsibilities)

- Join codes: create, validate, expire; mediate player session access (custom claims or mapping docs). Enforce TTL on
  `/joins/{code}`.
- Media processing: generate variants, write metadata into `/mediaAssets/{assetId}.variants`.
- Optional: on campaign creation, bootstrap default chapter/adventure structure.

## Example End-to-End Document Paths (flat)

- Campaign: `/campaigns/c123`
- Chapter: `/chapters/chap-1` (campaignId = `c123`)
- Adventure: `/adventures/adv-1` (chapterId = `chap-1`)
- Scene: `/scenes/scene-42` (adventureId = `adv-1`)
- Entity (place): `/entities/e-paris` (originId = `c123`)
- Encounter: `/encounters/enc-forest-ambush` (originId = `c123`)
- Party: `/parties/party-xyz` (campaignId = `c123`)
- Player: `/players/p_frodo` (campaignId = `c123`)
- Session: `/sessions/s-2025-10-14`
- Media: `/mediaAssets/asset-xyz`
- Join (planned): `/joins/ABCD12`

## Alignment with Current Code

The implementation of the local-first schema and sync is here:

- Drift table definitions: `moonforge/lib/data/db/tables.dart`
- Firestore mapping helpers: `moonforge/lib/data/db/firestore_mappers.dart`
- Sync engine:
    - Outgoing (local→cloud): `moonforge/lib/data/db/sync/outbox_processor.dart`
    - Incoming (cloud→local): `moonforge/lib/data/db/sync/inbound_listener.dart`
    - Coordinator: `moonforge/lib/data/db/sync/sync_coordinator.dart`

Key field alignments:

- Campaigns have: `name`, `description`, `content` (Quill JSON), `ownerUid`, `memberUids`, `entityIds`, timestamps, `rev`.
- Chapters/Adventures/Scenes are flat with foreign keys and have `order`, `summary`, `content`, `entityIds`, timestamps, `rev`.
- Entities have `originId` and support `tags`, `statblock`, `placeType`, `parentPlaceId`, `coords`, `images`, `members`,
  timestamps, `rev`, and `deleted`.
- Encounters have `originId`, `preset`, `notes`, `loot`, `combatants` (list of maps), `entityIds`, timestamps, `rev`.
- Parties have `campaignId`, `memberEntityIds`, timestamps, `rev`.
- Players have `campaignId`, `playerUid`, character fields (`name`, `className`, etc.), rich text fields (`notes`, `bio`), timestamps, `rev`.
- Sessions currently lack `campaignId` and include public share fields: `shareToken`, `shareEnabled`, `shareExpiresAt`.
- Media assets live in `/mediaAssets` with metadata and `variants`.

## Migration Tips

- If moving from nested to flat collections, write one-time migration scripts to fan out subcollections into the flat
  collections with proper foreign keys (`campaignId`, `chapterId`, `adventureId`, `originId`).
- Backfill `createdAt`, `updatedAt`, and `rev` lazily on write if missing.
- When introducing membership, default `memberUids` to `[ownerUid]` and retrofit existing campaigns with the creator as
  owner.
- Use small, targeted composite indexes; inspect Firestore error logs for suggested index definitions as features roll out.
