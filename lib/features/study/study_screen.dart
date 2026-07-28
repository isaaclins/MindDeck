import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/models.dart';
import '../../design/minddeck_theme.dart';
import 'study_controller.dart';
import 'study_engine.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({
    required this.deck,
    super.key,
    this.controller,
    this.initialProgress = const <StudyCardProgress>[],
    this.restoredSession,
    this.randomSeed = 0,
    this.now,
    this.onExit,
    this.onSnapshotChanged,
    this.onDone,
    this.onStudyAgain,
  });

  final Deck deck;
  final StudyController? controller;
  final Iterable<StudyCardProgress> initialProgress;
  final StudySessionSnapshot? restoredSession;
  final int randomSeed;
  final StudyNow? now;
  final VoidCallback? onExit;
  final ValueChanged<StudySessionSnapshot>? onSnapshotChanged;
  final VoidCallback? onDone;
  final VoidCallback? onStudyAgain;

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  late final StudyController _controller;
  late final bool _ownsController;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        StudyController(
          deck: widget.deck,
          initialProgress: widget.initialProgress,
          restoredSession: widget.restoredSession,
          randomSeed: widget.randomSeed,
          now: widget.now,
        );
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _reveal() {
    _controller.reveal();
  }

  void _grade(bool correct) {
    if (!_controller.isRevealed) {
      return;
    }
    setState(() => _dragOffset = 0);
    _controller.grade(correct: correct);
    widget.onSnapshotChanged?.call(_controller.snapshot);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      widget.onExit?.call();
      return KeyEventResult.handled;
    }
    if (!_controller.isRevealed &&
        (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.enter)) {
      _reveal();
      return KeyEventResult.handled;
    }
    if (_controller.isRevealed && key == LogicalKeyboardKey.arrowRight) {
      _grade(true);
      return KeyEventResult.handled;
    }
    if (_controller.isRevealed && key == LogicalKeyboardKey.arrowLeft) {
      _grade(false);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isComplete) {
            return SessionSummaryScreen(
              deck: widget.deck,
              snapshot: _controller.snapshot,
              onDone: widget.onDone,
              onStudyAgain: widget.onStudyAgain,
            );
          }
          return _StudyPage(
            deck: widget.deck,
            controller: _controller,
            dragOffset: _dragOffset,
            onDragUpdate: (delta) {
              if (!_controller.isRevealed) {
                return;
              }
              setState(() => _dragOffset += delta);
            },
            onDragEnd: () {
              if (_dragOffset.abs() >= 72) {
                _grade(_dragOffset > 0);
              } else {
                setState(() => _dragOffset = 0);
              }
            },
            onReveal: _reveal,
            onCorrect: () => _grade(true),
            onWrong: () => _grade(false),
            onExit: widget.onExit,
          );
        },
      ),
    );
  }
}

class _StudyPage extends StatelessWidget {
  const _StudyPage({
    required this.deck,
    required this.controller,
    required this.dragOffset,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onReveal,
    required this.onCorrect,
    required this.onWrong,
    this.onExit,
  });

