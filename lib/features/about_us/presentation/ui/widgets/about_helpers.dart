part of '../pages/about_us_page.dart';

class _BP {
  static const double mobile = 600;
  static const double tablet = 1024;
}

Color _hoverTint(Color primary) => primary.withOpacity(0.12);

double _desktopContentWidth(BuildContext context) {
  final double screen = MediaQuery.of(context).size.width;
  final double natural = (248.w * 4) + (8.w * 3);
  return natural.clamp(0.0, screen - 64.0);
}

String _ab(AboutBilingualText b, bool isRtl) {
  final v = isRtl ? b.ar : b.en;
  return v.isNotEmpty ? v : b.en;
}

Color _parseColor(String hex, {required Color fallback}) {
  final h = hex.replaceAll('#', '');
  if (h.length == 6) {
    final value = int.tryParse('FF$h', radix: 16);
    if (value != null) return Color(value);
  }
  return fallback;
}

({int topTab, int subTab}) _resolveTabParam(String? raw) {
  switch (raw?.toLowerCase().trim()) {
    case 'our-strategy':
      return (topTab: 1, subTab: 0);
    case 'terms-and-conditions':
      return (topTab: 2, subTab: 0);
    case 'privacy-policy':
      return (topTab: 3, subTab: 0);
    case 'vision':
      return (topTab: 0, subTab: 0);
    case 'mission':
      return (topTab: 0, subTab: 1);
    case 'values':
      return (topTab: 0, subTab: 2);
    case 'our-team':
    case 'why-join-our-team':
    case 'about-us':
    default:
      return (topTab: 0, subTab: 0);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// XHR Image Cache
// ══════════════════════════════════════════════════════════════════════════════

final Map<String, Future<Uint8List>> _globalUrlCache = {};

Future<Uint8List> _xhrLoad(String url, {bool isSvg = false}) {
  return _globalUrlCache.putIfAbsent(url, () async {
    final response = await html.HttpRequest.request(
      url,
      method: 'GET',
      responseType: 'arraybuffer',
      mimeType: isSvg ? 'image/svg+xml' : null,
    );
    if (response.status == 200 && response.response != null) {
      return (response.response as ByteBuffer).asUint8List();
    }
    throw Exception('HTTP ${response.status}');
  });
}

bool _isSvgBytes(Uint8List b) {
  if (b.length < 5) return false;
  final header = String.fromCharCodes(
    b.sublist(0, b.length.clamp(0, 100)),
  ).trimLeft();
  return header.startsWith('<svg') || header.startsWith('<?xml');
}

bool _isSvgUrl(String url) {
  final decoded = Uri.decodeFull(url).toLowerCase();
  return decoded.contains('.svg') ||
      decoded.contains('/svg?') ||
      decoded.contains('/svg/') ||
      decoded.endsWith('/svg');
}

Widget _netImg({
  required String url,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  BorderRadius? borderRadius,
  ColorFilter? colorFilter,
  Widget? placeholder,
  Widget? errorWidget,
}) {
  if (url.isEmpty) return errorWidget ?? const SizedBox.shrink();
  final bool hintSvg = _isSvgUrl(url);
  Widget inner = FutureBuilder<Uint8List>(
    future: _xhrLoad(url, isSvg: hintSvg),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return placeholder ?? SizedBox(width: width, height: height);
      }
      if (snapshot.hasData) {
        final bytes = snapshot.data!;
        if (hintSvg || _isSvgBytes(bytes)) {
          return SvgPicture.memory(
            bytes,
            width: width,
            height: height,
            fit: fit,
            colorFilter: colorFilter,
          );
        }
        return Image.memory(bytes, width: width, height: height, fit: fit);
      }
      return errorWidget ??
          Icon(
            Icons.broken_image,
            color: Colors.grey[400],
            size: (width ?? height ?? 24).toDouble(),
          );
    },
  );
  if (borderRadius != null)
    inner = ClipRRect(borderRadius: borderRadius, child: inner);
  if (width != null || height != null)
    inner = SizedBox(width: width, height: height, child: inner);
  return inner;
}

// ══════════════════════════════════════════════════════════════════════════════
// Preload helpers
// ══════════════════════════════════════════════════════════════════════════════

Future<void> _preloadImages(List<String> urls) async {
  final valid = urls
      .where(
        (u) =>
    u.isNotEmpty &&
        (u.startsWith('http://') || u.startsWith('https://')),
  )
      .toSet();
  await Future.wait(
    valid.map(
          (url) =>
          _xhrLoad(url, isSvg: _isSvgUrl(url)).catchError((_) => Uint8List(0)),
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// Top tab icon — CMS navigation-label icon with material-icon fallback
// ══════════════════════════════════════════════════════════════════════════════

/// Renders the CMS-provided navigation label icon ([iconUrl], from the admin
/// app). Falls back to [fallback] material icon when the CMS icon is empty
/// or fails to load.
Widget _topTabIcon({
  required String iconUrl,
  required IconData fallback,
  required Color color,
  required double size,
}) {
  final Widget fallbackIcon = Icon(fallback, color: color, size: size);

  if (iconUrl.isEmpty) return fallbackIcon;

  if (_isSvgUrl(iconUrl)) {
    return SvgPicture.network(
      iconUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      placeholderBuilder: (_) => SizedBox(width: size, height: size),
    );
  }

  return Image.network(
    iconUrl,
    width: size,
    height: size,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => fallbackIcon,
  );
}

/// Material fallback icons for the 4 About-page top tabs.
const List<IconData> _kTopTabFallbackIcons = [
  Icons.info_outline,           // About Us
  Icons.account_tree_outlined,  // Our Strategy
  Icons.description_outlined,   // Terms and Conditions
  Icons.privacy_tip_outlined,   // Privacy Policy
];

// ══════════════════════════════════════════════════════════════════════════════
// Reveal animation system
// ══════════════════════════════════════════════════════════════════════════════

enum _SlideDirection { fromBottom, fromLeft, fromRight, fromTop }
