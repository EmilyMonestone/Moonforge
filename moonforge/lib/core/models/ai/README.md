# Gemini AI Integration

This directory contains the AI integration components for Moonforge.

## Quick Start

1. Get a Gemini API key from [Google AI Studio](https://aistudio.google.com/app/apikey)

2. Add it to your `.env` file:
   ```
   GEMINI_API_KEY=your-api-key-here
   ```

3. Use the AI assistance widget in any editor:
   ```dart
   import 'package:moonforge/core/widgets/ai/ai_assistance_widget.dart';
   
   AiAssistanceWidget(
     context: storyContext,
     type: AiAssistanceType.content,
     currentContent: currentText,
     onContentGenerated: (text) => insertText(text),
   )
   ```

## What's Included

### Models (`lib/core/models/ai/`)
- `story_context.dart` - Story context for AI generation
- `generation_request.dart` - Request models for different generation types
- `generation_response.dart` - Response models with generated content

### Services (`lib/core/services/`)
- `gemini_service.dart` - Main service wrapper for Gemini API
- `story_context_builder.dart` - Builds context from database entities

### Providers (`lib/core/providers/`)
- `gemini_provider.dart` - State management for AI operations

### Widgets (`lib/core/widgets/ai/`)
- `ai_assistance_widget.dart` - Reusable UI component

## Features

1. **Writing Completion** - Continue story from current point
2. **Section Generation** - Generate chapters, adventures, or scenes
3. **NPC Creation** - Generate detailed NPCs with personality and backstory

## Documentation

See [docs/gemini_integration.md](../../../docs/gemini_integration.md) for comprehensive documentation.

## Tests

Tests are in `test/core/services/gemini_models_test.dart`

Run with:
```bash
flutter test test/core/services/gemini_models_test.dart
```
