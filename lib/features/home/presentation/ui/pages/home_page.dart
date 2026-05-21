// ******************* FILE INFO *******************
// File Name: home_page.dart
// Updated: MOBILE LAYOUT NOW MATCHES FIGMA BENTO GRID DESIGN PERFECTLY
//          branding.backgroundColor drives page/section background.
//          branding.headerFooterColor drives navbar/footer background.
//          Desktop (≥1366) → 1366×768, Tablet (768–1365) → 1024×768,
//          Mobile (<768)   → 375×812
// FIX: _GreenCard height is now optional — container grows with text,
//      no more clipped/ellipsized text in any breakpoint.
// FIX: Hero text constrained to page width — no overflow outside page bounds.
// FIX: Image/icon layout is FIXED (not mirrored) for both AR and EN.
// FIX: _SvgPulseLoader background is now branding.primaryColor from Firebase.
// FIXED: Public page now respects publishStatus — draft / future-scheduled
//        pages show "Coming Soon" placeholder instead of full content.
// Description: Public-facing Home Page — reads HomeCmsCubit and renders
//              all content driven by the CMS model. Zero hardcoded strings.
//              Full AR / EN bilingual support via LanguageCubit.
//              STICKY NAVBAR: GlobalKey measured dynamically.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website_app/features/home/data/models/home_model.dart';

import '../../../../../core/custom_svg.dart';
import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/app_wight.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../careers/data/models/careers_section_model.dart' hide BiText;
import '../../controller/home_cubit.dart';
import '../../controller/home_state.dart';
import '../../controller/lang_state.dart';




part '../widget/home_reveal_animation.dart';
part '../widget/home_svg_pulse_loader.dart';
part '../widget/home_coming_soon_page.dart';
part '../widget/home_body.dart';
part '../widget/home_hero_section.dart';
part '../widget/home_cms_nav_btn.dart';
part '../widget/home_hero_cards.dart';
part '../widget/home_cms_footer.dart';
part '../widget/home_shared_widgets.dart';

// ── Breakpoints ───────────────────────────────────────────────────────────────
class _BP {
  static double get mobile => 600.w;
  static double get tablet => 1024.w;
}

const Color _kDefaultPrimary    = Color(0xFF2D8C4E);
const Color _kDefaultBackground = Color(0xFFF5F5F5);

Color _hexColor(String hex, {required Color fallback}) {
  try {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
  } catch (_) {}
  return fallback;
}

extension BiTextL10n on BiText {
  String l(BuildContext context) {
    final isAr  = context.read<LanguageCubit>().state.isArabic;
    final value = isAr ? ar : en;
    return value.isNotEmpty ? value : en;
  }
}

bool _isNetworkUrl(String url) =>
    url.startsWith('http://') || url.startsWith('https://');

