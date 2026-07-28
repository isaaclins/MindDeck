import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The deliberately small, high-contrast palette used throughout MindDeck.
abstract final class MindDeckColors {
  static const cream = Color(0xFFFFFBF2);
  static const warmWhite = Color(0xFFFFFEFA);
  static const paper = Color(0xFFFFFDF8);
  static const ink = Color(0xFF25232A);
  static const mutedInk = Color(0xFF69636B);
  static const paperLine = Color(0xFFD9CFC0);
  static const violet = Color(0xFF6C4BFF);
  static const violetSoft = Color(0xFFE1DAFF);
  static const raspberry = Color(0xFFFF4775);
  static const raspberrySoft = Color(0xFFFFD7E1);
  static const mint = Color(0xFF83D973);
  static const mintSoft = Color(0xFFDDF6D4);
  static const sunshine = Color(0xFFFFD34E);
  static const sunshineSoft = Color(0xFFFFEDAD);
  static const sky = Color(0xFF75CFF4);
  static const skySoft = Color(0xFFD8F3FF);

  static const deckColors = <Color>[violet, mint, raspberry, sunshine, sky];

  static const deckSoftColors = <Color>[
    violetSoft,
    mintSoft,
    raspberrySoft,
    sunshineSoft,
    skySoft,
  ];
}

abstract final class MindDeckTheme {
  static const _displayFontFallback = <String>[
    'Chalkboard SE',
    'Marker Felt',
    'Comic Sans MS',
    'Segoe Print',
    'sans-serif',
  ];

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: MindDeckColors.violet,
      onPrimary: Colors.white,
      primaryContainer: MindDeckColors.violetSoft,
      onPrimaryContainer: MindDeckColors.ink,
      secondary: MindDeckColors.raspberry,
      onSecondary: Colors.white,
      secondaryContainer: MindDeckColors.raspberrySoft,
      onSecondaryContainer: MindDeckColors.ink,
      tertiary: MindDeckColors.mint,
      onTertiary: MindDeckColors.ink,
      surface: MindDeckColors.cream,
      onSurface: MindDeckColors.ink,
      error: MindDeckColors.raspberry,
      onError: Colors.white,
      outline: MindDeckColors.paperLine,
    );

    final baseTextTheme = Typography.material2021().black.apply(
      bodyColor: MindDeckColors.ink,
      displayColor: MindDeckColors.ink,
      fontFamily: 'Nunito',
      fontFamilyFallback: const [
        'Nunito',
        'Trebuchet MS',
        'Arial Rounded MT Bold',
        'sans-serif',
      ],
    );

    TextStyle displayStyle(double size, FontWeight weight) {
      return TextStyle(
        color: MindDeckColors.ink,
        fontSize: size,
        fontWeight: weight,
        height: 1.05,
        letterSpacing: .2,
        fontFamily: 'PatrickHand',
        fontFamilyFallback: _displayFontFallback,
      );
    }

    final textTheme = baseTextTheme.copyWith(
      displayLarge: displayStyle(52, FontWeight.w700),
      displayMedium: displayStyle(42, FontWeight.w700),
      displaySmall: displayStyle(34, FontWeight.w700),
      headlineLarge: displayStyle(31, FontWeight.w700),
      headlineMedium: displayStyle(26, FontWeight.w700),
      headlineSmall: displayStyle(22, FontWeight.w700),
      titleLarge: displayStyle(20, FontWeight.w700),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: .1,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 17, height: 1.42),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 15, height: 1.4),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: MindDeckColors.mutedInk,
        fontSize: 13,
        height: 1.35,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: .1,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: MindDeckColors.cream,
      canvasColor: MindDeckColors.cream,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: MindDeckColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),
      dividerTheme: const DividerThemeData(
        color: MindDeckColors.paperLine,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MindDeckColors.warmWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: MindDeckColors.mutedInk.withValues(alpha: .68),
        ),
        border: _sketchInputBorder(MindDeckColors.paperLine),
        enabledBorder: _sketchInputBorder(MindDeckColors.paperLine),
        focusedBorder: _sketchInputBorder(MindDeckColors.violet, width: 2),
        errorBorder: _sketchInputBorder(MindDeckColors.raspberry),
        focusedErrorBorder: _sketchInputBorder(
          MindDeckColors.raspberry,
          width: 2,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MindDeckColors.violet;
          }
          return MindDeckColors.warmWhite;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: MindDeckColors.ink, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: MindDeckColors.cream,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: MindDeckColors.paperLine),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: MindDeckColors.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: MindDeckColors.ink,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      focusColor: MindDeckColors.violetSoft,
    );
  }

  static OutlineInputBorder _sketchInputBorder(
    Color color, {
    double width = 1.2,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// A paper-like surface with a deliberately physical edge and tinted shadow.
class PaperPanel extends StatelessWidget {
  const PaperPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.color = MindDeckColors.paper,
    this.borderColor = MindDeckColors.paperLine,
    this.borderWidth = 1.2,
    this.borderRadius = 20,
    this.shadowOffset = const Offset(3, 4),
    this.shadowColor,
    this.rotation = 0,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Offset shadowOffset;
  final Color? shadowColor;
  final double rotation;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    Widget panel = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color:
                shadowColor ??
                borderColor.withValues(
                  alpha: borderColor == Colors.transparent ? 0 : .18,
                ),
            offset: shadowOffset,
            blurRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          canRequestFocus: onTap != null,
          focusColor: MindDeckColors.violetSoft.withValues(alpha: .45),
          hoverColor: MindDeckColors.warmWhite.withValues(alpha: .4),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    if (semanticLabel != null) {
      panel = Semantics(
        label: semanticLabel,
        button: onTap != null,
        child: panel,
      );
    }

    if (rotation != 0) {
      panel = Transform.rotate(angle: rotation, child: panel);
    }

    return panel;
  }
}

/// A button that behaves like a pressed paper sticker.
class StickerButton extends StatefulWidget {
  const StickerButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.color = MindDeckColors.violet,
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.expanded = false,
    this.compact = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final Color foregroundColor;
  final Color? borderColor;
  final bool expanded;
  final bool compact;
  final String? semanticLabel;

  @override
  State<StickerButton> createState() => _StickerButtonState();
}

class _StickerButtonState extends State<StickerButton> {
  var _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed == pressed) return;
    setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final borderColor = widget.borderColor ?? widget.color;
    final shadowColor = borderColor.withValues(alpha: enabled ? .35 : .12);

    Widget result = AnimatedScale(
      scale: _pressed ? .975 : 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: enabled
              ? widget.color
              : MindDeckColors.paperLine.withValues(alpha: .55),
          borderRadius: BorderRadius.circular(widget.compact ? 13 : 16),
          border: Border.all(
            color: enabled ? borderColor : MindDeckColors.paperLine,
            width: 1.5,
          ),
          boxShadow: _pressed
              ? const []
              : [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(2, 3),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: enabled ? _setPressed : null,
            borderRadius: BorderRadius.circular(widget.compact ? 13 : 16),
            focusColor: Colors.white.withValues(alpha: .22),
            hoverColor: Colors.white.withValues(alpha: .12),
            child: Padding(
              padding: widget.compact
                  ? const EdgeInsets.symmetric(horizontal: 14, vertical: 9)
                  : const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: widget.expanded
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon case final icon?) ...[
                    Icon(
                      icon,
                      size: widget.compact ? 18 : 21,
                      color: enabled
                          ? widget.foregroundColor
                          : MindDeckColors.mutedInk,
                    ),
                    const SizedBox(width: 9),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: enabled
                            ? widget.foregroundColor
                            : MindDeckColors.mutedInk,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.expanded) {
      result = SizedBox(width: double.infinity, child: result);
    }

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel ?? widget.label,
      child: ExcludeSemantics(child: result),
    );
  }
}

