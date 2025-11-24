# Campaign Feature

Manages D&D campaigns including creation, editing, and organization.

Structure

```
lib/features/campaign/
├── controllers/   # State management (providers)
├── services/      # Business logic
├── utils/         # Utilities and helpers
├── views/         # Screens and UI views
└── widgets/       # Reusable components
```

Key Components

- `CampaignProvider` — State management for the current campaign selection and persisted preference.
- `CampaignService` — Business logic for duplicating, archiving, restoring campaigns and computing campaign statistics.
- `CampaignRepository` — Data access layer using Drift.
- `CampaignCard` — Reusable UI component to display a campaign in lists.

Usage

- View campaign list: `CampaignListView` in `views/`
- Edit/Create campaign: `CampaignEditView`

Testing

- Unit tests: `test/features/campaign/services/`
- Provider tests: `test/features/campaign/controllers/`
- Widget tests: `test/features/campaign/widgets/`

Notes

- Keep UI logic in widgets; business rules live in `services/`.
- Persisted selection is implemented via `PersistenceService` in `controllers/campaign_provider.dart`.

