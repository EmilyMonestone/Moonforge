#!/usr/bin/env node

/**
 * Seed Firestore using Firebase Admin SDK.
 *
 * Usage:
 *   node seed-test-campaign.mjs --project <project-id> --uid <auth-uid> [--campaign c_demo] [--cred path/to/serviceAccount.json]
 *
 * Auth options (one of):
 *   - Set GOOGLE_APPLICATION_CREDENTIALS to a service account JSON
 *   - Or pass --cred path to a service account JSON
 *   - Or use gcloud: gcloud auth application-default login
 */

import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import { initializeApp, applicationDefault, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

function parseArgs(argv) {
  const args = {};
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    const k = a.replace(/^--/, '').toLowerCase();
    const v = argv[i + 1];
    if (a.startsWith('--')) {
      if (v && !v.startsWith('--')) {
        args[k] = v;
        i++;
      } else {
        args[k] = true;
      }
    }
  }
  return args;
}

async function main() {
  const args = parseArgs(process.argv);
  const project = args.project || process.env.GCLOUD_PROJECT || process.env.GOOGLE_CLOUD_PROJECT;
  const uid = args.uid;
  const campaignId = args.campaign || 'c_demo';
  const credPath = args.cred;

  if (!project) {
    console.error('Missing --project or GCLOUD_PROJECT/GOOGLE_CLOUD_PROJECT');
    process.exit(2);
  }
  if (!uid) {
    console.error('Missing --uid');
    process.exit(2);
  }

  // Resolve data file relative to this script
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  const dataPath = path.join(__dirname, 'test-campaign-data.json');

  // Initialize Admin SDK credentials
  let app;
  try {
    if (credPath) {
      const key = JSON.parse(await fs.readFile(credPath, 'utf8'));
      app = initializeApp({ credential: cert(key), projectId: project });
    } else {
      app = initializeApp({ credential: applicationDefault(), projectId: project });
    }
  } catch (e) {
    console.error('Failed to initialize Firebase Admin credentials.');
    console.error('Tip: Set GOOGLE_APPLICATION_CREDENTIALS to a service account JSON or run: gcloud auth application-default login');
    console.error(String(e?.stack || e));
    process.exit(1);
  }

  const db = getFirestore(app);

  // Load and prepare data
  let raw = await fs.readFile(dataPath, 'utf8');
  raw = raw.replaceAll('__UID__', uid).replaceAll('__CAMPAIGN_ID__', campaignId);
  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (e) {
    console.error('Invalid JSON in test-campaign-data.json after placeholder replacement.');
    console.error(String(e?.stack || e));
    process.exit(1);
  }

  const docs = parsed?.documents;
  if (!Array.isArray(docs)) {
    console.error("Data file must contain a 'documents' array.");
    process.exit(2);
  }

  for (const entry of docs) {
    const docPath = entry?.path;
    const data = entry?.data;
    if (!docPath || typeof data !== 'object') {
      console.error('Skipping invalid document entry:', entry);
      continue;
    }
    try {
      process.stdout.write(`Seeding ${docPath}... `);
      await db.doc(docPath).set(data, { merge: true });
      console.log('OK');
    } catch (e) {
      console.error(`\nFailed to seed ${docPath}`);
      console.error(String(e?.stack || e));
      process.exit(1);
    }
  }

  console.log('Done. Verify data in Firebase Console > Firestore.');
}

main().catch((e) => {
  console.error(String(e?.stack || e));
  process.exit(1);
});

