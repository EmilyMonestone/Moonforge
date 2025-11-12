import 'package:chips_input_autocomplete/chips_input_autocomplete.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/quill_autosave.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/quill_toolbar.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class EntityEditScreen extends StatefulWidget {
  const EntityEditScreen({super.key, required this.entityId});

  final String entityId;

  @override
  State<EntityEditScreen> createState() => _EntityEditScreenState();
}

class _EntityEditScreenState extends State<EntityEditScreen> {
  final _nameController = TextEditingController();
  final _summaryController = TextEditingController();
  final ChipsAutocompleteController _tagsChipsController =
      ChipsAutocompleteController();
  final _originController =
      TextEditingController(); // will be removed from UI but kept for compatibility
  late QuillController _contentController;
  QuillAutosave? _autosave;
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  db.Entity? _entity;
  String? _campaignId;

  // Kind-specific controllers
  final _placeTypeController = TextEditingController();
  final _parentPlaceIdController = TextEditingController();
  final _coordsLatController = TextEditingController();
  final _coordsLngController = TextEditingController();
  final _membersController = TextEditingController();
  final Map<String, TextEditingController> _statblockControllers = {};
  List<Map<String, dynamic>> _images = [];

  // Dropdown selections
  String? _selectedChapterId;
  String? _selectedAdventureId;
  String? _selectedSceneId;
  List<db.Chapter> _chapters = [];
  List<db.Adventure> _adventures = [];
  List<db.Scene> _scenes = [];
  bool _loadingOriginLists = false;

  // Tag options for autocomplete
  List<String> _tagOptions = [];

