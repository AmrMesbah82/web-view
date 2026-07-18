// ******************* FILE INFO *******************
// File Name: services_page.dart
// Updated: All sizes normalized to match main.dart ScreenUtil design sizes:
//          Desktop (≥1366) → 1366×768, Tablet (768–1365) → 1024×768,
//          Mobile (<768)   → 375×812
// UPDATED: Full AR / EN bilingual support.
//          PRIMARY COLOR now dynamic from CMS branding.
//          BACKGROUND COLOR now dynamic from CMS branding.headerFooterColor ✅
//          ANIMATION: Scroll-triggered reveal animations on all sections.
//          STICKY NAVBAR: measured dynamically via GlobalKey — content never
//          hides under the navbar.
//          BLOG CARD IMAGE: SVG-only — no Image.network / asset fallback ✅
// FIX: _SvgPulseLoader backgroundColor now uses branding.primaryColor from
//      Firebase. Shows neutral background before Firebase responds, then
//      switches to real primaryColor once HomeCmsLoaded fires.
// FIX: Desktop layout now fully responsive — Flexible wrappers prevent
//      overflow when window is resized/minimized.
// FIX: Navigation now uses GoRouter consistently to prevent GoRouterState errors
// FIX: colorFilter removed from _svgIconBox — icons now render in real colors ✅
// FIX: Blog posts now show up to 5 (was hard-limited to 3) ✅
// FIX: Desktop blog section uses Wrap to support more than 3 posts ✅

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:website_app/core/widgets/format_heper.dart';
import 'package:website_app/features/home/data/models/home_model.dart';
import 'package:website_app/features/services/data/models/services_model.dart';

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/app_wight.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../../core/theme/new_theme.dart';
import '../../../../../core/theme/text.dart';
import '../../../../careers/data/models/careers_model.dart' hide BilingualText;
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';
import '../../../data/models/blog_model.dart';
import '../../controller/blog_cubit.dart';
import '../../controller/blog_state.dart';
import '../../controller/services_cubit.dart';
import '../../controller/services_state.dart';

part '../widgets/services_page_bp.dart';
part '../widgets/reveal_coordinator.dart';
part '../widgets/reveal_coordinator_widget.dart';
part '../widgets/reveal.dart';
part '../widgets/svg_pulse_loader.dart';
part '../widgets/services_header_desktop.dart';
part '../widgets/services_header_mobile.dart';
part '../widgets/services_body.dart';
part '../widgets/services_body_desktop.dart';
part '../widgets/services_body_tablet.dart';
part '../widgets/services_body_mobile.dart';
part '../widgets/service_card_mobile.dart';
part '../widgets/service_card_desktop.dart';
part '../widgets/blog_card_mobile.dart';
part '../widgets/blog_card_desktop.dart';
part '../widgets/read_more_btn_mobile.dart';
part '../widgets/read_more_btn_desktop.dart';

// Default colors (fallback if CMS data unavailable)
const Color _kDefaultGreen = Color(0xFF2D8C4E);
const Color _kGreenLight   = Color(0xFFE8F5EE);
const Color _kSurface      = Color(0xFFFFFFFF);
const Color _kDivider      = Color(0xFFDDE8DD);

// Neutral loader background shown before Firebase responds
const Color _kLoaderNeutral = Color(0xFFF5F5F5);

// Max blog posts shown in the Services page blog section
const int _kMaxBlogPosts = 5;

