# GitHub Secrets Setup for CI/CD

This document explains how to set up the required GitHub secrets for the Moonforge build and release workflows.

## Required Secrets

### FIREBASE_WEB_API_KEY

The `FIREBASE_WEB_API_KEY` secret is required for building the application. This API key is used by the web platform to connect to Firebase services.

**How to get the Firebase Web API Key:**

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project (moonforge-bc)
3. Click on the gear icon (⚙️) next to "Project Overview"
4. Select "Project settings"
5. Scroll down to "Your apps" section
6. Select your Web app (or create one if it doesn't exist)
7. In the "SDK setup and configuration" section, find the `apiKey` value in the Firebase configuration object

**How to add the secret to GitHub:**

1. Go to your repository on GitHub: https://github.com/EmilyMoonstone/Moonforge
2. Click on "Settings" tab
3. In the left sidebar, click on "Secrets and variables" → "Actions"
4. Click "New repository secret"
5. Name: `FIREBASE_WEB_API_KEY`
6. Value: Paste your Firebase Web API key (e.g., `AIzaSyABC123...`)
7. Click "Add secret"

## How the Secret is Used

The GitHub Actions workflow (`.github/workflows/release.yml`) creates a `.env` file during the build process with this secret:

```yaml
- name: Create .env file
  working-directory: moonforge
  run: |
    echo "FIREBASE_API_KEY=${{ secrets.FIREBASE_WEB_API_KEY }}" > .env
  shell: bash
```

This ensures the `.env` file exists during the build, satisfying the Flutter asset requirements declared in `pubspec.yaml`.

## Local Development

For local development, developers should:

1. Copy the `.env.example` file to `.env`:
   ```bash
   cd moonforge
   cp .env.example .env
   ```

2. Edit the `.env` file and add their Firebase Web API key:
   ```
   FIREBASE_API_KEY=your-firebase-web-api-key-here
   ```

3. The `.env` file is gitignored, so it won't be committed to the repository

## Troubleshooting

### Build fails with "unable to find directory entry in pubspec.yaml"

This error occurs when the `.env` file or `assets/images/` directory is missing. Make sure:

1. The `FIREBASE_WEB_API_KEY` secret is set in GitHub repository settings
2. The `.env` file creation step runs successfully in the workflow
3. The `moonforge/assets/images/` directory exists (it should contain a `.gitkeep` file)

### Where to find the API key

The Firebase Web API key is **not sensitive** for client-side applications. It's safe to use in public builds because Firebase Security Rules protect your data, not the API key. However, we store it as a secret to keep the configuration centralized and avoid committing it to the repository.

For more information about Firebase API key security, see:
- [Firebase API Key Security FAQ](https://firebase.google.com/docs/projects/api-keys)
