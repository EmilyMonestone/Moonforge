import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/share_token_utils.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';

/// Public read-only view of a session log via share token.
/// This screen is accessible without authentication.
class SessionPublicShareScreen extends StatefulWidget {
  const SessionPublicShareScreen({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<SessionPublicShareScreen> createState() =>
      _SessionPublicShareScreenState();
}

class _SessionPublicShareScreenState extends State<SessionPublicShareScreen> {
  final QuillController _logController = QuillController.basic();

  @override
  void dispose() {
    _logController.dispose();
    super.dispose();
  }

  Future<Session?> _findSessionByToken() async {
    try {
      final odm = Odm.instance;
      
      // Search all campaigns for a session with this token
      // Note: This is a simplified implementation. In a production app,
      // you might want to index share tokens in a separate collection
      // or use Firestore queries more efficiently.
      
      final campaigns = await odm.campaigns.get();
      
      for (final campaign in campaigns) {
        final parties = await odm.campaigns.doc(campaign.id).parties.get();
        
        for (final party in parties) {
          final sessions = await odm.campaigns
              .doc(campaign.id)
              .parties
              .doc(party.id)
              .sessions
              .get();
          
          for (final session in sessions) {
            if (session.shareToken == widget.token &&
                ShareTokenUtils.isTokenValid(
                    session.shareEnabled, session.shareExpiresAt)) {
              return session;
            }
          }
        }
      }
      
      return null;
    } catch (e) {
      logger.e('Error finding session by token: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Session Log'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          tooltip: 'Home',
        ),
      ),
      body: FutureBuilder<Session?>(
        future: _findSessionByToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            logger.e('Error loading shared session: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading session',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          final session = snapshot.data;
          if (session == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.link_off, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Session not found',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This link may have expired or been revoked',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Set up log controller
          if (session.log != null && session.log!.isNotEmpty) {
            try {
              _logController.document =
                  Document.fromJson(jsonDecode(session.log!));
            } catch (e) {
              logger.e('Error parsing log delta: $e');
            }
          }
          _logController.readOnly = true;

          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 32,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Session Log',
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                  if (session.datetime != null)
                                    Text(
                                      formatDateTime(session.datetime!),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Chip(
                              avatar: const Icon(Icons.visibility, size: 16),
                              label: const Text('Read-only'),
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        if (session.log == null || session.log!.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(48),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    size: 48,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No session log yet',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          CustomQuillViewer(
                            controller: _logController,
                            // No mention tap handler for public view
                            onMentionTap: null,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
