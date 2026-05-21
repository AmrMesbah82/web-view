part of '../pages/contact_us_page.dart';

class _BP {
  static const double mobile = 600;
  static const double tablet = 1024;
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAP LINK LAUNCHER
// ═══════════════════════════════════════════════════════════════════════════════

Future<void> _launchMapLink(String mapLink) async {
  if (mapLink.isEmpty) return;
  String raw = mapLink.trim();
  if (!raw.startsWith('http://') && !raw.startsWith('https://')) {
    raw = 'https://$raw';
  }
  final uri = Uri.tryParse(raw);
  if (uri == null || !uri.hasAuthority) return;
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ANIMATION SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

enum _SlideDirection { fromBottom, fromLeft, fromRight, fromTop }
