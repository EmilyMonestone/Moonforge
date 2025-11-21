import 'package:flutter/material.dart';
import 'package:moonforge/core/models/ai/generation_request.dart';
import 'package:moonforge/core/models/ai/story_context.dart';
import 'package:moonforge/core/providers/gemini_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

/// Result from AI creation dialog
class AiCreationResult {
  final String? title;
  final String? content;
  final Map<String, dynamic>? structuredData;

  AiCreationResult({this.title, this.content, this.structuredData});
}

/// Shows a dialog for AI-assisted creation with appropriate inputs based on type
Future<AiCreationResult?> showAiCreationDialog(
  BuildContext context, {
  required StoryContext storyContext,
  required String creationType, // 'scene', 'chapter', 'adventure', 'npc', etc.
}) async {
  final geminiProvider = context.read<GeminiProvider?>();

  if (geminiProvider == null) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      title: const Text('AI not available'),
      description: const Text('Gemini API key not configured'),
      autoCloseDuration: const Duration(seconds: 3),
    );
    return null;
  }

  return showDialog<AiCreationResult>(
    context: context,
    builder: (context) => _AiCreationDialog(
      storyContext: storyContext,
      creationType: creationType,
      geminiProvider: geminiProvider,
    ),
  );
}

class _AiCreationDialog extends StatefulWidget {
  final StoryContext storyContext;
  final String creationType;
  final GeminiProvider geminiProvider;

  const _AiCreationDialog({
    required this.storyContext,
    required this.creationType,
    required this.geminiProvider,
  });

  @override
  State<_AiCreationDialog> createState() => _AiCreationDialogState();
}

class _AiCreationDialogState extends State<_AiCreationDialog> {
  final _titleController = TextEditingController();
  final _outlineController = TextEditingController();
  final _elementsController = TextEditingController();

  // NPC-specific controllers
  final _roleController = TextEditingController();
  final _speciesController = TextEditingController();
  final _alignmentController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _traitsController = TextEditingController();

  bool _isGenerating = false;
  String? _error;

  @override
  void dispose() {
    _titleController.dispose();
    _outlineController.dispose();
    _elementsController.dispose();
    _roleController.dispose();
    _speciesController.dispose();
    _alignmentController.dispose();
    _relationshipController.dispose();
    _traitsController.dispose();
    super.dispose();
  }

  bool get _isNpcType =>
      widget.creationType.toLowerCase() == 'npc' ||
      widget.creationType.toLowerCase() == 'entity';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text('AI-Generate ${widget.creationType}'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (_isNpcType)
                ..._buildNpcInputs()
              else
                ..._buildSectionInputs(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isGenerating ? null : () => Navigator.of(context).pop(),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isGenerating ? null : _generateWithAi,
          icon: _isGenerating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_fix_high),
          label: Text(_isGenerating ? 'Generating...' : 'Generate'),
        ),
      ],
    );
  }

  List<Widget> _buildSectionInputs() {
    return [
      TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'Title',
          hintText: 'Enter the title',
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
          hintText: 'Comma-separated: combat, mystery, NPC name',
        ),
      ),
    ];
  }

  List<Widget> _buildNpcInputs() {
    return [
      TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          labelText: 'NPC Name (optional)',
          hintText: 'Leave blank to let AI decide',
        ),
      ),
      const SizedBox(height: 16),
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
    ];
  }

  Future<void> _generateWithAi() async {
    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      if (_isNpcType) {
        await _generateNpc();
      } else {
        await _generateSection();
      }
    } catch (e) {
      setState(() {
        _error = 'Generation failed: $e';
        _isGenerating = false;
      });
    }
  }

  Future<void> _generateSection() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _error = 'Please enter a title';
        _isGenerating = false;
      });
      return;
    }

    final request = SectionGenerationRequest(
      context: widget.storyContext,
      sectionType: widget.creationType.toLowerCase(),
      title: title,
      outline: _outlineController.text.trim().isEmpty
          ? null
          : _outlineController.text.trim(),
      keyElements: _elementsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );

    final response = await widget.geminiProvider.service.generateSection(
      request,
    );

    if (!mounted) return;

    if (response.success && response.content != null) {
      Navigator.of(
        context,
      ).pop(AiCreationResult(title: title, content: response.content));
    } else {
      setState(() {
        _error = response.error ?? 'Failed to generate content';
        _isGenerating = false;
      });
    }
  }

  Future<void> _generateNpc() async {
    final request = NpcGenerationRequest(
      context: widget.storyContext,
      role: _roleController.text.trim().isEmpty
          ? null
          : _roleController.text.trim(),
      species: _speciesController.text.trim().isEmpty
          ? null
          : _speciesController.text.trim(),
      alignment: _alignmentController.text.trim().isEmpty
          ? null
          : _alignmentController.text.trim(),
      relationshipToParty: _relationshipController.text.trim().isEmpty
          ? null
          : _relationshipController.text.trim(),
      traits: _traitsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
    );

    final response = await widget.geminiProvider.service.generateNpc(request);

    if (!mounted) return;

    if (response.success) {
      // Use provided name or generated name
      final name = _titleController.text.trim().isNotEmpty
          ? _titleController.text.trim()
          : response.name ?? 'Unnamed NPC';

      // Format NPC data as structured content
      final buffer = StringBuffer();
      if (response.appearance != null) {
        buffer.writeln(response.appearance);
        buffer.writeln();
      }
      if (response.personality != null) {
        buffer.writeln('**Personality:** ${response.personality}');
        buffer.writeln();
      }
      if (response.backstory != null) {
        buffer.writeln('**Backstory:** ${response.backstory}');
        buffer.writeln();
      }
      if (response.role != null) {
        buffer.writeln('**Role:** ${response.role}');
        buffer.writeln();
      }
      if (response.motivations != null) {
        buffer.writeln('**Motivations:** ${response.motivations}');
        buffer.writeln();
      }
      if (response.secrets != null) {
        buffer.writeln('**Secrets:** ${response.secrets}');
      }

      Navigator.of(context).pop(
        AiCreationResult(
          title: name,
          content: buffer.toString(),
          structuredData: {
            'name': name,
            'appearance': response.appearance,
            'personality': response.personality,
            'backstory': response.backstory,
            'role': response.role,
            'motivations': response.motivations,
            'secrets': response.secrets,
          },
        ),
      );
    } else {
      setState(() {
        _error = response.error ?? 'Failed to generate NPC';
        _isGenerating = false;
      });
    }
  }
}
