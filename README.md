# Moonforge
A multiplatform manager for Dungeons&Dragons campaigns written in flutter.

## Features
- Campaign management
- Writing story content with markdown-compatible editor
- Entity management (locations, items, characters)
- Tagging and linking between entities and story content
- Session notes
- Media management (images, audio, video)
- Synchronization across devices with firebase; offline-first
- Player view for read-only access to campaign content
- Encounter builder and initiative tracker
- NPC and monster management; integration with D&D SRD
- Multi-window support on desktop

## Platforms
| Platform                                | Features                                                                                                             |
|-----------------------------------------| -------------------------------------------------------------------------------------------------------------------- |
| **Desktop (Win/macOS (planned)/Linux)** | Full feature set; multi-window; drag-drop media; split panes.                                                        |
| **Web**                                 | Same as desktop; Player opens in new tab; filesystem access limited.                                                 |
| **Mobile (Android/iOS (planned))**      | No multi-window; trimmed editor; read-only Player view; limited media management; background sync defaults to Wi-Fi. |

## Contributing