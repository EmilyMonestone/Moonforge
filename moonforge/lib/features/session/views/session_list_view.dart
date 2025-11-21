import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/session/controllers/session_list_controller.dart';
import 'package:moonforge/features/session/widgets/session_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for browsing and managing sessions
class SessionListView extends StatefulWidget {
  const SessionListView({super.key, required this.partyId});

  final String partyId;

  @override
  State<SessionListView> createState() => _SessionListViewState();
}

class _SessionListViewState extends State<SessionListView> {
  final _controller = SessionListController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _controller.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sessions')),
        body: Center(child: Text(l10n.noCampaignSelected)),
      );
    }

    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sessions'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterMenu(context),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  return TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search sessions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Session>>(
                stream: context.read<SessionRepository>().watchAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final sessions = snapshot.data ?? [];
                  _controller.setSessions(sessions);

                  return Consumer<SessionListController>(
                    builder: (context, controller, _) {
                      final filteredSessions = controller.filteredSessions;
                      return SessionList(
                        sessions: filteredSessions,
                        partyId: widget.partyId,
                        emptyMessage: _searchController.text.isNotEmpty
                            ? 'No sessions match your search'
                            : 'No sessions yet',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            SessionEditRouteData(
              partyId: widget.partyId,
              sessionId: 'new',
            ).push(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('New Session'),
        ),
      ),
    );
  }

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sort by'),
              trailing: const Icon(Icons.sort),
            ),
            const Divider(),
            Consumer<SessionListController>(
              builder: (context, controller, _) {
                return Column(
                  children: [
                    RadioListTile<SessionListSort>(
                      title: const Text('Date (Newest first)'),
                      value: SessionListSort.dateDescending,
                      groupValue: controller.sortBy,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSortBy(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    RadioListTile<SessionListSort>(
                      title: const Text('Date (Oldest first)'),
                      value: SessionListSort.dateAscending,
                      groupValue: controller.sortBy,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSortBy(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    RadioListTile<SessionListSort>(
                      title: const Text('Created (Newest first)'),
                      value: SessionListSort.createdDescending,
                      groupValue: controller.sortBy,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSortBy(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    RadioListTile<SessionListSort>(
                      title: const Text('Created (Oldest first)'),
                      value: SessionListSort.createdAscending,
                      groupValue: controller.sortBy,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSortBy(value);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
