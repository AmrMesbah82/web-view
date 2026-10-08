// ******************* FILE INFO *******************
// File Name: smart_network_image.dart
// Purpose: BUG-68 / BUG-18 — logos and Home section images can now be PNG /
//          JPG / WebP as well as SVG. Everything used to be drawn with
//          SvgPicture.network, which can't draw a bitmap.
//
//          • URL path ends in .svg  → SvgPicture.network (bitmap fallback)
//          • anything else          → Image.network (SVG fallback, because
//            older uploads were SVGs stored under a ".png" name)
//          • both fail / empty URL  → [fallback] (e.g. the bundled logo), so a
//            blocked Storage request (BUG-18, ERR_BLOCKED_BY_ORB) never shows a
//            broken-image icon.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SmartNetworkImage extends StatelessWidget {
  const SmartNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallback,
    this.svgColorFilter,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// Shown while loading fails or when [url] is empty.
  final Widget? fallback;

  /// Tint for SVGs only (bitmaps are shown as-is).
  final ColorFilter? svgColorFilter;

  static bool looksLikeSvg(String url) {
    final path = Uri.decodeComponent(url.split('?').first).toLowerCase();
    return path.endsWith('.svg');
  }

  Widget get _fallback => fallback ?? SizedBox(width: width, height: height);

  Widget _svg({Widget? onError}) => SvgPicture.network(
        url,
        width: width,
        height: height,
        fit: fit,
        colorFilter: svgColorFilter,
        placeholderBuilder: (_) => SizedBox(width: width, height: height),
        errorBuilder: (_, __, ___) => onError ?? _fallback,
      );

  Widget _bitmap({Widget? onError}) => Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => onError ?? _fallback,
      );

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return _fallback;
    return looksLikeSvg(url)
        ? _svg(onError: _bitmap())
        : _bitmap(onError: _svg());
  }
}
