import 'package:flutter/material.dart';
import 'package:moonforge/core/models/ai/generation_request.dart';
import 'package:moonforge/core/models/ai/generation_response.dart';
import 'package:moonforge/core/models/ai/story_context.dart';
import 'package:moonforge/core/providers/gemini_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

/// Widget that provides AI assistance buttons for content generation
class AiAssistanceWidget extends StatefulWidget {
  final StoryContext context;
  final AiAssistanceType type;
  final Function(String content) onContentGenerated;
  final String? currentContent;

  const AiAssistanceWidget({
    super.key,
    required this.context,
    required this.type,
    required this.onContentGenerated,
    this.currentContent,
  });

  @override
  State<AiAssistanceWidget> createState() => _AiAssistanceWidgetState();
}

class _AiAssistanceWidgetState extends State<AiAssistanceWidget> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final geminiProvider = context.watch<GeminiProvider?>();

    // Don't show if Gemini is not initialized
    if (geminiProvider == null) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (widget.type == AiAssistanceType.content &&
            widget.currentContent != null)
          _buildButton(
            context,
            icon: Icons.auto_fix_high,
            label: 'Continue Writing',
            onPressed: _isGenerating
                ? null
                : () => _continueWriting(geminiProvider),
          ),
        if (widget.type == AiAssistanceType.content)
          _buildButton(
            context,
            icon: Icons.edit_note,
            label: 'Generate Content',
            onPressed: _isGenerating
                ? null
                : () => _generateContent(geminiProvider),
          ),
        if (widget.type == AiAssistanceType.npc)
          _buildButton(
            context,
            icon: Icons.person_add,
            label: 'Generate NPC',
            onPressed: _isGenerating
                ? null
                : () => _generateNpc(geminiProvider),
          ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      icon: _isGenerating
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }

  Future<void> _continueWriting(GeminiProvider provider) async {
    if (widget.currentContent == null || widget.currentContent!.isEmpty) {
      _showError('No content to continue from');
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final request = CompletionRequest(
        context: widget.context,
        currentContent: widget.currentContent!,
      );

      final response = await provider.service.continueStory(request);

      if (response.success && response.content != null) {
        widget.onContentGenerated(response.content!);
        _showSuccess('Content generated successfully');
      } else {
        _showError(response.error ?? 'Failed to generate content');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateContent(GeminiProvider provider) async {
    // Show dialog to get section details
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) =>
          _GenerateContentDialog(sectionType: _getSectionType()),
    );

    if (result == null || !mounted) return;

    setState(() => _isGenerating = true);

    try {
      final request = SectionGenerationRequest(
        context: widget.context,
        sectionType: _getSectionType(),
        title: result['title'] ?? 'Untitled',
        outline: result['outline'],
        keyElements:
            result['elements']?.split(',').map((e) => e.trim()).toList() ?? [],
      );

      final response = await provider.service.generateSection(request);

      if (response.success && response.content != null) {
        widget.onContentGenerated(response.content!);
        _showSuccess('Content generated successfully');
      } else {
        _showError(response.error ?? 'Failed to generate content');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateNpc(GeminiProvider provider) async {
    // Show dialog to get NPC details
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const _GenerateNpcDialog(),
    );

    if (result == null || !mounted) return;

    setState(() => _isGenerating = true);

    try {
      final request = NpcGenerationRequest(
        context: widget.context,
        role: result['role'],
        species: result['species'],
        alignment: result['alignment'],
        relationshipToParty: result['relationship'],
        traits:
            result['traits']?.split(',').map((e) => e.trim()).toList() ?? [],
      );

      final response = await provider.service.generateNpc(request);

      if (response.success) {
        // Format NPC data as text
        final npcText = _formatNpcResponse(response);
        widget.onContentGenerated(npcText);
        _showSuccess('NPC generated successfully');
      } else {
        _showError(response.error ?? 'Failed to generate NPC');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  String _getSectionType() {
    switch (widget.type) {
      case AiAssistanceType.chapter:
        return 'chapter';
      case AiAssistanceType.adventure:
        return 'adventure';
      case AiAssistanceType.scene:
      case AiAssistanceType.content:
        return 'scene';
      case AiAssistanceType.npc:
        return 'npc';
    }
  }

  String _formatNpcResponse(NpcGenerationResponse response) {
    final buffer = StringBuffer();

    if (response.name != null) {
      buffer.writeln('# ${response.name}\n');
    }

    if (response.appearance != null) {
      buffer.writeln('**Appearance:** ${response.appearance}\n');
    }

    if (response.personality != null) {
      buffer.writeln('**Personality:** ${response.personality}\n');
    }

    if (response.role != null) {
      buffer.writeln('**Role:** ${response.role}\n');
    }

    if (response.backstory != null) {
      buffer.writeln('**Backstory:** ${response.backstory}\n');
    }

    if (response.motivations != null) {
      buffer.writeln('**Motivations:** ${response.motivations}\n');
    }

    if (response.secrets != null) {
      buffer.writeln('**Secrets:** ${response.secrets}\n');
    }

    return buffer.toString();
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    toastification.show(
      context: context,
      type: ToastificationType.success,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    toastification.show(
      context: context,
      type: ToastificationType.error,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}

enum AiAssistanceType { content, chapter, adventure, scene, npc }

class _GenerateContentDialog extends StatefulWidget {
  final String sectionType;

  const _GenerateContentDialog({required this.sectionType});

  @override
  State<_GenerateContentDialog> createState() => _GenerateContentDialogState();
}

class _GenerateContentDialogState extends State<_GenerateContentDialog> {
  final _titleController = TextEditingController();
  final _outlineController = TextEditingController();
  final _elementsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _outlineController.dispose();
    _elementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text('Generate ${widget.sectionType}'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter the title for this section',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _outlineController,
              decoration: const InputDecoration(
                labelText: 'Outline (optional)',
                hintText: 'Brief outline of what should happen',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _elementsController,
              decoration: const InputDecoration(
                labelText: 'Key Elements (optional)',
                hintText: 'Comma-separated list: combat, mystery, NPC name',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              'title': _titleController.text,
              'outline': _outlineController.text,
              'elements': _elementsController.text,
            });
          },
          child: const Text('Generate'),
        ),
      ],
    );
  }
}

class _GenerateNpcDialog extends StatefulWidget {
  const _GenerateNpcDialog();

  @override
  State<_GenerateNpcDialog> createState() => _GenerateNpcDialogState();
}

class _GenerateNpcDialogState extends State<_GenerateNpcDialog> {
  final _roleController = TextEditingController();
  final _speciesController = TextEditingController();
  final _alignmentController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _traitsController = TextEditingController();

  @override
  void dispose() {
    _roleController.dispose();
    _speciesController.dispose();
    _alignmentController.dispose();
    _relationshipController.dispose();
    _traitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: const Text('Generate NPC'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Role (optional)',
                  hintText: 'e.g., Tavern keeper, City guard, Merchant',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _speciesController,
                decoration: const InputDecoration(
                  labelText: 'Species/Race (optional)',
                  hintText: 'e.g., Human, Elf, Dwarf, Dragonborn',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _alignmentController,
                decoration: const InputDecoration(
                  labelText: 'Alignment (optional)',
                  hintText: 'e.g., Lawful Good, Chaotic Neutral',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Relationship to Party (optional)',
                  hintText: 'e.g., Friendly, Hostile, Neutral',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _traitsController,
                decoration: const InputDecoration(
                  labelText: 'Traits (optional)',
                  hintText: 'Comma-separated: gruff, loyal, mysterious',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              'role': _roleController.text,
              'species': _speciesController.text,
              'alignment': _alignmentController.text,
              'relationship': _relationshipController.text,
              'traits': _traitsController.text,
            });
          },
          child: const Text('Generate'),
        ),
      ],
    );
  }
}
