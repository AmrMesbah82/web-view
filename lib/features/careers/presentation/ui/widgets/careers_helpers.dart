part of '../pages/careers_page.dart';

class _BP {
  static const double mobile = 600;
  static const double tablet = 1024;
}

// ── Content width + hPad ─────────────────────────────────────────────────────
double _desktopContentW() => (248.w * 4) + (8.w * 3);
double _desktopHPad(double screenW) =>
    ((screenW - _desktopContentW()) / 2).clamp(16.0, double.infinity);
double _tabletHPad() => 16.w;

// ── Deep-link tab resolution ──────────────────────────────────────────────────
int _resolveTabParam(String? raw) {
  switch (raw?.toLowerCase().trim()) {
    case 'why-join-our-team':
      return 0;
    case 'interns':
      return 1;
    case 'our-team':
      return 2;
    default:
      return 0;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ANIMATION SYSTEM  (unchanged)
// ═══════════════════════════════════════════════════════════════════════════════

enum _SlideDirection { fromBottom, fromLeft, fromRight, fromTop }