Widget _smartImage({
  required String url,
  required double width,
  required double height,
  BoxFit  fit         = BoxFit.contain,
  Widget? fallback,
  Color?  colorFilter,
}) {
  if (url.isEmpty) return fallback ?? const SizedBox.shrink();
  if (_isNetworkUrl(url)) {
    return Center(
      child: SvgPicture.network(
        url,
        width:  width,
        height: height,
        fit:    fit,
        colorFilter: colorFilter != null
            ? ColorFilter.mode(colorFilter, BlendMode.srcIn)
            : null,
      ),
    );
  }
  return CustomSvg(
    assetPath: url,
    width:     width,
    height:    height,
    fit:       fit,
    color:     colorFilter,
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// ✅ PUBLISH STATUS HELPER
// Determines if the page should be publicly visible
// ═══════════════════════════════════════════════════════════════════════════════

bool _isPageVisible(HomePageModel data) {
  // ✅ Published → always visible
  if (data.publishStatus == 'published') return true;

  // ✅ Scheduled → visible only if the scheduled date has passed
  if (data.publishStatus == 'scheduled' && data.scheduledPublishDate != null) {
    final now = DateTime.now();
    final scheduledDate = data.scheduledPublishDate!;
    // Compare date only (ignore time) — page goes live at start of scheduled day
    final scheduledStart = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );
    return now.isAfter(scheduledStart) || now.isAtSameMomentAs(scheduledStart);
  }

  // ✅ Draft or scheduled without date → not visible
  return false;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SVG PRELOADER
// ═══════════════════════════════════════════════════════════════════════════════

Future<void> _preloadSvgImages(List<String> urls) async {
  final validUrls = urls
      .where((url) =>
  url.isNotEmpty &&
      (url.startsWith('http://') || url.startsWith('https://')))
      .toSet()
      .toList();

  await Future.wait(
    validUrls.map((url) async {
      try {
        final loader = SvgNetworkLoader(url);
        await svg.cache.putIfAbsent(
          loader.cacheKey(null),
              () => loader.loadBytes(null),
        );
      } catch (e) {
      }
    }),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showLoader     = true;
  bool _preloadStarted = false;

  final GlobalKey _navbarKey    = GlobalKey();
  double          _navbarHeight = 80;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted && _showLoader) setState(() => _showLoader = false);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavbar());
  }

  void _measureNavbar() {
    final box = _navbarKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final h = box.size.height;
      if (h > 0 && h != _navbarHeight) setState(() => _navbarHeight = h);
    }
  }

  Future<void> _preloadAndReveal(HomePageModel data) async {
    if (_preloadStarted) return;
    _preloadStarted = true;

    final List<String> allUrls = [
      if (data.branding.logoUrl.isNotEmpty) data.branding.logoUrl,
      for (final sec in data.sections) ...[
        if (sec.iconUrl.isNotEmpty)  sec.iconUrl,
        if (sec.imageUrl.isNotEmpty) sec.imageUrl,
      ],
      for (final sl in data.socialLinks)
        if (sl.iconUrl.isNotEmpty) sl.iconUrl,
    ];

    await _preloadSvgImages(allUrls);
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() => _showLoader = false);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _measureNavbar());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, state) {
        final String logoUrl = switch (state) {
          HomeCmsLoaded(:final data) => data.branding.logoUrl,
          HomeCmsSaved(:final data)  => data.branding.logoUrl,
          _ => context.read<HomeCmsCubit>().current.branding.logoUrl,
        };

        final HomePageModel? readyData = switch (state) {
          HomeCmsLoaded(:final data) => data,
          HomeCmsSaved(:final data)  => data,
          _ => null,
        };

        final Color loaderBg = switch (state) {
          HomeCmsLoaded(:final data) => _hexColor(
              data.branding.primaryColor,
              fallback: _kDefaultPrimary),
          HomeCmsSaved(:final data)  => _hexColor(
              data.branding.primaryColor,
              fallback: _kDefaultPrimary),
          _ => _kDefaultPrimary,
        };

        if (readyData != null && !_preloadStarted) {
          _preloadAndReveal(readyData);
        }

        if (state is HomeCmsError &&
            state.lastData == null &&
            !_showLoader) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                  SizedBox(height: 12.h),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style:
                      TextStyle(color: Colors.red, fontSize: 14.sp)),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<HomeCmsCubit>().load(),
                    child:
                    Text('Retry', style: TextStyle(fontSize: 14.sp)),
                  ),
                ],
              ),
            ),
          );
        }

        if (readyData == null) {
          return Scaffold(backgroundColor: AppColors.background);
        }

        if (_showLoader) {
          debugPrint('🔴 loaderBg = ${readyData.branding.backgroundColor}');
          return _SvgPulseLoader(
            logoUrl: logoUrl.isEmpty ? null : logoUrl,
            backgroundColor: _hexColor(
              readyData.branding.backgroundColor,
              fallback: _kDefaultPrimary,
            ),
          );
        }

        // ✅ PUBLISH STATUS GATE — check if page should be publicly visible
        if (!_isPageVisible(readyData)) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, langState) {
              return _ComingSoonPage(
                data:      readyData,
                navbarKey: _navbarKey,
              );
            },
          );
        }

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
            return _HomeBody(
              data:         readyData,
              isRtl:        langState.isArabic,
              navbarHeight: _navbarHeight,
              navbarKey:    _navbarKey,
            );
          },
        );
      },
    );
  }
}
