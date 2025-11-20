/// EXAMPLE: How to integrate AI assistance into the Scene Edit Screen
/// 
/// This file shows how to add Gemini AI assistance to the scene editor.
/// Follow these steps to enable AI content generation in your editor.

/*
Step 1: Import required dependencies at the top of scene_edit_screen.dart:

import 'package:moonforge/core/widgets/ai/ai_assistance_widget.dart';
import 'package:moonforge/core/services/story_context_builder.dart';
import 'package:moonforge/core/models/ai/story_context.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';


Step 2: Add state variables to _SceneEditScreenState:

StoryContext? _storyContext;


Step 3: Build the story context in _loadScene() method after loading the scene:

  Future<void> _loadScene() async {
    setState(() => _isLoading = true);
    try {
      // ... existing code to load scene ...
      
      // Build story context for AI
      final contextBuilder = StoryContextBuilder(
        campaignRepo: context.read<CampaignRepository>(),
        chapterRepo: context.read<ChapterRepository>(),
        adventureRepo: context.read<AdventureRepository>(),
        sceneRepo: context.read<SceneRepository>(),
        entityRepo: context.read<EntityRepository>(),
      );
      
      _storyContext = await contextBuilder.buildForScene(widget.sceneId);
      
      // ... rest of existing code ...
    } catch (e) {
      // ... existing error handling ...
    } finally {
      setState(() => _isLoading = false);
    }
  }


Step 4: Add the AI assistance widget in the build method, 
        after line 280 (below the "Rich text content of the scene" text):

            const SizedBox(height: 12),
            // AI Assistance Widget
            if (_storyContext != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AiAssistanceWidget(
                  context: _storyContext!,
                  type: AiAssistanceType.content,
                  currentContent: _contentController.document.toPlainText(),
                  onContentGenerated: (generatedText) {
                    // Insert generated text at the end of current content
                    final length = _contentController.document.length;
                    _contentController.document.insert(length - 1, '\n\n$generatedText');
                    
                    // Show success message
                    toastification.show(
                      type: ToastificationType.success,
                      title: const Text('AI content inserted'),
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  },
                ),
              ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                // ... rest of toolbar container


Step 5: That's it! The AI assistance buttons will now appear above the editor
        toolbar if a Gemini API key is configured in .env

        The widget automatically:
        - Shows/hides based on Gemini initialization
        - Handles loading states
        - Shows error messages
        - Provides "Continue Writing" and "Generate Content" buttons


Alternative: For NPC generation in Entity editor, use:

AiAssistanceWidget(
  context: storyContext,
  type: AiAssistanceType.npc,
  onContentGenerated: (npcData) {
    // Parse and populate NPC fields
    _nameController.text = extractName(npcData);
    _summaryController.text = extractSummary(npcData);
    // ... populate other fields
  },
)


For more details, see docs/gemini_integration.md
*/
