import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../design/minddeck_theme.dart';
import 'decks_controller.dart';

typedef DeckStatsResolver = DeckStudyStats Function(Deck deck);

class DeckLibraryScreen extends StatelessWidget {
  const DeckLibraryScreen({
    required this.controller,
    required this.onOpenDeck,
    super.key,
    this.statsForDeck,
    this.onSettings,
  });

  final DecksController controller;
  final ValueChanged<String> onOpenDeck;
  final DeckStatsResolver? statsForDeck;
  final VoidCallback? onSettings;

  Future<void> _createDeck(BuildContext context) async {
    final title = await showDialog<String>(
      context: context,
      builder: (dialogContext) => const _NewDeckDialog(),
    );
    if (title == null || !context.mounted) return;
    final deck = controller.createDeck(title: title);
    onOpenDeck(deck.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth >= 900
                    ? 48.0
                    : constraints.maxWidth >= 600
                    ? 32.0
                    : 20.0;
                return CustomScrollView(
                  key: const Key('deck-library-scroll-view'),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _LibraryHeader(
                        horizontalPadding: horizontalPadding,
                        onAdd: () => _createDeck(context),
                        onSettings: onSettings,
                      ),
                    ),
                    if (controller.decks.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyLibrary(
                          onCreate: () => _createDeck(context),
                        ),
                      )
                    else ...[
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          12,
                          horizontalPadding,
                          12,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            '${controller.decks.length} '
                            '${controller.decks.length == 1 ? 'deck' : 'decks'}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          0,
                          horizontalPadding,
                          48,
                        ),
                        sliver: SliverLayoutBuilder(
                          builder: (context, sliverConstraints) {
                            final availableWidth =
                                sliverConstraints.crossAxisExtent;
                            final columns = availableWidth >= 1020
                                ? 4
                                : availableWidth >= 700
                                ? 3
                                : 2;
                            final aspectRatio = availableWidth < 430
                                ? .64
                                : .72;
                            return SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: 26,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: aspectRatio,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final deck = controller.decks[index];
                                final stats =
                                    statsForDeck?.call(deck) ??
                                    DeckStudyStats(
                                      dueCount: 0,
                                      studiedCount: 0,
                                      totalCount: deck.cards.length,
                                    );
                                return _DeckTile(
                                  key: ValueKey('deck-tile-${deck.id}'),
                                  deck: deck,
                                  stats: stats,
                                  colorIndex: index,
                                  onTap: () => onOpenDeck(deck.id),
                                );
                              }, childCount: controller.decks.length),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NewDeckDialog extends StatefulWidget {
  const _NewDeckDialog();

  @override
  State<_NewDeckDialog> createState() => _NewDeckDialogState();
}

class _NewDeckDialogState extends State<_NewDeckDialog> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _titleController.text.trim();
    if (value.isNotEmpty) Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Name your deck'),
      content: TextField(
        key: const Key('new-deck-title-field'),
        controller: _titleController,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        maxLength: 80,
        decoration: const InputDecoration(
          hintText: 'Spanish basics',
          labelText: 'Deck name',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        StickerButton(
          key: const Key('confirm-new-deck-button'),
          label: 'Create deck',
          icon: Icons.add_rounded,
          compact: true,
          onPressed: _submit,
        ),
      ],
    );
  }
}

class _LibraryHeader extends StatelessWidget {
  const _LibraryHeader({
    required this.horizontalPadding,
    required this.onAdd,
    this.onSettings,
  });

