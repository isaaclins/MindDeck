import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../design/minddeck_theme.dart';
import 'snapshot_models.dart';

typedef ConfirmMindDeckImport =
    FutureOr<void> Function(DecodedMindDeckSnapshot snapshot);

class ImportPreviewScreen extends StatefulWidget {
  const ImportPreviewScreen({
    required this.snapshot,
    required this.onImport,
    super.key,
    this.duplicate,
    this.onCancel,
  });

  final DecodedMindDeckSnapshot snapshot;
  final ExactDuplicateMatch? duplicate;
  final ConfirmMindDeckImport onImport;
  final VoidCallback? onCancel;

  @override
  State<ImportPreviewScreen> createState() => _ImportPreviewScreenState();
}

class _ImportPreviewScreenState extends State<ImportPreviewScreen> {
  var _importing = false;

  Future<void> _confirmImport() async {
    if (_importing) return;
    setState(() => _importing = true);
    try {
      await widget.onImport(widget.snapshot);
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('MindDeck could not import this deck.'),
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deck = widget.snapshot.deck;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Cancel import',
          onPressed: widget.onCancel ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Deck preview'),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 760;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                desktop ? 40 : 20,
                12,
                desktop ? 40 : 20,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: desktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 6,
                              child: _ImportCardStack(deck: deck),
                            ),
                            const SizedBox(width: 60),
                            Expanded(
                              flex: 5,
                              child: _ImportDetails(
                                deck: deck,
                                duplicate: widget.duplicate,
                                importing: _importing,
                                onImport: _confirmImport,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 330,
                              child: _ImportCardStack(deck: deck),
                            ),
                            const SizedBox(height: 8),
                            _ImportDetails(
                              deck: deck,
                              duplicate: widget.duplicate,
                              importing: _importing,
                              onImport: _confirmImport,
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ImportDetails extends StatelessWidget {
  const _ImportDetails({
    required this.deck,
    required this.duplicate,
    required this.importing,
    required this.onImport,
  });

  final Deck deck;
  final ExactDuplicateMatch? duplicate;
  final bool importing;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final cardLabel = deck.cards.length == 1 ? 'card' : 'cards';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DoodleSparkle(size: 24, color: MindDeckColors.sunshine),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'A deck for you',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: MindDeckColors.violet,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const DoodleSparkle(
              size: 19,
              color: MindDeckColors.raspberry,
              rotation: .25,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          deck.title,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          '${deck.cards.length} $cardLabel'
          '${deck.studyBothDirections ? ' · both directions' : ''}',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: MindDeckColors.mutedInk),
        ),
        if (duplicate case final match?) ...[
          const SizedBox(height: 20),
          PaperPanel(
            key: const Key('duplicate-snapshot-warning'),
            color: MindDeckColors.sunshineSoft,
            borderColor: MindDeckColors.sunshine,
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.content_copy_rounded,
                  color: MindDeckColors.ink,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This exact snapshot is already in your library'
                    ' (${match.existingDeckId}). You can still import '
                    'another independent copy.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        StickerButton(
          key: const Key('confirm-import-button'),
          label: importing
              ? 'Adding deck…'
              : duplicate == null
              ? 'Add to my decks'
              : 'Import another copy',
          icon: Icons.add_rounded,
          expanded: true,
          color: MindDeckColors.violet,
          onPressed: importing ? null : onImport,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 20,
              color: MindDeckColors.mutedInk,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Nothing is added until you tap the button. Your copy is '
                'local and will not change when the original changes.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImportCardStack extends StatelessWidget {
  const _ImportCardStack({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final samples = deck.cards.take(3).toList(growable: false);
    return Semantics(
      label: '${deck.title}, ${deck.cards.length} cards',
      image: true,
      child: ExcludeSemantics(
        child: Center(
          child: SizedBox(
            width: 380,
            height: 330,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                const Positioned(
                  top: 12,
                  right: 24,
                  child: DoodleSparkle(
                    size: 27,
                    color: MindDeckColors.sunshine,
                    rotation: .2,
                  ),
                ),
                const Positioned(
                  bottom: 26,
                  left: 18,
                  child: DoodleSparkle(
                    size: 22,
                    color: MindDeckColors.raspberry,
                    rotation: -.25,
                  ),
                ),
                _PreviewCard(
                  front: samples.length > 2
                      ? samples[2].front
                      : 'Ready to learn',
                  back: samples.length > 2
                      ? samples[2].back
                      : 'At your own pace',
                  color: MindDeckColors.mint,
                  rotation: -.075,
                  offset: const Offset(-18, -18),
                ),
                _PreviewCard(
                  front: samples.length > 1
                      ? samples[1].front
                      : '${deck.cards.length} cards',
                  back: samples.length > 1 ? samples[1].back : 'Stored locally',
                  color: MindDeckColors.raspberry,
                  rotation: .065,
                  offset: const Offset(18, 1),
                ),
                _PreviewCard(
                  front: samples.isNotEmpty ? samples.first.front : deck.title,
                  back: samples.isNotEmpty
                      ? samples.first.back
                      : 'This deck is empty',
                  color: MindDeckColors.violet,
                  rotation: -.012,
                  offset: const Offset(0, 22),
                ),
                Positioned(
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: MindDeckColors.sunshine,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: MindDeckColors.ink, width: 1.3),
                      boxShadow: const [
                        BoxShadow(
                          color: MindDeckColors.ink,
                          offset: Offset(2, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      'PREVIEW',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.front,
    required this.back,
    required this.color,
    required this.rotation,
    required this.offset,
  });

  final String front;
  final String back;
  final Color color;
  final double rotation;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: PaperPanel(
        rotation: rotation,
        borderColor: color,
        shadowColor: color.withValues(alpha: .2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        child: SizedBox(
          width: 255,
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    front,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              Container(height: 1.2, color: color.withValues(alpha: .55)),
              const SizedBox(height: 10),
              Text(
                back,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MindDeckColors.mutedInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
