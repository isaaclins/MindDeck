import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../design/minddeck_theme.dart';
import 'minddeck_sharing_service.dart';
import 'snapshot_models.dart';

class ShareDeckScreen extends StatefulWidget {
  const ShareDeckScreen({
    required this.deck,
    required this.linkBaseUri,
    super.key,
    this.service,
    this.onBack,
  });

  final Deck deck;
  final Uri linkBaseUri;
  final MindDeckSharingService? service;
  final VoidCallback? onBack;

  @override
  State<ShareDeckScreen> createState() => _ShareDeckScreenState();
}

class _ShareDeckScreenState extends State<ShareDeckScreen> {
  late final MindDeckSharingService _service;
  late final MindDeckSharePayload _payload;
  var _sharing = false;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? MindDeckSharingService();
    _payload = _service.prepareShare(
      deck: widget.deck,
      linkBaseUri: widget.linkBaseUri,
    );
  }

  Future<void> _share() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      await _service.share(widget.deck, _payload);
    } on Object {
      if (mounted) _showMessage('MindDeck could not open the share menu.');
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _saveFile() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final saved = await _service.saveAsFile(widget.deck);
      if (mounted && saved) {
        _showMessage('Deck saved as a .minddeck file.');
      }
    } on Object {
      if (mounted) _showMessage('MindDeck could not save this deck.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Share deck'),
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
                  constraints: const BoxConstraints(maxWidth: 880),
                  child: desktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _ShareDeckArtwork(deck: widget.deck),
                            ),
                            const SizedBox(width: 56),
                            Expanded(
                              child: _ShareDetails(
                                deck: widget.deck,
                                payload: _payload,
                                sharing: _sharing,
                                saving: _saving,
                                onShare: _share,
                                onSaveFile: _saveFile,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 300,
                              child: _ShareDeckArtwork(deck: widget.deck),
                            ),
                            const SizedBox(height: 22),
                            _ShareDetails(
                              deck: widget.deck,
                              payload: _payload,
                              sharing: _sharing,
                              saving: _saving,
                              onShare: _share,
                              onSaveFile: _saveFile,
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

class _ShareDetails extends StatelessWidget {
  const _ShareDetails({
    required this.deck,
    required this.payload,
    required this.sharing,
    required this.saving,
    required this.onShare,
    required this.onSaveFile,
  });

  final Deck deck;
  final MindDeckSharePayload payload;
  final bool sharing;
  final bool saving;
  final VoidCallback onShare;
  final VoidCallback onSaveFile;

  @override
  Widget build(BuildContext context) {
    final link = payload.kind == MindDeckShareKind.link;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Pass it on!',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(color: MindDeckColors.violet),
        ),
        const Center(
          child: SketchUnderline(width: 144, color: MindDeckColors.raspberry),
        ),
        const SizedBox(height: 14),
        Text(
          link
              ? 'Every card fits inside one private link.'
              : 'This big deck travels as a tiny .minddeck file.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 22),
        PaperPanel(
          color: link ? MindDeckColors.violetSoft : MindDeckColors.mintSoft,
          borderColor: link ? MindDeckColors.violet : MindDeckColors.mint,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: MindDeckColors.warmWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: MindDeckColors.ink, width: 1.3),
                ),
                child: Icon(
                  link ? Icons.link_rounded : Icons.description_outlined,
                  color: MindDeckColors.ink,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link ? 'Share link' : 'MindDeck file',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${deck.cards.length} '
                      '${deck.cards.length == 1 ? 'card' : 'cards'} · '
                      'answers stay private',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const DoodleSparkle(size: 22),
            ],
          ),
        ),
        const SizedBox(height: 22),
        StickerButton(
          key: const Key('share-deck-button'),
          label: sharing
              ? 'Opening…'
              : link
              ? 'Share link'
              : 'Share file',
          icon: link ? Icons.ios_share_rounded : Icons.send_rounded,
          expanded: true,
          onPressed: sharing ? null : onShare,
        ),
        const SizedBox(height: 12),
        StickerButton(
          key: const Key('save-minddeck-button'),
          label: saving ? 'Saving…' : 'Save .minddeck file',
          icon: Icons.download_rounded,
          expanded: true,
          color: MindDeckColors.warmWhite,
          foregroundColor: MindDeckColors.ink,
          borderColor: MindDeckColors.ink,
          onPressed: saving ? null : onSaveFile,
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 19,
              color: MindDeckColors.mutedInk,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Only the deck text is shared. Study history never leaves '
                'this device.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ShareDeckArtwork extends StatelessWidget {
  const _ShareDeckArtwork({required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'A wrapped stack representing ${deck.title}',
      image: true,
      child: ExcludeSemantics(
        child: Center(
          child: SizedBox(
            width: 300,
            height: 310,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Positioned(
                  left: 12,
                  top: 34,
                  child: DoodleSparkle(
                    color: MindDeckColors.raspberry,
                    rotation: -.2,
                  ),
                ),
                const Positioned(
                  right: 8,
                  top: 72,
                  child: DoodleSparkle(
                    size: 20,
                    color: MindDeckColors.sunshine,
                    rotation: .3,
                  ),
                ),
                Positioned(
                  top: 72,
                  child: _ArtworkCard(
                    deck: deck,
                    cardIndex: 0,
                    rotation: -.07,
                    color: MindDeckColors.mint,
                  ),
                ),
                Positioned(
                  top: 88,
                  child: _ArtworkCard(
                    deck: deck,
                    cardIndex: 1,
                    rotation: .045,
                    color: MindDeckColors.raspberry,
                  ),
                ),
                Positioned(
                  top: 104,
                  child: PaperPanel(
                    borderColor: MindDeckColors.violet,
                    shadowColor: MindDeckColors.violetSoft,
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 212,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            deck.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: MindDeckColors.violet),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${deck.cards.length} '
                            '${deck.cards.length == 1 ? 'card' : 'cards'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 91,
                  child: Container(
                    width: 30,
                    height: 190,
                    decoration: BoxDecoration(
                      color: MindDeckColors.sunshine.withValues(alpha: .9),
                      border: const Border.symmetric(
                        vertical: BorderSide(
                          color: MindDeckColors.ink,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 172,
                  child: Container(
                    width: 258,
                    height: 30,
                    decoration: BoxDecoration(
                      color: MindDeckColors.sunshine.withValues(alpha: .92),
                      border: const Border.symmetric(
                        horizontal: BorderSide(
                          color: MindDeckColors.ink,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 172,
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 32,
                    color: MindDeckColors.raspberry,
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

class _ArtworkCard extends StatelessWidget {
  const _ArtworkCard({
    required this.deck,
    required this.cardIndex,
    required this.rotation,
    required this.color,
  });

  final Deck deck;
  final int cardIndex;
  final double rotation;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = cardIndex < deck.cards.length
        ? deck.cards[cardIndex].front
        : cardIndex == 0
        ? 'Your next idea'
        : '${deck.cards.length} cards';
    return PaperPanel(
      rotation: rotation,
      borderColor: color,
      shadowColor: color.withValues(alpha: .18),
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: 212,
        height: 150,
        child: Align(
          alignment: cardIndex.isEven ? Alignment.topLeft : Alignment.topRight,
          child: Text(
            label,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: cardIndex.isEven ? TextAlign.left : TextAlign.right,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