  final double horizontalPadding;
  final VoidCallback onAdd;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 22, horizontalPadding, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MindDeck',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(width: 7),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: DoodleSparkle(size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'What do you want to remember?',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: MindDeckColors.mutedInk,
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.sizeOf(context).width >= 620)
            StickerButton(
              label: 'New deck',
              icon: Icons.add_rounded,
              onPressed: onAdd,
            )
          else
            Semantics(
              button: true,
              label: 'Create a new deck',
              child: IconButton.filled(
                key: const Key('new-deck-button'),
                tooltip: 'New deck',
                onPressed: onAdd,
                style: IconButton.styleFrom(
                  backgroundColor: MindDeckColors.violet,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.square(48),
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ),
          if (onSettings != null) ...[
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Settings',
              onPressed: onSettings,
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _EmptyDeckStack(),
              const SizedBox(height: 28),
              Text(
                'Your first deck starts here',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Add a few front-and-back cards, then learn them at your own '
                'pace.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: MindDeckColors.mutedInk),
              ),
              const SizedBox(height: 24),
              StickerButton(
                key: const Key('empty-create-deck-button'),
                label: 'Create my first deck',
                icon: Icons.add_rounded,
                onPressed: onCreate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDeckStack extends StatelessWidget {
  const _EmptyDeckStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -.1,
            child: const PaperPanel(
              padding: EdgeInsets.zero,
              color: MindDeckColors.sunshineSoft,
              borderColor: MindDeckColors.sunshine,
              child: SizedBox(width: 128, height: 100),
            ),
          ),
          Transform.translate(
            offset: const Offset(18, 4),
            child: Transform.rotate(
              angle: .08,
              child: const PaperPanel(
                padding: EdgeInsets.zero,
                color: MindDeckColors.mintSoft,
                borderColor: MindDeckColors.mint,
                child: SizedBox(width: 128, height: 100),
              ),
            ),
          ),
          const PaperPanel(
            padding: EdgeInsets.zero,
            color: MindDeckColors.paper,
            borderColor: MindDeckColors.violet,
            child: SizedBox(
              width: 128,
              height: 100,
              child: Icon(
                Icons.auto_stories_outlined,
                size: 42,
                color: MindDeckColors.violet,
              ),
            ),
          ),
          const Positioned(top: 4, right: 6, child: DoodleSparkle(size: 30)),
        ],
      ),
    );
  }
}

class _DeckTile extends StatelessWidget {
  const _DeckTile({
    required this.deck,
    required this.stats,
    required this.colorIndex,
    required this.onTap,
    super.key,
  });

  final Deck deck;
  final DeckStudyStats stats;
  final int colorIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = MindDeckColors
        .deckColors[colorIndex % MindDeckColors.deckColors.length];
    final soft = MindDeckColors
        .deckSoftColors[colorIndex % MindDeckColors.deckSoftColors.length];

    return Semantics(
      button: true,
      label: '${deck.title}, ${deck.cards.length} cards, ${stats.dueCount} due',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: 7,
                      left: 7,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: MindDeckColors.paper,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: MindDeckColors.paperLine,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 7,
                      right: 7,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: soft,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(color: accent, width: 1.6),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: .25),
                              offset: const Offset(3, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Stack(
                            children: [
                              Positioned(
                                top: -12,
                                right: -9,
                                child: Icon(
                                  _coverIcon(colorIndex),
                                  size: 68,
                                  color: accent.withValues(alpha: .22),
                                ),
                              ),
                              Positioned(
                                left: 15,
                                right: 12,
                                top: 22,
                                child: Text(
                                  deck.title,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: MindDeckColors.ink,
                                        height: 1.15,
                                      ),
                                ),
                              ),
                              Positioned(
                                right: 12,
                                bottom: 11,
                                child: Icon(
                                  Icons.favorite_border_rounded,
                                  color: accent,
                                  size: 26,
                                ),
                              ),
                              Positioned(
                                left: 12,
                                bottom: 14,
                                child: DoodleSparkle(
                                  size: 18,
                                  color: accent,
                                  rotation: .2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${deck.cards.length} ${deck.cards.length == 1 ? 'card' : 'cards'}',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: MindDeckColors.ink),
              ),
              const SizedBox(height: 1),
              Text(
                stats.dueCount == 0
                    ? deck.cards.isEmpty
                          ? 'Ready for your first card'
                          : 'All caught up'
                    : '${stats.dueCount} due',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: stats.dueCount > 0
                      ? MindDeckColors.raspberry
                      : MindDeckColors.mutedInk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _coverIcon(int index) {
    return switch (index % 5) {
      0 => Icons.translate_rounded,
      1 => Icons.eco_outlined,
      2 => Icons.draw_outlined,
      3 => Icons.menu_book_rounded,
      _ => Icons.public_rounded,
    };
  }
}