/// Small hand-drawn decoration used sparingly around important objects.
class DoodleSparkle extends StatelessWidget {
  const DoodleSparkle({
    super.key,
    this.color = MindDeckColors.sunshine,
    this.size = 28,
    this.rotation = 0,
  });

  final Color color;
  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Transform.rotate(
        angle: rotation,
        child: CustomPaint(
          size: Size.square(size),
          painter: _SparklePainter(color),
        ),
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    const points = 8;
    for (var index = 0; index < points; index++) {
      final angle = -math.pi / 2 + index * math.pi / 4;
      final radius = index.isEven ? size.width * .48 : size.width * .12;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, size.width * .07)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class SketchUnderline extends StatelessWidget {
  const SketchUnderline({
    required this.width,
    super.key,
    this.color = MindDeckColors.violet,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size(width, 8),
        painter: _UnderlinePainter(color),
      ),
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  const _UnderlinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final first = Path()
      ..moveTo(1, 2)
      ..quadraticBezierTo(size.width * .42, 5, size.width - 1, 2);
    final second = Path()
      ..moveTo(size.width * .17, 6)
      ..quadraticBezierTo(size.width * .58, 3, size.width * .88, 5);
    canvas
      ..drawPath(first, paint)
      ..drawPath(second, paint..strokeWidth = 1.4);
  }

  @override
  bool shouldRepaint(covariant _UnderlinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
