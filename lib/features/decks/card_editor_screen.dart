import 'package:flutter/material.dart';

import '../../core/models.dart';
import '../../design/minddeck_theme.dart';
import 'decks_controller.dart';

class CardEditorScreen extends StatefulWidget {
  const CardEditorScreen({
    required this.controller,
    required this.deckId,
    super.key,
    this.cardId,
    this.onClose,
    this.onSaved,
    this.onDeleted,
  });

  final DecksController controller;
  final String deckId;
  final String? cardId;
  final VoidCallback? onClose;
  final ValueChanged<MindCard>? onSaved;
  final VoidCallback? onDeleted;

  bool get editingExistingCard => cardId != null;

  @override
  State<CardEditorScreen> createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends State<CardEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _frontController;
  late final TextEditingController _backController;
  late final FocusNode _frontFocusNode;
  late final FocusNode _backFocusNode;
  var _saving = false;

  Deck? get _deck => widget.controller.deckById(widget.deckId);

  MindCard? get _card {
    final deck = _deck;
    if (deck == null || widget.cardId == null) return null;
    for (final card in deck.cards) {
      if (card.id == widget.cardId) return card;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final card = _card;
    _frontController = TextEditingController(text: card?.front ?? '');
    _backController = TextEditingController(text: card?.back ?? '');
    _frontFocusNode = FocusNode();
    _backFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _frontFocusNode.dispose();
    _backFocusNode.dispose();
    super.dispose();
  }

  void _close() {
    if (widget.onClose case final callback?) {
      callback();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  String? _validateSide(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Add some text to this side.';
    }
    return null;
  }

  void _save() {
    if (_saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    MindCard savedCard;
    if (widget.cardId case final cardId?) {
      widget.controller.updateCard(
        deckId: widget.deckId,
        cardId: cardId,
        front: _frontController.text,
        back: _backController.text,
      );
      savedCard = widget.controller
          .deckById(widget.deckId)!
          .cards
          .firstWhere((card) => card.id == cardId);
    } else {
      savedCard = widget.controller.addCard(
        deckId: widget.deckId,
        front: _frontController.text,
        back: _backController.text,
      );
    }
    widget.onSaved?.call(savedCard);
    _close();
  }

  Future<void> _delete() async {
    final cardId = widget.cardId;
    if (cardId == null) return;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this card?'),
        content: const Text('This removes it from the deck on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep card'),
          ),
          StickerButton(
            key: const Key('confirm-delete-card-button'),
            label: 'Delete card',
            color: MindDeckColors.raspberry,
            icon: Icons.delete_outline_rounded,
            compact: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;
    widget.controller.deleteCard(deckId: widget.deckId, cardId: cardId);
    widget.onDeleted?.call();
    _close();
  }

  @override
  Widget build(BuildContext context) {
    if (_deck == null || (widget.editingExistingCard && _card == null)) {
      return const _UnavailableCardEditor();
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _EditorToolbar(
                editingExistingCard: widget.editingExistingCard,
                onClose: _close,
                onSave: _save,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 820;
                    return SingleChildScrollView(
                      key: const Key('card-editor-scroll-view'),
                      padding: EdgeInsets.fromLTRB(
                        wide ? 52 : 20,
                        wide ? 32 : 14,
                        wide ? 52 : 20,
                        36,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1050),
                          child: Column(
                            children: [
                              if (wide)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _CardSideEditor(
                                        key: const Key('front-card-panel'),
                                        label: 'Front',
                                        hint: 'Hola',
                                        controller: _frontController,
                                        focusNode: _frontFocusNode,
                                        accent: MindDeckColors.violet,
                                        maxHeight: 360,
                                        validator: _validateSide,
                                        onSubmitted: (_) =>
                                            _backFocusNode.requestFocus(),
                                      ),
                                    ),
                                    const SizedBox(width: 26),
                                    Expanded(
                                      child: _CardSideEditor(
                                        key: const Key('back-card-panel'),
                                        label: 'Back',
                                        hint: 'Hello',
                                        controller: _backController,
                                        focusNode: _backFocusNode,
                                        accent: MindDeckColors.raspberry,
                                        maxHeight: 360,
                                        validator: _validateSide,
                                        onSubmitted: (_) => _save(),
                                      ),
                                    ),
                                  ],
                                )
                              else ...[
                                _CardSideEditor(
                                  key: const Key('front-card-panel'),
                                  label: 'Front',
                                  hint: 'Hola',
                                  controller: _frontController,
                                  focusNode: _frontFocusNode,
                                  accent: MindDeckColors.violet,
                                  maxHeight: 250,
                                  validator: _validateSide,
                                  onSubmitted: (_) =>
                                      _backFocusNode.requestFocus(),
                                ),
                                const SizedBox(height: 22),
                                _CardSideEditor(
                                  key: const Key('back-card-panel'),
                                  label: 'Back',
                                  hint: 'Hello',
                                  controller: _backController,
                                  focusNode: _backFocusNode,
                                  accent: MindDeckColors.raspberry,
                                  maxHeight: 250,
                                  validator: _validateSide,
                                  onSubmitted: (_) => _save(),
                                ),
                              ],
                              const SizedBox(height: 24),
                              _DirectionsToggle(
                                controller: widget.controller,
                                deckId: widget.deckId,
                              ),
                              if (widget.editingExistingCard) ...[
                                const SizedBox(height: 28),
                                TextButton.icon(
                                  key: const Key('delete-card-button'),
                                  onPressed: _delete,
                                  style: TextButton.styleFrom(
                                    foregroundColor: MindDeckColors.raspberry,
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                  label: const Text('Delete card'),
                                ),
                              ],
                              if (!wide) ...[
                                const SizedBox(height: 22),
                                StickerButton(
                                  key: const Key('mobile-save-card-button'),
                                  label: widget.editingExistingCard
                                      ? 'Save changes'
                                      : 'Add card',
                                  icon: Icons.check_rounded,
                                  expanded: true,
                                  onPressed: _saving ? null : _save,
                                ),
                              ],
                            ],
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
      ),
    );
  }
}

class _EditorToolbar extends StatelessWidget {
  const _EditorToolbar({
    required this.editingExistingCard,
    required this.onClose,
    required this.onSave,
  });

  final bool editingExistingCard;
  final VoidCallback onClose;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;
    return Padding(
      padding: EdgeInsets.fromLTRB(wide ? 44 : 8, 8, wide ? 44 : 8, 4),
      child: Row(
        children: [
          IconButton(
            key: const Key('close-card-editor-button'),
            tooltip: 'Close card editor',
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
          ),
          Expanded(
            child: Text(
              editingExistingCard ? 'Edit card' : 'New card',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          if (wide)
            StickerButton(
              key: const Key('save-card-button'),
              label: editingExistingCard ? 'Save changes' : 'Add card',
              icon: Icons.check_rounded,
              compact: true,
              onPressed: onSave,
            )
          else
            IconButton.filled(
              key: const Key('save-card-button'),
              tooltip: editingExistingCard ? 'Save changes' : 'Add card',
              onPressed: onSave,
              style: IconButton.styleFrom(
                backgroundColor: MindDeckColors.violet,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check_rounded),
            ),
        ],
      ),
    );
  }
}

class _CardSideEditor extends StatelessWidget {
  const _CardSideEditor({
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    required this.accent,
    required this.maxHeight,
    required this.validator,
    required this.onSubmitted,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color accent;
  final double maxHeight;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: '$label side',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 7,
            left: 6,
            right: -5,
            bottom: -7,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: MindDeckColors.paper,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: MindDeckColors.paperLine),
              ),
            ),
          ),
          PaperPanel(
            color: MindDeckColors.warmWhite,
            borderColor: accent,
            borderRadius: 20,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: SizedBox(
              height: maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: accent, letterSpacing: .8),
                      ),
                      const SizedBox(width: 6),
                      DoodleSparkle(size: 15, color: accent),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextFormField(
                      key: ValueKey('${label.toLowerCase()}-card-field'),
                      controller: controller,
                      focusNode: focusNode,
                      validator: validator,
                      autofocus: label == 'Front',
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      maxLength: 1000,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      textCapitalization: TextCapitalization.sentences,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        hintText: hint,
                        counterText: '',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                      ),
                      onFieldSubmitted: onSubmitted,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller,
                      builder: (context, value, _) {
                        return Text(
                          '${value.text.characters.length} / 1000',
                          style: Theme.of(context).textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionsToggle extends StatelessWidget {
  const _DirectionsToggle({required this.controller, required this.deckId});

  final DecksController controller;
  final String deckId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final deck = controller.deckById(deckId);
        if (deck == null) return const SizedBox.shrink();
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: InkWell(
              key: const Key('card-editor-directions-toggle'),
              borderRadius: BorderRadius.circular(14),
              onTap: () => controller.setStudyBothDirections(
                deck.id,
                !deck.studyBothDirections,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: deck.studyBothDirections,
                      onChanged: (value) => controller.setStudyBothDirections(
                        deck.id,
                        value ?? !deck.studyBothDirections,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Expanded(child: Text('Study both directions')),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.sync_alt_rounded,
                      color: MindDeckColors.raspberry,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UnavailableCardEditor extends StatelessWidget {
  const _UnavailableCardEditor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'This card is no longer available.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