  @override
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoading && _entity == null) {
      _loadEntity();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    _originController.dispose();
    _contentController.dispose();
    _autosave?.dispose();
    _placeTypeController.dispose();
    _parentPlaceIdController.dispose();
    _coordsLatController.dispose();
    _coordsLngController.dispose();
    _membersController.dispose();
    for (var controller in _statblockControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadEntity() async {
    setState(() => _isLoading = true);
    try {
      final campaign = context.read<CampaignProvider>().currentCampaign;
      if (campaign == null) {
        if (mounted) {
          toastification.show(
            type: ToastificationType.error,
            title: const Text('No campaign selected'),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      _campaignId = campaign.id;

      final repo = context.read<EntityRepository>();
      final entity = await repo.getById(widget.entityId);

      if (entity != null) {
        Document document;
        if (entity.content != null && entity.content!.isNotEmpty) {
          try {
            final ops = entity.content!['ops'];
            document = ops is List
                ? Document.fromJson(List<Map<String, dynamic>>.from(ops))
                : Document();
          } catch (e) {
            document = Document();
          }
        } else {
          document = Document();
        }

        setState(() {
          _entity = entity;
          _nameController.text = entity.name;
          _summaryController.text = entity.summary ?? '';
          _originController.text = entity.originId; // retain raw origin
          // Reinitialize quill controller with loaded document to avoid direct mutation issues.
          _autosave?.dispose();
          _autosave = null;
          _contentController.dispose();
          _contentController = QuillController(
            document: document,
            selection: const TextSelection.collapsed(offset: 0),
          );

          // Load kind-specific fields
          if (entity.kind == 'place') {
            _placeTypeController.text = entity.placeType ?? '';
            _parentPlaceIdController.text = entity.parentPlaceId ?? '';
            _coordsLatController.text = entity.coords['lat']?.toString() ?? '';
            _coordsLngController.text = entity.coords['lng']?.toString() ?? '';
          } else if (entity.kind == 'group') {
            _membersController.text = (entity.members ?? const <String>[]).join(
              ', ',
            );
          } else if (entity.kind == 'npc' || entity.kind == 'monster') {
            // Initialize statblock controllers
            for (var entry in entity.statblock.entries) {
              final controller = TextEditingController(
                text: entry.value.toString(),
              );
              _statblockControllers[entry.key] = controller;
            }
          }

          // Load images
          _images = entity.images ?? const <Map<String, dynamic>>[];
        });

        _autosave = QuillAutosave(
          controller: _contentController,
          storageKey: 'entity_${entity.id}_content_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            logger.d('Content autosaved locally for entity ${entity.id}');
          },
        );
        _autosave?.start();

        // After entity loaded, fetch chapters/adventures/scenes and preselect
        await _initializeOriginSelections(entity.originId);

        // Load tag options for autocomplete
        await _loadTagOptions();
      }
    } catch (e) {
      logger.e('Error loading entity: $e');
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load entity'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTagOptions() async {
    try {
      final repo = context.read<EntityRepository>();
      final all = await repo.getAll();
      final set = <String>{};
      for (final e in all) {
        final list = e.tags ?? const <String>[];
        set.addAll(list);
      }
      final options = set.toList()..sort();
      if (mounted) {
        setState(() {
          _tagOptions = options;
          // Optionally also update controller options for live filtering
          _tagsChipsController.options = options;
        });
      }
    } catch (e) {
      logger.w('Failed to load tag options: $e');
    }
  }

  Future<void> _initializeOriginSelections(String originId) async {
    if (_campaignId == null) return;
    setState(() => _loadingOriginLists = true);
    try {
      final chapterRepo = context.read<ChapterRepository>();
      _chapters = await chapterRepo.getByCampaign(_campaignId!);

      // Determine if originId matches a scene, adventure, or chapter
      db.Scene? matchedScene;
      db.Adventure? matchedAdventure;
      db.Chapter? matchedChapter;

      // Check chapters first
      matchedChapter = _chapters.firstWhere(
        (c) => c.id == originId,
        orElse: () => db.Chapter(
          id: '',
          campaignId: _campaignId!,
          name: '',
          order: 0,
          summary: '',
          content: const {},
          entityIds: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          rev: 0,
        ),
      );
      if (matchedChapter.id.isEmpty) matchedChapter = null;

      // If not a chapter, need to search adventures in chapters
      if (matchedChapter == null) {
        final adventureRepo = context.read<AdventureRepository>();
        for (final ch in _chapters) {
          final advs = await adventureRepo.getByChapter(ch.id);
          for (final adv in advs) {
            if (adv.id == originId) {
              matchedAdventure = adv;
              matchedChapter = ch;
              _adventures = advs; // seed adventures list with this chapter
              break;
            }
          }
          if (matchedAdventure != null) break;
        }
      }

      // If still not found, search scenes
      if (matchedAdventure == null) {
        final sceneRepo = context.read<SceneRepository>();
        final adventureRepo = context.read<AdventureRepository>();
        for (final ch in _chapters) {
          final advs = await adventureRepo.getByChapter(ch.id);
          for (final adv in advs) {
            final scs = await sceneRepo.getByAdventure(adv.id);
            for (final sc in scs) {
              if (sc.id == originId) {
                matchedScene = sc;
                matchedAdventure = adv;
                matchedChapter = ch;
                _adventures = advs;
                _scenes = scs;
                break;
              }
            }
            if (matchedScene != null) break;
          }
          if (matchedScene != null) break;
        }
      }

      setState(() {
        _selectedChapterId = matchedChapter?.id;
        _selectedAdventureId = matchedAdventure?.id;
        _selectedSceneId = matchedScene?.id;
      });

      // If we have a chapter but no adventures loaded yet (chapter-level origin)
      if (_selectedChapterId != null && _selectedAdventureId == null) {
        final adventureRepo = context.read<AdventureRepository>();
        _adventures = await adventureRepo.getByChapter(_selectedChapterId!);
      }

      // If we have adventure but no scenes loaded yet
      if (_selectedAdventureId != null && _selectedSceneId == null) {
        final sceneRepo = context.read<SceneRepository>();
        _scenes = await sceneRepo.getByAdventure(_selectedAdventureId!);
      }
    } catch (e) {
      logger.w('Failed to init origin selections: $e');
    } finally {
      if (mounted) setState(() => _loadingOriginLists = false);
    }
  }

  Future<void> _onSelectChapter(String? chapterId) async {
    setState(() {
      _selectedChapterId = chapterId;
      _selectedAdventureId = null;
      _selectedSceneId = null;
      _adventures = [];
      _scenes = [];
    });
    if (chapterId == null) return;
    final adventureRepo = context.read<AdventureRepository>();
    _adventures = await adventureRepo.getByChapter(chapterId);
    setState(() {});
  }

  Future<void> _onSelectAdventure(String? adventureId) async {
    setState(() {
      _selectedAdventureId = adventureId;
      _selectedSceneId = null;
      _scenes = [];
    });
    if (adventureId == null) return;
    final sceneRepo = context.read<SceneRepository>();
    _scenes = await sceneRepo.getByAdventure(adventureId);
    setState(() {});
  }

  void _onSelectScene(String? sceneId) {
    setState(() => _selectedSceneId = sceneId);
  }

  void _clearAdventure() {
    setState(() {
      _selectedAdventureId = null;
      _selectedSceneId = null;
      _scenes = [];
    });
  }

  void _clearScene() {
    setState(() {
      _selectedSceneId = null;
    });
  }

  String _computeOriginId() {
    // Priority: scene -> adventure -> chapter -> campaign
    if (_selectedSceneId != null) return _selectedSceneId!;
    if (_selectedAdventureId != null) return _selectedAdventureId!;
    if (_selectedChapterId != null) return _selectedChapterId!;
    return _campaignId ?? _originController.text.trim();
  }

  Future<void> _saveEntity() async {
    if (!_formKey.currentState!.validate()) return;
    if (_entity == null || _campaignId == null) return;

    setState(() => _isSaving = true);
    try {
      final delta = _contentController.document.toDelta();
      final contentMap = {'ops': delta.toJson()};

      final repo = context.read<EntityRepository>();
      // Get tags from chips controller instead of parsing text
      final tags = List<String>.from(_tagsChipsController.chips);

      // Build kind-specific data
      Map<String, dynamic> statblock = {};
      String? placeType;
      String? parentPlaceId;
      Map<String, dynamic> coords = {};
      List<String>? members;

      if (_entity!.kind == 'place') {
        placeType = _placeTypeController.text.trim().isEmpty
            ? null
            : _placeTypeController.text.trim();
        parentPlaceId = _parentPlaceIdController.text.trim().isEmpty
            ? null
            : _parentPlaceIdController.text.trim();

        final lat = double.tryParse(_coordsLatController.text.trim());
        final lng = double.tryParse(_coordsLngController.text.trim());
        if (lat != null && lng != null) {
          coords = {'lat': lat, 'lng': lng};
        }
      } else if (_entity!.kind == 'group') {
        final membersList = _membersController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        members = membersList.isEmpty ? null : membersList;
      } else if (_entity!.kind == 'npc' || _entity!.kind == 'monster') {
        for (var entry in _statblockControllers.entries) {
          statblock[entry.key] = entry.value.text;
        }
      }

      final updatedEntity = _entity!.copyWith(
        name: _nameController.text.trim(),
        originId: _computeOriginId(),
        // include origin change
        summary: Value(_summaryController.text.trim()),
        tags: Value(tags),
        content: Value(contentMap),
        statblock: statblock,
        placeType: Value(placeType),
        parentPlaceId: Value(parentPlaceId),
        coords: coords,
        members: Value(members),
        images: Value(_images),
        updatedAt: Value(DateTime.now()),
        rev: _entity!.rev + 1,
      );

      await repo.update(updatedEntity);

      await _autosave?.clear();

      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Entity saved successfully'),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      logger.e('Error saving entity: $e');
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to save entity'),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _addStatblockField() {
    showDialog(
      context: context,
      builder: (context) {
        final keyController = TextEditingController();
        final valueController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Stat Block Field'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: keyController,
                decoration: const InputDecoration(labelText: 'Field Name'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Value'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final key = keyController.text.trim();
                final value = valueController.text.trim();
                if (key.isNotEmpty) {
                  setState(() {
                    _statblockControllers[key] = TextEditingController(
                      text: value,
                    );
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addImage() {
    showDialog(
      context: context,
      builder: (context) {
        final assetIdController = TextEditingController();
        final kindController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: assetIdController,
                decoration: const InputDecoration(labelText: 'Asset ID'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kindController,
                decoration: const InputDecoration(
                  labelText: 'Kind (optional)',
                  hintText: 'e.g., avatar, banner',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final assetId = assetIdController.text.trim();
                final kind = kindController.text.trim();
                if (assetId.isNotEmpty) {
                  setState(() {
                    _images.add({
                      'assetId': assetId,
                      if (kind.isNotEmpty) 'kind': kind,
                    });
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Widget _buildKindSpecificFields(BuildContext context) {
    final theme = Theme.of(context);

    switch (_entity!.kind) {
      case 'place':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text('Place Details', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _placeTypeController.text.isEmpty
                  ? null
                  : _placeTypeController.text,
              decoration: const InputDecoration(
                labelText: 'Place Type',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'world', child: Text('World')),
                DropdownMenuItem(value: 'continent', child: Text('Continent')),
                DropdownMenuItem(value: 'region', child: Text('Region')),
                DropdownMenuItem(value: 'city', child: Text('City')),
                DropdownMenuItem(value: 'village', child: Text('Village')),
                DropdownMenuItem(value: 'place', child: Text('Place')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  _placeTypeController.text = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _parentPlaceIdController,
              decoration: InputDecoration(
                labelText: 'Parent Place ID',
                prefixIcon: Icon(DomainType.entityPlace.icon),
                hintText: 'Optional',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _coordsLatController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _coordsLngController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      prefixIcon: Icon(Icons.map_outlined),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case 'group':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text('Group Details', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _membersController,
              decoration: InputDecoration(
                labelText: 'Members',
                prefixIcon: Icon(DomainType.entityGroup.icon),
                hintText: 'Comma-separated member IDs or names',
              ),
              maxLines: 3,
            ),
          ],
        );
      case 'npc':
      case 'monster':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Stat Block', style: theme.textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _addStatblockField,
                  tooltip: 'Add field',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_statblockControllers.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No stat block fields. Click + to add fields.',
                ),
              )
            else
              ..._statblockControllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: entry.key,
                            isDense: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() {
                            entry.value.dispose();
                            _statblockControllers.remove(entry.key);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
          ],
        );
      case 'item':
      case 'handout':
      case 'journal':
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_entity == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('No entity found', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
            ),
          ],
        ),
      );
    }

    return SurfaceContainer(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_entity!.kind.toUpperCase()} ${l10n.edit}',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Spacer(),
          ButtonM3E(
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
            label: Text(l10n.cancel),
            icon: const Icon(Icons.cancel_outlined),
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          ),
          ButtonM3E(
            style: ButtonM3EStyle.filled,
            shape: ButtonM3EShape.square,
            label: Text(l10n.save),
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveEntity,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                prefixIcon: const Icon(Icons.label_outlined),
                helperText: 'Give your entity a descriptive name',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Name is required';
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Origin selection section
            Text(l10n.origin, style: theme.textTheme.titleMedium),

            if (_loadingOriginLists)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              )
            else
              WrapLayout(
                spacing: 12,
                runSpacing: 12,
                minWidth: 150,
                maxWidth: 300,
                children: [
                  DropdownButtonFormField<String>(
                    key: ValueKey('chapter_${_selectedChapterId ?? 'none'}'),
                    initialValue: _selectedChapterId,
                    decoration: InputDecoration(
                      labelText: l10n.selectChapter,
                      prefixIcon: const Icon(Icons.book_outlined),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    items: _chapters
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => _onSelectChapter(v),
                  ),
                  // Adventure dropdown with clear suffix icon
                  DropdownButtonFormField<String>(
                    key: ValueKey(
                      'adventure_${_selectedAdventureId ?? 'none'}',
                    ),
                    initialValue: _selectedAdventureId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.selectAdventure,
                      prefixIcon: const Icon(Icons.explore_outlined),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      suffixIconConstraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      suffixIcon: _selectedAdventureId != null
                          ? IconButton(
                              tooltip: 'Clear',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: _clearAdventure,
                            )
                          : null,
                    ),
                    items: _adventures
                        .map(
                          (a) => DropdownMenuItem(
                            value: a.id,
                            child: Text(
                              a.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _adventures.isEmpty
                        ? null
                        : (v) => _onSelectAdventure(v),
                  ),
                  // Scene dropdown with clear suffix icon
                  DropdownButtonFormField<String>(
                    key: ValueKey('scene_${_selectedSceneId ?? 'none'}'),
                    initialValue: _selectedSceneId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.selectScene,
                      prefixIcon: const Icon(Icons.theaters_outlined),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      suffixIconConstraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      suffixIcon: _selectedSceneId != null
                          ? IconButton(
                              tooltip: 'Clear',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: _clearScene,
                            )
                          : null,
                    ),
                    items: _scenes
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(
                              s.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: _scenes.isEmpty
                        ? null
                        : (v) => _onSelectScene(v),
                  ),
                ],
              ),

            const SizedBox(height: 16),
            Text(l10n.description, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Short summary',
                hintText: 'Enter a brief summary',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Text(l10n.tags, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ChipsInputAutocomplete(
              controller: _tagsChipsController,
              options: _tagOptions,
              initialChips: _entity?.tags ?? const <String>[],
              decorationTextField: InputDecoration(
                labelText: l10n.tags,
                prefixIcon: const Icon(Icons.tag),
                hintText: l10n.search,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              addChipOnSelection: true,
              showOnlyUnselectedOptions: true,
              showClearButton: true,
              onChanged: (chips) {
                // keep state reactive if needed
                // setState(() {});
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text('Images', style: theme.textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  onPressed: _addImage,
                  tooltip: 'Add image',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_images.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      DomainType.mediaAsset.icon,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'No images. Click + to add images.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images.asMap().entries.map((entry) {
                  final index = entry.key;
                  final imageMap = entry.value;
                  final assetId = imageMap['assetId'] as String?;
                  final kind = imageMap['kind'] as String?;
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 32),
                              const SizedBox(height: 4),
                              if (kind != null)
                                Text(
                                  kind,
                                  style: theme.textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (assetId != null)
                                Text(
                                  assetId.length > 10
                                      ? '${assetId.substring(0, 10)}...'
                                      : assetId,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => _removeImage(index),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            _buildKindSpecificFields(context),
            const SizedBox(height: 24),
            Text(l10n.content, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              key: _editorKey,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  QuillCustomToolbar(controller: _contentController),
                  const Divider(height: 1),
                  Expanded(
                    child: CustomQuillEditor(controller: _contentController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