class ServicesPage extends StatefulWidget {
  final String? scrollTo;
  const ServicesPage({super.key, this.scrollTo});
  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCmsCubit>().load();
      context.read<BlogCubit>().load();
      context.read<HomeCmsCubit>().load();
      _measureNavbar();
    });
  }

  void _measureNavbar() {
    final box =
    _navbarKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final h = box.size.height;
      if (h > 0 && h != _navbarHeight) setState(() => _navbarHeight = h);
    }
  }

  Future<void> _preloadAndReveal(List<String> urls) async {
    if (_preloadStarted) return;
    _preloadStarted = true;

    await _preloadSvgImages(urls);
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      setState(() => _showLoader = false);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _measureNavbar());
    }
  }



   Color _kDefaultPrimary    = Color(0xFF2D8C4E);
   Color _kDefaultBackground = Color(0xFFF5F5F5);
  Color _hexColor(String hex, {required Color fallback}) {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) {
      final value = int.tryParse('FF$h', radix: 16);
      if (value != null) return Color(value);
    }
    return fallback;
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {



        // ── backgroundColor from CMS branding ─────────────────────────────
        final Color backgroundColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          _ => AppColors.background,
        };

        final Color secondaryColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.secondaryColor,
              fallback: _kGreenLight),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.secondaryColor,
              fallback: _kGreenLight),
          _ => _kGreenLight,
        };

        final String logoUrl = switch (homeState) {
          HomeCmsLoaded(:final data) => data.branding.logoUrl,
          HomeCmsSaved(:final data)  => data.branding.logoUrl,
          _ => context.read<HomeCmsCubit>().current.branding.logoUrl,
        };

        final Color primaryColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.primaryColor,
              fallback: _kDefaultGreen),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.primaryColor,
              fallback: _kDefaultGreen),
          _ => _kDefaultGreen,
        };

        final bool homeReady =
            homeState is HomeCmsLoaded || homeState is HomeCmsSaved;

        return BlocBuilder<ServiceCmsCubit, ServiceCmsState>(
          builder: (context, serviceState) {
            final ServicePageModel model = switch (serviceState) {
              ServiceCmsLoaded s => s.data,
              ServiceCmsSaved  s => s.data,
              _                  => ServicePageModel.empty(),
            };

            final bool servicesReady = serviceState is ServiceCmsLoaded ||
                serviceState is ServiceCmsSaved;

            return BlocBuilder<BlogCubit, BlogState>(
              builder: (context, blogState) {
                final bool blogReady =
                    blogState is BlogLoaded || blogState is BlogError;

                final bool allDataReady =
                    homeReady && servicesReady && blogReady;

                if (allDataReady && !_preloadStarted) {
                  final List<String> allUrls = [
                    if (logoUrl.isNotEmpty) logoUrl,
                    ...model.journeyItems.map((e) => e.iconUrl),
                    // ✅ FIX: was .take(3) — now uses _kMaxBlogPosts
                    if (blogState is BlogLoaded)
                      ...blogState.posts
                          .where((p) => p.status == 'published')
                          .take(_kMaxBlogPosts)
                          .map((p) => p.imageUrl),
                  ];
                  _preloadAndReveal(allUrls);
                }

                if (!homeReady) {
                  return Scaffold(backgroundColor: AppColors.background);
                }

                if (_showLoader || !allDataReady) {
                  return _SvgPulseLoader(
                    logoUrl: logoUrl.isEmpty ? null : logoUrl,
                    backgroundColor: backgroundColor,
                  );
                }

                // ✅ FIX: was .take(3) — now uses _kMaxBlogPosts
                final List<BlogPostModel> blogs = blogState is BlogLoaded
                    ? blogState.posts
                    .where((p) => p.status == 'published')
                    .take(_kMaxBlogPosts)
                    .toList()
                    : [];

                return BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, langState) {
                    final bool   isRtl = langState.isArabic;
                    final double w     = MediaQuery.of(context).size.width;

                    return Directionality(
                      textDirection:
                      isRtl ? TextDirection.rtl : TextDirection.ltr,
                      child: Scaffold(
                        backgroundColor: backgroundColor,
                        body: _RevealCoordinatorWidget(
                          child: Column(
                            children: [
                              // ✅ Navbar — always visible at top
                              Material(
                                color: backgroundColor,
                                elevation: 0,
                                child: AppNavbar(
                                  key: _navbarKey,
                                  currentRoute: '/services',
                                ),
                              ),

                              // ✅ Middle content — scrolls, takes all remaining space
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _Reveal(
                                        delay: const Duration(milliseconds: 80),
                                        direction: _SlideDirection.fromLeft,
                                        duration: const Duration(milliseconds: 650),
                                        child: w < _BP.mobile
                                            ? _ServicesHeaderMobile(
                                            model: model,
                                            isRtl: isRtl,
                                            primaryColor: primaryColor)
                                            : _ServicesHeaderDesktop(
                                            model: model,
                                            isRtl: isRtl,
                                            primaryColor: primaryColor),
                                      ),

                                      _ServicesBody(
                                        model: model,
                                        blogs: blogs,
                                        isRtl: isRtl,
                                        primaryColor: primaryColor,
                                        secondaryColor: secondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // ✅ Footer — always visible at bottom
                              _Reveal(
                                delay: const Duration(milliseconds: 100),
                                direction: _SlideDirection.fromBottom,
                                duration: const Duration(milliseconds: 600),
                                child: const AppFooter(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─── Header Desktop ───────────────────────────────────────────────────────────
