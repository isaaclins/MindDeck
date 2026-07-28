import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/models.dart';
import '../design/minddeck_theme.dart';
import '../features/decks/decks.dart';
import '../features/sharing/sharing.dart';
import '../features/study/study_engine.dart';
import '../features/study/study_screen.dart';
import 'persistent_decks_store.dart';

class MindDeckApp extends StatefulWidget {
  const MindDeckApp({super.key});

  @override
  State<MindDeckApp> createState() => _MindDeckAppState();
}

class _MindDeckAppState extends State<MindDeckApp> {
  late final Future<PersistentDecksStore> _storeFuture;
  PersistentDecksStore? _store;

  @override
  void initState() {
    super.initState();
    _storeFuture = PersistentDecksStore.open().then((store) {
      _store = store;
      return store;
    });
  }

  @override
  void dispose() {
    _store?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PersistentDecksStore>(
      future: _storeFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MindDeckTheme.light(),
            home: _StartupError(error: snapshot.error),
          );
        }
        final store = snapshot.data;
        if (store == null) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: MindDeckTheme.light(),
            home: const _MindDeckLoadingScreen(),
          );
        }
        return _MindDeckRouter(store: store);
      },
    );
  }
}

class _MindDeckRouter extends StatefulWidget {
  const _MindDeckRouter({required this.store});

  final PersistentDecksStore store;

  @override
  State<_MindDeckRouter> createState() => _MindDeckRouterState();
}

class _MindDeckRouterState extends State<_MindDeckRouter> {
  static final _linkBaseUri = Uri.parse('https://isaaclins.com/MindDeck/open');

  late final MindDeckSharingService _sharingService;
  late final AppLinks _appLinks;
  late final GoRouter _router;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _sharingService = MindDeckSharingService();
    _router = GoRouter(
      refreshListenable: widget.store,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => DeckLibraryScreen(
            controller: widget.store.controller,
            statsForDeck: widget.store.statsForDeck,
            onOpenDeck: (deckId) => context.go('/decks/$deckId'),
            onSettings: () => _showLibraryMenu(context),
          ),
        ),
        GoRoute(
          path: '/decks/:deckId',
          builder: (context, state) {
            final deckId = state.pathParameters['deckId']!;
            final deck = widget.store.controller.deckById(deckId);
            if (deck == null) {
              return _MissingDeckScreen(onBack: () => context.go('/'));
            }
            return DeckDetailScreen(
              controller: widget.store.controller,
              deckId: deckId,
              stats: widget.store.statsForDeck(deck),
              onBack: () => context.go('/'),
              onStudy: (selectedDeck) =>
                  context.push('/decks/${selectedDeck.id}/study'),
              onShare: (selectedDeck) =>
                  context.push('/decks/${selectedDeck.id}/share'),
              onDeckDeleted: () => context.go('/'),
              openCardEditor: (selectedDeckId, cardId) {
                final suffix = cardId ?? 'new';
                context.push('/decks/$selectedDeckId/cards/$suffix');
              },
            );
          },
        ),
        GoRoute(
          path: '/decks/:deckId/cards/:cardId',
          builder: (context, state) {
            final deckId = state.pathParameters['deckId']!;
            final rawCardId = state.pathParameters['cardId']!;
            if (widget.store.controller.deckById(deckId) == null) {
              return _MissingDeckScreen(onBack: () => context.go('/'));
            }
            return CardEditorScreen(
              controller: widget.store.controller,
              deckId: deckId,
              cardId: rawCardId == 'new' ? null : rawCardId,
              onClose: () => context.pop(),
              onSaved: (_) => context.pop(),
              onDeleted: () => context.pop(),
            );
          },
        ),
        GoRoute(
          path: '/decks/:deckId/study',
          builder: (context, state) {
            final deckId = state.pathParameters['deckId']!;
            final deck = widget.store.controller.deckById(deckId);
            if (deck == null) {
              return _MissingDeckScreen(onBack: () => context.go('/'));
            }
            return _StudyRoute(
              deck: deck,
              store: widget.store,
              onExit: () => context.pop(),
              onDone: () => context.go('/decks/$deckId'),
              onStudyAgain: () =>
                  context.pushReplacement('/decks/$deckId/study'),
            );
          },
        ),
        GoRoute(
          path: '/decks/:deckId/share',
          builder: (context, state) {
            final deckId = state.pathParameters['deckId']!;
            final deck = widget.store.controller.deckById(deckId);
            if (deck == null) {
              return _MissingDeckScreen(onBack: () => context.go('/'));
            }
            return ShareDeckScreen(
              deck: deck,
              linkBaseUri: _linkBaseUri,
              service: _sharingService,
              onBack: () => context.pop(),
            );
          },
        ),
        GoRoute(
          path: '/import',
          builder: (context, state) {
            final snapshot = state.extra;
            if (snapshot is! DecodedMindDeckSnapshot) {
              return _InvalidImportScreen(onBack: () => context.go('/'));
            }
            return ImportPreviewScreen(
              snapshot: snapshot,
              onCancel: () => context.pop(),
              onImport: (confirmedSnapshot) async {
                final candidate = _sharingService.createImportCandidate(
                  confirmedSnapshot,
                );
                final imported = await widget.store.importDeck(candidate.deck);
                if (context.mounted) {
                  context.go('/decks/${imported.id}');
                }
              },
            );
          },
        ),
      ],
    );
    _startLinkListener();
  }

  @override
  void dispose() {
    unawaited(_linkSubscription?.cancel());
    _router.dispose();
    super.dispose();
  }

  void _startLinkListener() {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleIncomingLink);
    unawaited(
      _appLinks.getInitialLink().then((uri) {
        if (uri != null) _handleIncomingLink(uri);
      }),
    );
  }

  void _handleIncomingLink(Uri uri) {
    if (uri.scheme == 'minddeck' && uri.host == 'study') {
      final deckId = uri.pathSegments.firstOrNull;
      if (deckId != null && widget.store.controller.deckById(deckId) != null) {
        _router.go('/decks/$deckId/study');
      }
      return;
    }

    if (uri.scheme == 'minddeck' &&
        uri.host == 'import' &&
        uri.fragment.startsWith('md1.')) {
      try {
        final snapshot = _sharingService.previewLink(uri.fragment);
        _router.go('/import', extra: snapshot);
      } on MindDeckSnapshotException {
        _router.go('/import');
      }
      return;
    }

    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.fragment.startsWith('md1.')) {
      try {
        final snapshot = _sharingService.previewLink(uri.toString());
        _router.go('/import', extra: snapshot);
      } on MindDeckSnapshotException {
        _router.go('/import');
      }
    }
  }

  Future<void> _showLibraryMenu(BuildContext context) async {
    final action = await showModalBottomSheet<_LibraryAction>(
      context: context,
      showDragHandle: true,
      backgroundColor: MindDeckColors.paper,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your MindDeck',
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Everything stays on this device.',
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              StickerButton(
                label: 'Import a .minddeck file',
                icon: Icons.file_open_outlined,
                expanded: true,
                onPressed: () =>
                    Navigator.of(sheetContext).pop(_LibraryAction.importFile),
              ),
            ],
          ),
        ),
      ),
    );
    if (action != _LibraryAction.importFile || !context.mounted) return;

    try {
      final snapshot = await _sharingService.pickFileForPreview();
      if (snapshot != null && context.mounted) {
        context.push('/import', extra: snapshot);
      }
    } on MindDeckSnapshotException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MindDeck',
      debugShowCheckedModeBanner: false,
      theme: MindDeckTheme.light(),
      routerConfig: _router,
    );
  }
}

