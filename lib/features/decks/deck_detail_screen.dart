import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../design/minddeck_theme.dart';
import 'card_editor_screen.dart';
import 'decks_controller.dart';

class DeckDetailScreen extends StatefulWidget {
  const DeckDetailScreen({
    required this.controller,
    required this.deckId,
    super.key,
    this.onBack,
    this.onStudy,
    this.onShare,
    this.onDeckDeleted,
    this.openCardEditor,
    this.stats,
  });

  final DecksController controller;
  final String deckId;
  final VoidCallback? onBack;
  final ValueChanged<Deck>? onStudy;
  final ValueChanged<Deck>? onShare;
  final VoidCallback? onDeckDeleted;
  final void Function(String deckId, String? cardId)? openCardEditor;
  final DeckStudyStats? stats;

  @override
  State<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends State<DeckDetailScreen> {
  late final TextEditingController _titleController;
  late final FocusNode _titleFocusNode;
  String? _lastDeckTitle;

  @override
  void initState() {
    super.initState();
    final title = widget.controller.deckById(widget.deckId)?.title ?? '';
    _titleController = TextEditingController(text: title);
    _titleFocusNode = FocusNode()..addListener(_saveTitleWhenFocusLeaves);
    _lastDeckTitle = title;
  }

  @override
  void dispose() {
    _saveTitle();
    _titleFocusNode
      ..removeListener(_saveTitleWhenFocusLeaves)
      ..dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _saveTitleWhenFocusLeaves() {
    if (!_titleFocusNode.hasFocus) _saveTitle();
  }

  void _saveTitle() {
    if (_titleController.text.trim().isEmpty) {
      _titleController.text = _lastDeckTitle ?? 'Untitled deck';
      return;
    }
    widget.controller.renameDeck(widget.deckId, _titleController.text);
  }

  void _syncTitle(Deck deck) {
    if (_titleFocusNode.hasFocus || _lastDeckTitle == deck.title) return;
    _lastDeckTitle = deck.title;
    _titleController.text = deck.title;
  }

  Future<void> _openEditor({String? cardId}) async {
    if (widget.openCardEditor case final callback?) {
      callback(widget.deckId, cardId);
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => CardEditorScreen(
          controller: widget.controller,
          deckId: widget.deckId,
          cardId: cardId,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Deck deck) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this deck?'),
        content: Text(
          '“${deck.title}” and all ${deck.cards.length} cards will be removed '
          'from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep deck'),
          ),
          StickerButton(
            label: 'Delete deck',
            color: MindDeckColors.raspberry,
            icon: Icons.delete_outline_rounded,
            compact: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;
    widget.controller.deleteDeck(deck.id);
    widget.onDeckDeleted?.call();
    if (widget.onDeckDeleted == null && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final deck = widget.controller.deckById(widget.deckId);
        if (deck == null) {
          return const _MissingDeckView();
        }
        _syncTitle(deck);
        final stats =
            widget.stats ??
            DeckStudyStats(
              dueCount: 0,
              studiedCount: 0,
              totalCount: deck.cards.length,
            );

        return Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 860;
                final horizontalPadding = wide ? 44.0 : 20.0;
                return CustomScrollView(
                  key: const Key('deck-detail-scroll-view'),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          8,
                          horizontalPadding,
                          0,
                        ),
                        child: _DetailToolbar(
                          onBack: widget.onBack,
                          onShare: widget.onShare == null
                              ? null
                              : () => widget.onShare!(deck),
                          onDelete: () => _confirmDelete(deck),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        wide ? 20 : 8,
                        horizontalPadding,
                        24,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1120),
                          child: Center(
                            child: wide
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 320,
                                        child: _DeckOverview(
                                          deck: deck,
                                          stats: stats,
                                          titleController: _titleController,
                                          titleFocusNode: _titleFocusNode,
                                          onSubmitTitle: _saveTitle,
                                          onToggleDirections: (value) {
                                            widget.controller
                                                .setStudyBothDirections(
                                                  deck.id,
                                                  value,
                                                );
                                          },
                                          onStudy: widget.onStudy == null
                                              ? null
                                              : () => widget.onStudy!(deck),
                                        ),
                                      ),
                                      const SizedBox(width: 34),
                                      Expanded(
                                        child: _CardCollection(
                                          deck: deck,
                                          onAdd: _openEditor,
                                          onEdit: (card) =>
                                              _openEditor(cardId: card.id),
                                          onReorder: (oldIndex, newIndex) {
                                            widget.controller.moveCard(
                                              deckId: deck.id,
                                              oldIndex: oldIndex,
                                              newIndex: newIndex,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _DeckOverview(
                                        deck: deck,
                                        stats: stats,
                                        titleController: _titleController,
                                        titleFocusNode: _titleFocusNode,
                                        onSubmitTitle: _saveTitle,
                                        onToggleDirections: (value) {
                                          widget.controller
                                              .setStudyBothDirections(
                                                deck.id,
                                                value,
                                              );
                                        },
                                        onStudy: widget.onStudy == null
                                            ? null
                                            : () => widget.onStudy!(deck),
                                      ),
                                      const SizedBox(height: 30),
                                      _CardCollection(
                                        deck: deck,
                                        onAdd: _openEditor,
                                        onEdit: (card) =>
                                            _openEditor(cardId: card.id),
                                        onReorder: (oldIndex, newIndex) {
                                          widget.controller.moveCard(
                                            deckId: deck.id,
                                            oldIndex: oldIndex,
                                            newIndex: newIndex,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _DetailToolbar extends StatelessWidget {
  const _DetailToolbar({
    required this.onBack,
    required this.onShare,
    required this.onDelete,
  });

  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          key: const Key('deck-detail-back-button'),
          tooltip: 'Back to library',
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const Spacer(),
        if (onShare != null)
          IconButton(
            tooltip: 'Share deck',
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_rounded),
          ),
        PopupMenuButton<String>(
          tooltip: 'More deck options',
          onSelected: (value) {
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: MindDeckColors.raspberry,
                  ),
                  SizedBox(width: 10),
                  Text('Delete deck'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeckOverview extends StatelessWidget {
  const _DeckOverview({
    required this.deck,
    required this.stats,
    required this.titleController,
    required this.titleFocusNode,
    required this.onSubmitTitle,
    required this.onToggleDirections,
    required this.onStudy,
  });

  final Deck deck;
  final DeckStudyStats stats;
  final TextEditingController titleController;
  final FocusNode titleFocusNode;
  final VoidCallback onSubmitTitle;
  final ValueChanged<bool> onToggleDirections;
  final VoidCallback? onStudy;

  @override
  Widget build(BuildContext context) {
    final progress = stats.completion.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: _LargeDeckCover(title: deck.title)),
        const SizedBox(height: 24),
        TextField(
          key: const Key('deck-title-field'),
          controller: titleController,
          focusNode: titleFocusNode,
          textCapitalization: TextCapitalization.sentences,
          maxLength: 80,
          maxLines: 2,
          style: Theme.of(context).textTheme.headlineLarge,
          decoration: const InputDecoration(
            counterText: '',
            filled: false,
            contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MindDeckColors.violet, width: 2),
            ),
            hintText: 'Untitled deck',
          ),
          onSubmitted: (_) => onSubmitTitle(),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${deck.cards.length} ${deck.cards.length == 1 ? 'card' : 'cards'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (stats.dueCount > 0) ...[
              const SizedBox(width: 15),
              Text(
                '${stats.dueCount} due',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MindDeckColors.raspberry,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        if (stats.totalCount > 0) ...[
          const SizedBox(height: 16),
          Semantics(
            label: '${(progress * 100).round()} percent studied',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 9,
                color: MindDeckColors.mint,
                backgroundColor: MindDeckColors.paperLine.withValues(
                  alpha: .45,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${stats.studiedCount} studied',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 18),
        InkWell(
          key: const Key('both-directions-toggle'),
          onTap: () => onToggleDirections(!deck.studyBothDirections),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: deck.studyBothDirections,
                  onChanged: (value) =>
                      onToggleDirections(value ?? !deck.studyBothDirections),
                ),
                const SizedBox(width: 4),
                const Expanded(child: Text('Study both directions')),
                const DoodleSparkle(size: 18, color: MindDeckColors.raspberry),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        StickerButton(
          key: const Key('study-deck-button'),
          label: deck.cards.isEmpty ? 'Add cards to study' : 'Study now',
          icon: Icons.play_arrow_rounded,
          expanded: true,
          onPressed: deck.cards.isEmpty ? null : onStudy,
        ),
      ],
    );
  }
}

class _LargeDeckCover extends StatelessWidget {
  const _LargeDeckCover({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 178,
      height: 154,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(13, 7),
            child: Transform.rotate(
              angle: .07,
              child: const PaperPanel(
                color: MindDeckColors.raspberrySoft,
                borderColor: MindDeckColors.raspberry,
                padding: EdgeInsets.zero,
                child: SizedBox(width: 125, height: 130),
              ),
            ),
          ),
          Transform.rotate(
            angle: -.06,
            child: PaperPanel(
              color: MindDeckColors.violet,
              borderColor: MindDeckColors.ink,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 125,
                height: 130,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardCollection extends StatelessWidget {
  const _CardCollection({
    required this.deck,
    required this.onAdd,
    required this.onEdit,
    required this.onReorder,
  });

  final Deck deck;
  final VoidCallback onAdd;
  final ValueChanged<MindCard> onEdit;
  final ReorderCallback onReorder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cards',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 3),
                  const SketchUnderline(width: 48),
                ],
              ),
            ),
            StickerButton(
              key: const Key('add-card-button'),
              label: 'Add card',
              icon: Icons.add_rounded,
              compact: true,
              color: MindDeckColors.paper,
              foregroundColor: MindDeckColors.ink,
              borderColor: MindDeckColors.ink,
              onPressed: onAdd,
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (deck.cards.isEmpty)
          _EmptyCards(onAdd: onAdd)
        else
          ReorderableListView.builder(
            key: const Key('deck-card-list'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            itemCount: deck.cards.length,
            onReorderItem: onReorder,
            itemBuilder: (context, index) {
              final card = deck.cards[index];
              return Padding(
                key: ValueKey(card.id),
                padding: const EdgeInsets.only(bottom: 11),
                child: _CardRow(
                  card: card,
                  index: index,
                  onTap: () => onEdit(card),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.card,
    required this.index,
    required this.onTap,
  });

  final MindCard card;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent =
        MindDeckColors.deckColors[index % MindDeckColors.deckColors.length];
    return PaperPanel(
      onTap: onTap,
      semanticLabel: 'Edit card ${index + 1}: ${card.front}, ${card.back}',
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 15,
      borderColor: accent.withValues(alpha: .7),
      shadowOffset: const Offset(2, 2),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Semantics(
              label: 'Reorder card ${index + 1}',
              button: true,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 12, 7),
                child: Icon(
                  Icons.drag_indicator_rounded,
                  size: 21,
                  color: MindDeckColors.mutedInk.withValues(alpha: .75),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              card.front,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.arrow_forward_rounded, size: 17, color: accent),
          ),
          Expanded(
            child: Text(
              card.back,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.edit_outlined,
            size: 18,
            color: MindDeckColors.mutedInk,
          ),
        ],
      ),
    );
  }
}

class _EmptyCards extends StatelessWidget {
  const _EmptyCards({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return PaperPanel(
      borderColor: MindDeckColors.violetSoft,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 32),
      child: Column(
        children: [
          const Icon(
            Icons.style_outlined,
            size: 42,
            color: MindDeckColors.violet,
          ),
          const SizedBox(height: 12),
          Text(
            'This deck needs a first card',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Write a prompt on the front and its answer on the back.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: MindDeckColors.mutedInk),
          ),
          const SizedBox(height: 18),
          StickerButton(
            label: 'Add the first card',
            icon: Icons.add_rounded,
            compact: true,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

class _MissingDeckView extends StatelessWidget {
  const _MissingDeckView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.layers_clear_outlined,
                  size: 50,
                  color: MindDeckColors.raspberry,
                ),
                const SizedBox(height: 16),
                Text(
                  'This deck is no longer here',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
