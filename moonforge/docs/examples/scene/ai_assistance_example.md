# Scene AI Assistance Example

This example shows how to embed Gemini-powered AI assistance in the scene editor UI.

> Original location: `lib/features/scene/EXAMPLE_AI_INTEGRATION.dart`

## Integration steps

1. **Imports** – add these to `scene_edit_view.dart`:

   ```dart
   import 'package:moonforge/core/widgets/ai/ai_assistance_widget.dart';
   import 'package:moonforge/core/services/story_context_builder.dart';
   import 'package:moonforge/core/models/ai/story_context.dart';
   import 'package:moonforge/data/repo/adventure_repository.dart';
   import 'package:moonforge/data/repo/campaign_repository.dart';
   import 'package:moonforge/data/repo/chapter_repository.dart';
   import 'package:moonforge/data/repo/scene_repository.dart';
   import 'package:moonforge/data/repo/entity_repository.dart';
   ```

2. **State** – inside `_SceneEditViewState` keep a `StoryContext?`:

   ```dart
   StoryContext? _storyContext;
   ```

3. **Load context** – after loading the scene, build the context:

   ```dart
   final contextBuilder = StoryContextBuilder(
     campaignRepo: context.read<CampaignRepository>(),
     chapterRepo: context.read<ChapterRepository>(),
     adventureRepo: context.read<AdventureRepository>(),
     sceneRepo: context.read<SceneRepository>(),
     entityRepo: context.read<EntityRepository>(),
   );

   _storyContext = await contextBuilder.buildForScene(widget.sceneId);
   ```

4. **Render widget** – insert the AI widget below the scene content label:

   ```dart
   if (_storyContext != null)
     Padding(
       padding: const EdgeInsets.only(bottom: 12),
       child: AiAssistanceWidget(
         context: _storyContext!,
         type: AiAssistanceType.content,
         currentContent: _contentController.document.toPlainText(),
         onContentGenerated: (generatedText) {
           final length = _contentController.document.length;
           _contentController.document.insert(length - 1, '\n\n$generatedText');
           toastification.show(
             type: ToastificationType.success,
             title: const Text('AI content inserted'),
             autoCloseDuration: const Duration(seconds: 3),
           );
         },
       ),
     );
   ```

5. **Result** – AI buttons appear when a Gemini API key exists in `.env`, offering "Continue Writing" and "Generate Content" options. Errors and loading states are handled inside
   `AiAssistanceWidget`.

For Entity editors, use `AiAssistanceType.npc` and populate entity fields inside `onContentGenerated`.

More background: `docs/gemini_integration.md`.

