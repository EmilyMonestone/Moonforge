# Seed a Demo Campaign (Firestore) — Copy/paste for Windows cmd.exe

This script uses the Firebase CLI to create a demo campaign with chapters, adventures, scenes, entities (including players as entities tagged `pc`), encounters, a session, and a
party. It targets the flat collection model implemented by Moonforge (campaigns, chapters, adventures, scenes, entities, encounters, parties, sessions, mediaAssets).

Prerequisites:

- Firebase CLI installed and logged in.
- You have selected your project or pass `--project` explicitly.

Usage:

- Replace `your-project-id` with your Firebase project ID.
- Replace `your-auth-uid` with the UID of the account you use in the app (so inbound sync sees the campaign).
- Open a Windows Command Prompt (cmd.exe).
- Copy-paste the entire block.

Note:

- Timestamps (`createdAt`, `updatedAt`) are omitted here; the app writes/updates them on sync. You can add them later if needed.
- Players are modeled as Entities (kind `npc` with tag `pc`) and grouped via Parties.
- Feel free to tweak names/IDs before running.

```bat
:: Set your Firebase Project ID and your authenticated user UID
set "PROJECT_ID=moonforge-bc"
set "UID=your-auth-uid"

:: Create Campaign (doc id: c_demo)
firebase firestore:documents:set campaigns/c_demo ^
  --project %PROJECT_ID% ^
  --data "{\"name\":\"Moonforge Demo Campaign\",\"description\":\"A tiny demo world to explore.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"ownerUid\":\"%UID%\",\"memberUids\":[\"%UID%\"],\"entityIds\":[],\"rev\":1,\"deleted\":false}"

:: Chapters (linked to campaignId = c_demo)
firebase firestore:documents:set chapters/chap_1 ^
  --project %PROJECT_ID% ^
  --data "{\"campaignId\":\"c_demo\",\"name\":\"Chapter 1: Into the Woods\",\"order\":0,\"summary\":\"The party enters the forest.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set chapters/chap_2 ^
  --project %PROJECT_ID% ^
  --data "{\"campaignId\":\"c_demo\",\"name\":\"Chapter 2: Town Intrigue\",\"order\":1,\"summary\":\"Mysteries in the nearby town.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[],\"rev\":1,\"deleted\":false}"

:: Adventures (linked to chapters)
firebase firestore:documents:set adventures/adv_1a ^
  --project %PROJECT_ID% ^
  --data "{\"chapterId\":\"chap_1\",\"name\":\"The Forest Path\",\"order\":0,\"summary\":\"A quiet path turns perilous.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set adventures/adv_1b ^
  --project %PROJECT_ID% ^
  --data "{\"chapterId\":\"chap_1\",\"name\":\"The Old Glade\",\"order\":1,\"summary\":\"Strange lights among ancient trees.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set adventures/adv_2a ^
  --project %PROJECT_ID% ^
  --data "{\"chapterId\":\"chap_2\",\"name\":\"Shadows in Market Square\",\"order\":0,\"summary\":\"Whispers and secret deals.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[],\"rev\":1,\"deleted\":false}"

:: Scenes (linked to adventures)
firebase firestore:documents:set scenes/scene_1a_1 ^
  --project %PROJECT_ID% ^
  --data "{\"adventureId\":\"adv_1a\",\"name\":\"Trailhead\",\"order\":0,\"summary\":\"The party sets off.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set scenes/scene_1a_2 ^
  --project %PROJECT_ID% ^
  --data "{\"adventureId\":\"adv_1a\",\"name\":\"Ambush Clearing\",\"order\":1,\"summary\":\"Bandits attack from the brush.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[\"e_bandit\"],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set scenes/scene_1b_1 ^
  --project %PROJECT_ID% ^
  --data "{\"adventureId\":\"adv_1b\",\"name\":\"Moonlit Glade\",\"order\":0,\"summary\":\"An eerie calm under the moon.\",\"content\":{\"type\":\"doc\",\"nodes\":[]},\"entityIds\":[\"e_glade_spirit\"],\"rev\":1,\"deleted\":false}"

:: Entities (players as entities with tag 'pc', plus NPCs/places/items)
firebase firestore:documents:set entities/e_frodo ^
  --project %PROJECT_ID% ^
  --data "{\"kind\":\"npc\",\"name\":\"Frodo\",\"originId\":\"c_demo\",\"summary\":\"Brave but unassuming adventurer.\",\"tags\":[\"pc\",\"ally\"],\"statblock\":{\"data\":{}},\"content\":{\"type\":\"doc\",\"nodes\":[]},\"images\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set entities/e_sam ^
  --project %PROJECT_ID% ^
  --data "{\"kind\":\"npc\",\"name\":\"Sam\",\"originId\":\"c_demo\",\"summary\":\"Loyal companion.\",\"tags\":[\"pc\",\"ally\"],\"statblock\":{\"data\":{}},\"content\":{\"type\":\"doc\",\"nodes\":[]},\"images\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set entities/e_eliara ^
  --project %PROJECT_ID% ^
  --data "{\"kind\":\"npc\",\"name\":\"Eliara the Ranger\",\"originId\":\"c_demo\",\"summary\":\"A watchful ranger of the woods.\",\"tags\":[\"ally\",\"ranger\"],\"statblock\":{\"data\":{}},\"content\":{\"type\":\"doc\",\"nodes\":[]},\"images\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set entities/e_bandit ^
  --project %PROJECT_ID% ^
  --data "{\"kind\":\"monster\",\"name\":\"Forest Bandit\",\"originId\":\"adv_1a\",\"summary\":\"Preys on travelers.\",\"tags\":[\"enemy\"],\"statblock\":{\"data\":{\"ac\":12,\"hp\":11}},\"content\":{\"type\":\"doc\",\"nodes\":[]},\"images\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set entities/e_glade_spirit ^
  --project %PROJECT_ID% ^
  --data "{\"kind\":\"monster\",\"name\":\"Glade Spirit\",\"originId\":\"adv_1b\",\"summary\":\"A restless ancient guardian.\",\"tags\":[\"fey\"],\"statblock\":{\"data\":{\"ac\":15,\"hp\":45}},\"content\":{\"type\":\"doc\",\"nodes\":[]},\"images\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set entities/e_town ^
  --project %PROJECT_ID% ^
  --data "{\"kind\":\"place\",\"name\":\"Riversmeet\",\"originId\":\"c_demo\",\"summary\":\"A bustling riverside town.\",\"placeType\":\"city\",\"coords\":{\"lat\":52.52,\"lng\":13.405},\"content\":{\"type\":\"doc\",\"nodes\":[]},\"images\":[],\"rev\":1,\"deleted\":false}"

firebase firestore:documents:set entities/e_ring ^
  --project %PROJECT_ID% ^
  --data "{\"kind\":\"item\",\"name\":\"Moonlit Ring\",\"originId\":\"c_demo\",\"summary\":\"Glimmers under moonlight.\",\"tags\":[\"trinket\"],\"content\":{\"type\":\"doc\",\"nodes\":[]},\"images\":[],\"rev\":1,\"deleted\":false}"

:: Party (references player entities)
firebase firestore:documents:set parties/party_fellowship ^
  --project %PROJECT_ID% ^
  --data "{\"campaignId\":\"c_demo\",\"name\":\"The Fellowship\",\"summary\":\"Primary adventuring group.\",\"memberEntityIds\":[\"e_frodo\",\"e_sam\"],\"rev\":1,\"deleted\":false}"

:: Encounter (linked to originId = adv_1a)
firebase firestore:documents:set encounters/enc_ambush ^
  --project %PROJECT_ID% ^
  --data "{\"name\":\"Forest Ambush\",\"originId\":\"adv_1a\",\"preset\":true,\"notes\":\"Bandits strike from the trees.\",\"loot\":\"50 gp, shortbow\",\"combatants\":[{\"id\":\"c1\",\"type\":\"entity\",\"entityId\":\"e_bandit\",\"hp\":{\"current\":11,\"max\":11},\"ac\":12,\"conditions\":[],\"note\":\"Leader\",\"initiative\":15}],\"entityIds\":[\"e_bandit\"],\"rev\":1,\"deleted\":false}"

:: Session (demo public share fields)
firebase firestore:documents:set sessions/s_demo ^
  --project %PROJECT_ID% ^
  --data "{\"info\":{\"type\":\"doc\",\"nodes\":[]},\"datetime\":null,\"log\":{\"type\":\"doc\",\"nodes\":[]},\"shareToken\":\"DEMO123\",\"shareEnabled\":false,\"shareExpiresAt\":null,\"rev\":1,\"deleted\":false}"

:: Optional: Media asset metadata (no actual files uploaded)
firebase firestore:documents:set mediaAssets/asset_demo ^
  --project %PROJECT_ID% ^
  --data "{\"filename\":\"glade.jpg\",\"size\":123456,\"mime\":\"image/jpeg\",\"captions\":[\"Moonlit glade\"],\"alt\":\"A moonlit glade\",\"variants\":[{\"kind\":\"original\",\"path\":\"media/asset_demo/original.jpg\",\"width\":1920,\"height\":1080,\"bytes\":123456}],\"rev\":1}"
```

If your Firebase CLI doesn’t support direct Firestore document write commands:

- Use the Firestore REST API with an access token (via Google Cloud SDK):

```bat
:: Requires Google Cloud SDK (gcloud). Signs in and sets project.
:: gcloud auth login
:: gcloud config set project your-project-id

for /f "usebackq tokens=*" %%A in (`gcloud auth print-access-token`) do set ACCESS_TOKEN=%%A

curl -X PATCH "https://firestore.googleapis.com/v1/projects/%PROJECT_ID%/databases/(default)/documents/campaigns/c_demo?updateMask.fieldPaths=name&updateMask.fieldPaths=description" ^
  -H "Authorization: Bearer %ACCESS_TOKEN%" ^
  -H "Content-Type: application/json" ^
  --data "{\"fields\":{\"name\":{\"stringValue\":\"Moonforge Demo Campaign\"},\"description\":{\"stringValue\":\"A tiny demo world to explore.\"}}}"
```

After seeding:

- Open the Firebase Console → Firestore to verify documents.
- Launch the app; inbound sync should pull campaigns where your signed-in user UID is in `memberUids`.
- Adjust IDs and names as needed; add more scenes/entities to expand the demo.