  final Deck deck;
  final StudyController controller;
  final double dragOffset;
  final ValueChanged<double> onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onReveal;
  final VoidCallback onCorrect;
  final VoidCallback onWrong;
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    final item = controller.currentItem!;
    final isRevealed = controller.isRevealed;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _StudyHeader(
              position: controller.displayPosition,
              total: controller.session.initialItemCount,
              onExit: onExit,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth < 600
                      ? 22.0
                      : 48.0;
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      28,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(0, constraints.maxHeight - 40),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 650),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _FlashcardStack(
                                key: const Key('study-card'),
                                text: isRevealed
                                    ? item.backText(deck)
                                    : item.frontText(deck),
                                isRevealed: isRevealed,
                                dragOffset: dragOffset,
                                onDragUpdate: onDragUpdate,
                                onDragEnd: onDragEnd,
                                onTap: onReveal,
                              ),
                              const SizedBox(height: 26),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: isRevealed
                                    ? _GradeControls(
                                        key: const Key('grade-controls'),
                                        onCorrect: onCorrect,
                                        onWrong: onWrong,
                                      )
                                    : _RevealHint(
                                        key: const Key('reveal-hint'),
                                        onReveal: onReveal,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudyHeader extends StatelessWidget {
  const _StudyHeader({
    required this.position,
    required this.total,
    this.onExit,
  });

  final int position;
  final int total;
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Leave study session',
            onPressed: onExit,
            icon: const Icon(Icons.close_rounded),
          ),
          const Spacer(),
          SizedBox(
            width: 180,
            child: Column(
              children: [
                Text(
                  '$position / $total',
                  key: const Key('study-progress-label'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    value: total == 0 ? 0 : (position - 1) / total,
                    color: MindDeckColors.violet,
                    backgroundColor: MindDeckColors.paperLine.withValues(
                      alpha: .55,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _FlashcardStack extends StatelessWidget {
  const _FlashcardStack({
    required this.text,
    required this.isRevealed,
    required this.dragOffset,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onTap,
    super.key,
  });

  final String text;
  final bool isRevealed;
  final double dragOffset;
  final ValueChanged<double> onDragUpdate;
  final VoidCallback onDragEnd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isRevealed
        ? MindDeckColors.raspberry
        : MindDeckColors.violet;
    return Semantics(
      label: isRevealed ? 'Answer: $text' : 'Question: $text',
      button: !isRevealed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isRevealed ? null : onTap,
        onHorizontalDragUpdate: (details) => onDragUpdate(details.delta.dx),
        onHorizontalDragEnd: (_) => onDragEnd(),
        child: SizedBox(
          height: 360,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 30,
                right: 14,
                top: 20,
                bottom: 8,
                child: PaperPanel(
                  padding: EdgeInsets.zero,
                  rotation: .035,
                  borderColor: MindDeckColors.paperLine,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                left: 17,
                right: 25,
                top: 10,
                bottom: 17,
                child: PaperPanel(
                  padding: EdgeInsets.zero,
                  rotation: -.018,
                  borderColor: MindDeckColors.paperLine,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                top: 4,
                bottom: 25,
                child: AnimatedContainer(
                  duration: dragOffset == 0
                      ? const Duration(milliseconds: 180)
                      : Duration.zero,
                  curve: Curves.easeOut,
                  transform: Matrix4.identity()
                    ..translateByDouble(dragOffset, 0, 0, 1)
                    ..rotateZ(dragOffset / 1900),
                  transformAlignment: Alignment.center,
                  child: PaperPanel(
                    color: MindDeckColors.warmWhite,
                    borderColor: borderColor,
                    borderWidth: 2,
                    borderRadius: 19,
                    shadowColor: borderColor.withValues(alpha: .18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 34,
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          right: 0,
                          top: 0,
                          child: DoodleSparkle(
                            color: MindDeckColors.violet,
                            size: 32,
                            rotation: .18,
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 28,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    text,
                                    key: ValueKey<String>(
                                      isRevealed
                                          ? 'answer-$text'
                                          : 'front-$text',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          fontSize: text.length > 80 ? 26 : 38,
                                          height: 1.18,
                                        ),
                                  ),
                                  const SizedBox(height: 13),
                                  SketchUnderline(
                                    width: math.min(
                                      130,
                                      52 + text.length * 2.0,
                                    ),
                                    color: borderColor,
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}

class _RevealHint extends StatelessWidget {
  const _RevealHint({required this.onReveal, super.key});

  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Reveal answer',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onReveal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Text(
                'Tap to reveal',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'Space or Enter',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeControls extends StatelessWidget {
  const _GradeControls({
    required this.onCorrect,
    required this.onWrong,
    super.key,
  });

  final VoidCallback onCorrect;
  final VoidCallback onWrong;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('How did you do?', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StickerButton(
              key: const Key('wrong-button'),
              label: 'Wrong',
              icon: Icons.close_rounded,
              color: MindDeckColors.raspberry,
              onPressed: onWrong,
              semanticLabel: 'Mark answer wrong',
            ),
            const SizedBox(width: 18),
            StickerButton(
              key: const Key('correct-button'),
              label: 'Correct',
              icon: Icons.check_rounded,
              color: MindDeckColors.mint,
              foregroundColor: MindDeckColors.ink,
              onPressed: onCorrect,
              semanticLabel: 'Mark answer correct',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Swipe left for wrong · right for correct',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class SessionSummaryScreen extends StatelessWidget {
  const SessionSummaryScreen({
    required this.deck,
    required this.snapshot,
    super.key,
    this.onDone,
    this.onStudyAgain,
  });

  final Deck deck;
  final StudySessionSnapshot snapshot;
  final VoidCallback? onDone;
  final VoidCallback? onStudyAgain;

  @override
  Widget build(BuildContext context) {
    final session = snapshot.session;
    final missedItems = session.missedItems;
    final headline = session.initialItemCount == 0
        ? 'All caught up'
        : 'Nice work!';
    return Scaffold(
      key: const Key('session-summary'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const DoodleSparkle(
                        color: MindDeckColors.sunshine,
                        size: 34,
                        rotation: -.12,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        headline,
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(color: MindDeckColors.violet),
                      ),
                      const SizedBox(width: 14),
                      const DoodleSparkle(
                        color: MindDeckColors.mint,
                        size: 28,
                        rotation: .18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCount(
                          key: const Key('correct-count'),
                          icon: Icons.check_circle_outline_rounded,
                          value: session.firstTryCorrectCount,
                          label: 'Correct',
                          color: MindDeckColors.mint,
                          softColor: MindDeckColors.mintSoft,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCount(
                          key: const Key('review-count'),
                          icon: Icons.refresh_rounded,
                          value: missedItems.length,
                          label: 'To review',
                          color: MindDeckColors.raspberry,
                          softColor: MindDeckColors.raspberrySoft,
                        ),
                      ),
                    ],
                  ),
                  if (missedItems.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Review these cards',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _MissedCardGrid(deck: deck, items: missedItems),
                  ] else if (session.initialItemCount > 0) ...[
                    const SizedBox(height: 30),
                    PaperPanel(
                      color: MindDeckColors.sunshineSoft,
                      borderColor: MindDeckColors.sunshine,
                      rotation: -.01,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const DoodleSparkle(size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Every card landed on the first try.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 30),
                    Text(
                      'There are no cards due right now.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  const SizedBox(height: 34),
                  Row(
                    children: [
                      if (onStudyAgain != null) ...[
                        Expanded(
                          child: StickerButton(
                            key: const Key('study-again-button'),
                            label: 'Study again',
                            icon: Icons.refresh_rounded,
                            color: MindDeckColors.warmWhite,
                            foregroundColor: MindDeckColors.ink,
                            borderColor: MindDeckColors.ink,
                            expanded: true,
                            onPressed: onStudyAgain,
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                      Expanded(
                        child: StickerButton(
                          key: const Key('done-button'),
                          label: 'Done',
                          icon: Icons.check_rounded,
                          expanded: true,
                          onPressed: onDone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCount extends StatelessWidget {
  const _SummaryCount({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.softColor,
    super.key,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final Color softColor;

  @override
  Widget build(BuildContext context) {
    return PaperPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: softColor,
      borderColor: color,
      borderRadius: 16,
      shadowOffset: const Offset(2, 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$value', style: Theme.of(context).textTheme.headlineMedium),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _MissedCardGrid extends StatelessWidget {
  const _MissedCardGrid({required this.deck, required this.items});

  final Deck deck;
  final List<StudyItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 540 ? 2 : 1;
        final gap = 14.0;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var index = 0; index < items.length; index++)
              SizedBox(
                width: cardWidth,
                child: PaperPanel(
                  key: ValueKey<String>('missed-${items[index].key}'),
                  padding: const EdgeInsets.all(16),
                  rotation: index.isEven ? -.012 : .012,
                  borderColor: MindDeckColors.paperLine,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[index].frontText(deck),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: Divider(height: 1),
                      ),
                      Text(
                        items[index].backText(deck),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