enum _LibraryAction { importFile }

class _StudyRoute extends StatefulWidget {
  const _StudyRoute({
    required this.deck,
    required this.store,
    required this.onExit,
    required this.onDone,
    required this.onStudyAgain,
  });

  final Deck deck;
  final PersistentDecksStore store;
  final VoidCallback onExit;
  final VoidCallback onDone;
  final VoidCallback onStudyAgain;

  @override
  State<_StudyRoute> createState() => _StudyRouteState();
}

class _StudyRouteState extends State<_StudyRoute> {
  late final Future<List<StudyCardProgress>> _progressFuture;

  @override
  void initState() {
    super.initState();
    _progressFuture = widget.store.loadStudyProgress(widget.deck.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudyCardProgress>>(
      future: _progressFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _StartupError(error: snapshot.error);
        }
        final progress = snapshot.data;
        if (progress == null) {
          return const _MindDeckLoadingScreen();
        }
        return StudyScreen(
          deck: widget.deck,
          initialProgress: progress,
          randomSeed: DateTime.now().millisecondsSinceEpoch,
          onExit: widget.onExit,
          onSnapshotChanged: (studySnapshot) {
            unawaited(widget.store.saveStudySnapshot(studySnapshot));
          },
          onDone: widget.onDone,
          onStudyAgain: widget.onStudyAgain,
        );
      },
    );
  }
}

class _MindDeckLoadingScreen extends StatelessWidget {
  const _MindDeckLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PaperPanel(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DoodleSparkle(color: MindDeckColors.sunshine, size: 34),
              const SizedBox(height: 12),
              Text(
                'Opening your decks…',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const SizedBox(width: 120, child: LinearProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: PaperPanel(
            borderColor: MindDeckColors.raspberry,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sentiment_dissatisfied_rounded,
                  color: MindDeckColors.raspberry,
                  size: 42,
                ),
                const SizedBox(height: 14),
                Text(
                  'MindDeck could not open',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MissingDeckScreen extends StatelessWidget {
  const _MissingDeckScreen({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _MessageScreen(
      title: 'Deck not found',
      message: 'It may have been removed from this device.',
      buttonLabel: 'Back to my decks',
      onPressed: onBack,
    );
  }
}

class _InvalidImportScreen extends StatelessWidget {
  const _InvalidImportScreen({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return _MessageScreen(
      title: 'Nothing to preview',
      message: 'Open a MindDeck link or choose a .minddeck file.',
      buttonLabel: 'Back to my decks',
      onPressed: onBack,
    );
  }
}

class _MessageScreen extends StatelessWidget {
  const _MessageScreen({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: PaperPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DoodleSparkle(color: MindDeckColors.violet, size: 38),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                StickerButton(label: buttonLabel, onPressed: onPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
