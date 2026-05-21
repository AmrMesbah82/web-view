part of '../pages/careers_page.dart';

class _PlainText extends StatelessWidget {
  final String text;
  final double fontSize;
  const _PlainText(this.text, {this.fontSize = 13});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: StyleText.fontSize15Weight400.copyWith(
      fontSize: fontSize,
      height: 1.65,
      color: Colors.black87,
    ),
  );
}

// ── Desktop Apply Now button ──────────────────────────────────────────────────
