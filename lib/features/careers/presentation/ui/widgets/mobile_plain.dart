part of '../pages/careers_page.dart';

class _MobilePlain extends StatelessWidget {
  final String text;
  const _MobilePlain(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: StyleText.fontSize13Weight400.copyWith(
      fontSize: 11.sp,
      height: 1.65,
      color: Colors.black87,
    ),
  );
}

// ── Mobile stats ──────────────────────────────────────────────────────────────
