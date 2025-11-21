# Gemini AI Integration

This document describes how Gemini AI is integrated into Moonforge to assist with story content generation.

## Overview

Moonforge uses Google's Gemini AI (via the `flutter_gemini` package) to help dungeon masters create and expand their campaign content. The AI maintains story coherence by always being aware of the campaign context.

## Features

### 1. Writing Completion
Continue existing story content from the current point. The AI understands the context and continues in a consistent style.

**Use cases:**
- Finish a partially written scene
- Expand on an existing narrative
- Continue dialogue or descriptions

### 2. Section Generation
Generate complete narrative sections including:
- **Chapters**: Large story arcs with multiple scenes
- **Adventures**: Medium-sized quest segments
- **Scenes**: Individual encounters or locations

**Parameters:**
- Title
- Outline (optional)
- Key elements to include (optional)
- Previous section summary (for continuity)

### 3. NPC Creation
Generate non-player characters with rich details:
- Name
- Physical appearance
- Personality traits
- Backstory
- Role in the story
- Motivations
- Secrets (plot hooks)

**Constraints available:**
- Role (e.g., "tavern keeper", "city guard")
- Species/Race (e.g., "dwarf", "elf")
- Alignment (e.g., "Lawful Good")
- Relationship to party (e.g., "friendly", "hostile")
- Specific traits

## Setup

### 1. API Key Configuration

Get a Gemini API key from [Google AI Studio](https://aistudio.google.com/app/apikey).

Add it to your `.env` file:
```
GEMINI_API_KEY=your-api-key-here
```

### 2. Initialization

The Gemini service is automatically initialized in `lib/core/providers/providers.dart` if the API key is present.

```dart
// In providers.dart
if (geminiApiKey != null && geminiApiKey.isNotEmpty) {
  GeminiProvider.initialize(geminiApiKey);
}
```

### 3. Provider Access

Access the Gemini service through the provider:

```dart
final geminiProvider = context.watch<GeminiProvider?>();
if (geminiProvider != null) {
  // Use the service
  final response = await geminiProvider.service.continueStory(request);
}
```

## Architecture

### Core Components

#### 1. Models (`lib/core/models/ai/`)
- **StoryContext**: Represents the campaign/story context
- **GenerationRequest**: Request models for different generation types
- **GenerationResponse**: Response models with generated content

#### 2. Services (`lib/core/services/`)
- **GeminiService**: Wrapper around flutter_gemini, handles all AI requests
- **StoryContextBuilder**: Builds story context from database entities

#### 3. Providers (`lib/core/providers/`)
- **GeminiProvider**: State management for AI generation

#### 4. Widgets (`lib/core/widgets/ai/`)
- **AiAssistanceWidget**: Reusable UI component for AI features

### Story Context

The `StoryContext` model ensures the AI always has access to:
- Campaign name and description
- Current chapter/adventure/scene hierarchy
- Recent story content
- List of key NPCs and entities
- World/setting notes
- Style guidelines

### Context Building

The `StoryContextBuilder` service automatically gathers context from:
- Campaign entities
- Chapter summaries
- Adventure content
- Previous scenes
- Related NPCs and locations

## Usage Examples

### In a Scene Editor

```dart
import 'package:moonforge/core/widgets/ai/ai_assistance_widget.dart';
import 'package:moonforge/core/services/story_context_builder.dart';

// Build context
final contextBuilder = StoryContextBuilder(
  campaignRepo: context.read<CampaignRepository>(),
  chapterRepo: context.read<ChapterRepository>(),
  adventureRepo: context.read<AdventureRepository>(),
  sceneRepo: context.read<SceneRepository>(),
  entityRepo: context.read<EntityRepository>(),
);

final storyContext = await contextBuilder.buildForScene(sceneId);

// Add AI assistance widget
AiAssistanceWidget(
  context: storyContext,
  type: AiAssistanceType.content,
  currentContent: currentSceneText,
  onContentGenerated: (generatedText) {
    // Insert generated text into editor
    _insertText(generatedText);
  },
)
```

### For NPC Generation

```dart
AiAssistanceWidget(
  context: storyContext,
  type: AiAssistanceType.npc,
  onContentGenerated: (npcData) {
    // Save NPC to database
    _createEntityFromAiData(npcData);
  },
)
```

### Manual API Usage

```dart
final geminiProvider = context.read<GeminiProvider>();

// Continue writing
final request = CompletionRequest(
  context: storyContext,
  currentContent: 'The party entered the dark tavern...',
  desiredDirection: 'Introduce a mysterious hooded figure',
);

final response = await geminiProvider.service.continueStory(request);

if (response.success && response.content != null) {
  print(response.content);
}
```

## Prompt Engineering

The service builds context-aware prompts that:
1. Establish role: "You are a creative dungeon master..."
2. Provide campaign details
3. Include character/entity information
4. Reference recent story events
5. Apply style guidelines
6. Give specific instructions for the requested content

Example prompt structure:
```
You are a creative dungeon master and storyteller.

Campaign: The Lost Mines of Phandelver
Campaign Description: A classic adventure...

Chapter: Into the Darkness
Adventure: The Redbrand Hideout
Scene: The Trapped Hallway

Key Characters:
- Sildar Hallwinter (NPC): Friendly human warrior
- Iarno Albrek (NPC): Corrupt wizard

Recent Content:
[Last 3 scenes summarized]

Current Content:
The party entered the tavern...

Continue the story from where it left off. Maintain consistency...
```

## Best Practices

1. **Always provide context**: Use StoryContextBuilder to ensure complete context
2. **Review generated content**: AI is creative but may need editing
3. **Save original content**: Keep backups before replacing with AI-generated text
4. **Iterate**: Regenerate if the first result doesn't fit
5. **Guide the AI**: Use outlines and key elements to steer generation
6. **Maintain consistency**: Update entity descriptions and summaries regularly

## Token Limits

Gemini has token limits. The service automatically limits:
- Completion requests: 500 tokens by default
- Section generation: 1500 tokens by default  
- NPC generation: 800 tokens by default

Adjust `maxTokens` parameter if needed.

## Error Handling

The service handles errors gracefully:
- Returns `success: false` with error message
- Shows toast notifications in UI
- Logs errors for debugging

## Security

- API keys are stored in `.env` (not committed to git)
- No sensitive campaign data is sent except what's needed for context
- All API calls are made from the client (no intermediary server)

## Future Enhancements

Potential improvements:
- [ ] Cache story summaries to reduce token usage
- [ ] Support for multiple AI models/providers
- [ ] Fine-tuning based on campaign style
- [ ] Batch generation for multiple sections
- [ ] Integration with image generation for character portraits
- [ ] Voice-to-text for session notes with AI summarization
