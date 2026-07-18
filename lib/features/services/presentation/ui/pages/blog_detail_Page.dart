// ******************* FILE INFO *******************
// File Name: blog_detail_page.dart
// Updated: All blog data now sourced from Firebase via BlogCubit / BlogPostModel.
//          Branding colors still come from HomeCmsCubit.
//          Supports bilingual (EN / AR), all block types (paragraph,
//          numbering, bulletPoint), Read More / Read Less, responsive
//          Mobile + Desktop layouts.
//          BLOG IMAGE: SVG-only — no Image.network fallback ✅

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:website_app/core/theme/new_theme.dart';

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../../core/theme/text.dart';
import '../../../../../core/widgets/format_heper.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';
import '../../../data/models/blog_model.dart';
import '../../controller/blog_cubit.dart';
import '../../controller/blog_state.dart';

part '../widgets/services_helpers.dart';
part '../widgets/mobile_body.dart';
part '../widgets/desktop_body.dart';
part '../widgets/block_list.dart';
part '../widgets/blog_image.dart';
part '../widgets/blog_nav_button.dart';

// ── Fallback colors ───────────────────────────────────────────────────────────
const Color _kFallbackPrimary   = Color(0xFF2D8C4E);
const Color _kFallbackSecondary = Color(0xFFE8F5EE);
const Color _kDivider           = Color(0xFFDDE8DD);
const Color _kSurface           = Color(0xFFFFFFFF);
const Color _kFallbackBackground = Color(0xFFF1F2ED);

Color _parseColor(String hex, {Color fallback = _kFallbackPrimary}) {
  final h = hex.replaceAll('#', '');
  if (h.length == 6) {
    final value = int.tryParse('FF$h', radix: 16);
    if (value != null) return Color(value);
  }
  return fallback;
}

class BlogDetailPage extends StatefulWidget {
  /// Pass a post id to open a specific post directly.
  /// If null, the first published post is shown.
  final String? initialPostId;

  const BlogDetailPage({super.key, this.initialPostId});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  String? _selectedPostId;
  bool    _expanded = false;

  @override
  void initState() {
    super.initState();
    _selectedPostId = widget.initialPostId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogCubit>().load();
      context.read<HomeCmsCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {
        final Color primary = switch (homeState) {
          HomeCmsLoaded(:final data) =>
              _parseColor(data.branding.primaryColor),
          HomeCmsSaved(:final data) =>
              _parseColor(data.branding.primaryColor),
          _ => _kFallbackPrimary,
        };

        final Color secondary = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.secondaryColor,
              fallback: _kFallbackSecondary),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.secondaryColor,
              fallback: _kFallbackSecondary),
          _ => _kFallbackSecondary,
        };

        // Page background comes from the admin (branding.backgroundColor).
        final Color background = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: _kFallbackBackground),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: _kFallbackBackground),
          _ => _kFallbackBackground,
        };

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
            final bool isRtl = langState.isArabic;

            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: BlocBuilder<BlogCubit, BlogState>(
                builder: (context, blogState) {
                  // ── Loading ─────────────────────────────────────
                  if (blogState is BlogLoading) {
                    return Scaffold(
                      backgroundColor: background,
                      body: Column(
                        children: [
                          AppNavbar(currentRoute: '/services'),
                          Expanded(child: Center(child: CircularProgressIndicator(color: primary))),
                          const AppFooter(),
                        ],
                      ),
                    );
                  }

                  // ── Error ───────────────────────────────────────
                  if (blogState is BlogError) {
                    return Scaffold(
                      backgroundColor: background,
                      body: Column(
                        children: [
                          AppNavbar(currentRoute: '/services'),
                          Expanded(
                            child: Center(
                              child: Text(
                                blogState.message,
                                style: StyleText.fontSize14Weight400.copyWith(fontFamily: 'Cairo', color: Colors.red),
                              ),
                            ),
                          ),
                          const AppFooter(),
                        ],
                      ),
                    );
                  }

                  // ── Data ready ──────────────────────────────────
                  final List<BlogPostModel> posts =
                  blogState is BlogLoaded
                      ? blogState.posts.where((p) => p.status == 'published').toList()
                      : [];

                  if (posts.isEmpty) {
                    return Scaffold(
                      backgroundColor: background,
                      body: Column(
                        children: [
                          AppNavbar(currentRoute: '/services'),
                          Expanded(
                            child: Center(
                              child: Text(
                                isRtl ? 'لا توجد مقالات منشورة.' : 'No published posts.',
                                style: StyleText.fontSize14Weight400.copyWith(fontFamily: 'Cairo', color: Colors.black54),
                              ),
                            ),
                          ),
                          const AppFooter(),
                        ],
                      ),
                    );
                  }

                  // Resolve selected post
                  final BlogPostModel selectedPost = posts.firstWhere(
                        (p) => p.id == _selectedPostId,
                    orElse: () => posts.first,
                  );

                  final double w = MediaQuery.of(context).size.width;
                  final bool isMobile = w < _BP.mobile;

                  return Scaffold(
                    backgroundColor: background,
                    body: Column(
                      children: [
                        // ✅ Navbar — fixed at top
                        AppNavbar(currentRoute: '/services'),

                        // ✅ Content — scrolls
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                isMobile
                                    ? _MobileBody(
                                  posts: posts,
                                  selected: selectedPost,
                                  expanded: _expanded,
                                  isRtl: isRtl,
                                  primary: primary,
                                  secondary: secondary,
                                  onTabChange: (id) => setState(() {
                                    _selectedPostId = id;
                                    _expanded = false;
                                  }),
                                  onToggleExpand: () => setState(() => _expanded = !_expanded),
                                )
                                    : _DesktopBody(
                                  posts: posts,
                                  selected: selectedPost,
                                  expanded: _expanded,
                                  isRtl: isRtl,
                                  primary: primary,
                                  secondary: secondary,
                                  onTabChange: (id) => setState(() {
                                    _selectedPostId = id;
                                    _expanded = false;
                                  }),
                                  onToggleExpand: () => setState(() => _expanded = !_expanded),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ✅ Footer — fixed at bottom
                        const AppFooter(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE BODY
// ═══════════════════════════════════════════════════════════════════════════════
